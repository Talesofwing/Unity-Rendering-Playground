Shader "zer0/Outlines/Outline Based Stencil" {
    
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0, 1, 0, 1)
        _OutlineSize ("Outline Size", Int) = 4
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {
            Tags { "LightMode" = "ForwardBase" "Queue" = "Geometry + 1" }
            Stencil {
                Ref 1
                Comp Always
                Pass Replace
            }

            CGPROGRAM

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _OutlineColor;
            float _OutlineSize;

            struct a2v {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            #pragma vertex vert
            #pragma fragment frag

            v2f vert (a2v i) {
                v2f o;
                o.pos = UnityObjectToClipPos (i.vertex);
                o.uv = TRANSFORM_TEX (i.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                return tex2D (_MainTex, i.uv);
            }

            ENDCG

        }

        Pass {
            Tags { "LightMode" = "ForwardBase" "Queue" = "Geometry + 2" }
            Stencil {
                Ref 1
                Comp NotEqual
                Pass Keep
            }

            CGPROGRAM

            #include "UnityCG.cginc"

            fixed4 _Color;
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

                // Calculating in the model space can cause the problem of
                // exaggerating the near and diminishing the far
                i.vertex.xyz += i.normal * _OutlineSize;
                o.pos = UnityObjectToClipPos (i.vertex);

                // Calculates in the view space
                // The difference is not significant.
                // o.pos = UnityObjectToClipPos (i.vertex);
                // fixed3 vNormal = normalize (mul ((float3x3)UNITY_MATRIX_IT_MV, i.normal));
                // fixed2 pNormal = TransformViewToProjection (vNormal.xy);
                // o.pos.xy += pNormal * _OutlineSize;

                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                return _OutlineColor;
            }

            ENDCG

        }

    }

    FallBack Off
}