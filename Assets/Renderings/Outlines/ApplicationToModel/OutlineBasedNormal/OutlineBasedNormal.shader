Shader "zer0/Outlines/Application/Outline Based Normal" {
    
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _OutlineColor ("Outline Color", Color) = (0, 1, 0, 1)
        _OutlineSize ("Outline Size", Int) = 4
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {
            Tags { "LightMode" = "ForwardBase" }

            Cull Front

            CGPROGRAM

            #include "UnityCG.cginc"

            fixed4 _OutlineColor;
            float _OutlineSize;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
            };

            #pragma vertex vert
            #pragma fragment frag

            v2f vert (a2v i) {             
                
                v2f o;
                i.vertex = mul(UNITY_MATRIX_MV, i.vertex);
                float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, i.normal);
                normal.z = -0.4f;
                i.vertex += float4(normalize(normal), 0) * _OutlineSize;
                o.pos = mul(UNITY_MATRIX_P, i.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                return _OutlineColor;
            }

            ENDCG

        }

        Pass {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #include "UnityCG.cginc"

            fixed4 _Color;

            struct a2v {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 pos : SV_POSITION;
            };

            #pragma vertex vert
            #pragma fragment frag

            v2f vert (a2v i) {
                v2f o;
                o.pos = UnityObjectToClipPos (i.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                return _Color;
            }

            ENDCG

        }

    }

    FallBack Off
}