Shader "zer0/Common/Unlit" {

    Properties {
        _Color ("Color (RGB)", Color) = (1, 1, 1, 0)
        _MainTex ("Main Texture", 2D) = "white" {}
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {

            CGPROGRAM

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;

            #pragma vertex vert
            #pragma fragment frag

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                fixed4 col = tex2D (_MainTex, i.uv) * _Color;
                return col;
            }

            ENDCG

        }

    }

    Fallback Off
}