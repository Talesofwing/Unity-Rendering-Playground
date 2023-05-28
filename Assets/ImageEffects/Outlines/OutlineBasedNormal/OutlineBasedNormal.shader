Shader "zer0/Image Effects/Outlines/Outline Based Normal" {
    
    Properties {
        _OutlineColor ("Outline Color", Color) = (0, 1, 0, 1)
        _OutlineSize ("Outline Size", Int) = 4
    }

    SubShader {
        Tags { "Queue" = "Transparent" }

        Pass {
            ZWrite Off
            Cull Front
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #include "UnityCG.cginc"

            fixed4 _OutlineColor;
            float _OutlineSize;

            struct v2f {
                float4 pos : SV_POSITION;
            };

            #pragma vertex vert
            #pragma fragment frag

            v2f vert (appdata_base i) {
                v2f o;
                i.vertex.xyz += i.normal.xyz * _OutlineSize;
                o.pos = UnityObjectToClipPos (i.vertex);
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