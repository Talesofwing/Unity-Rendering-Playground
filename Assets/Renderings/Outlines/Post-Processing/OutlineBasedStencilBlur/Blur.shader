Shader "zer0/Outlines/Post-Processing/Outline Based Stencil Blur/Blur" {
    
    Properties {
        [NoScaleOffset] _MainTex ("Stencil Tex", 2D) = "white" {}
        _BlurScale ("Blur Scale", Range (0.1, 3)) = 2
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest

            sampler2D _MainTex;
            half4 _MainTex_TexelSize;
            float _BlurScale;

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv[4] : TEXCOORD0;
            };

            v2f vert(appdata_img i) {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);

                float2 uv = i.texcoord;

                o.uv[0] = uv + _MainTex_TexelSize.xy * half2(1, 1) * _BlurScale;     // right top
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(1, -1) * _BlurScale;    // right bottom
                o.uv[2] = uv + _MainTex_TexelSize.xy * half2(-1, 1) * _BlurScale;    // left top
                o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, -1) * _BlurScale;   // left bottom

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                fixed4 color1 = tex2D(_MainTex, i.uv[0]);
                fixed4 color2 = tex2D(_MainTex, i.uv[1]);
                fixed4 color3 = tex2D(_MainTex, i.uv[2]);
                fixed4 color4 = tex2D(_MainTex, i.uv[3]);
                fixed4 color;

                // Check if there are any pixels included in the stencil texture.

                color.rgb = max(color1.rgb, color2.rgb);
                color.rgb = max(color.rgb, color3.rgb);
                color.rgb = max(color.rgb, color4.rgb);
                color.a = (color1.a + color2.a + color3.a + color4.a) / 4;

                return color;
            }

            ENDCG

        }

    }

    FallBack Off
}