Shader "zer0/Image Effects/Outlines/Outline Based Stencil Blur/Composite" {
    
    Properties {
        [NoScaleOffset] _MainTex ("Source Tex", 2D) = "white" {}
        [NoScaleOffset] _StencilTex ("Stencil Tex", 2D) = "white" {}
        [NoScaleOffset] _BlurTex ("Blur Tex", 2D) = "white" {}
        _OutlineScale ("Outline Scale", Float) = 3
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 0)
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {
            ZTest Always
            Cull Off
            ZWrite Off

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest

            sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			sampler2D _StencilTex;
			sampler2D _BlurTex;
            float _OutlineScale;
            fixed4 _OutlineColor;

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata_img i) {
                v2f o;
                o.pos = UnityObjectToClipPos (i.vertex);
                o.uv = i.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                fixed4 src = tex2D (_MainTex, i.uv);
                fixed4 stencil = tex2D (_StencilTex, i.uv);

                if (any (stencil.rgb)) {
                    return src;
                } else {
                    fixed4 blur = tex2D (_BlurTex, i.uv);
                    fixed4 color;
                    if (any (blur.rgb)) {
                        color.rgb = lerp (src.rgb, _OutlineColor.rgb * _OutlineScale, saturate (blur.a - stencil.a));
                        // color.rgb = _OutlineColor;
                        color.a = src.a;
                    } else {
                        color = src;
                    }
                    return color;
                }
            }

            ENDCG

        }

    }

    FallBack Off
}