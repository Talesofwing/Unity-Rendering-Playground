Shader "zer0/Outlines/Outline Based Stencil Smooth Normal" {
    
    Properties {
        _OutlineWidth ("Outline Width", Range (0, 10)) = 8
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
    }

    SubShader {
        // Tags {
        //     "Queue" = "Transparent+1"
        //     "RenderType" = "Transparent"
        //     "DisableBatching" = "True"
        // }

        Pass {
            Cull Off
            ZTest Always
            ZWrite Off
            ColorMask 0

            Stencil {
                Ref 1
                Pass Replace
            }
        }

        Pass {
            ZTest Always
            Cull Off
            // ZWrite Off
            // Blend SrcAlpha OneMinusSrcAlpha

            Stencil {
                Ref 1
                Comp NotEqual
            }

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float _OutlineWidth;
            fixed4 _OutlineColor;

            struct a2v {
                float4 vertex : POSITION;
                fixed3 normal : NORMAL;
                fixed3 smoothNormal : TEXCOORD3;
            };

            struct v2f {
                float4 pos : SV_POSITION;
            };

            v2f vert (a2v i) {
                v2f o;
                fixed3 n = any(i.smoothNormal) ? i.smoothNormal : i.normal;
                fixed3 viewN = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, n));
                float3 viewPos = UnityObjectToViewPos(i.vertex);m

                // Multiplying by −viewPos.z counteracts the perspective transformation, 
                // which causes the outline width to appear larger for closer objects and smaller for distant ones.
                // Dividing by 1000 converts the outline width to a unit of mm.
                o.pos = UnityViewToClipPos(viewPos + viewN * (-viewPos.z) _OutlineWidth / 1000.0f);
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