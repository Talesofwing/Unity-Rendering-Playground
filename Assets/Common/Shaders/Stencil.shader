Shader "zer0/Common/Stencil" {
    
    Properties { 
        _Color ("Color", Color) = (1, 0, 0, 0)
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {

            CGPROGRAM

            #include "UnityCG.cginc"

            fixed4 _Color;

            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest

            float4 vert (float4 vertex : POSITION) : SV_POSITION {
                return UnityObjectToClipPos (vertex);
            }

            fixed4 frag (float4 pos : SV_POSITION) : SV_TARGET {
                return _Color;
            }

            ENDCG

        }

    }

    FallBack Off
}