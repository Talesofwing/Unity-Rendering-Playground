Shader "zer0/Shading/Matcap"
{
    Properties
    {

        _Matcap("Matcap", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                fixed3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed3 viewNormal : TEXCOORD1;
            };

            sampler2D _Matcap;
            float4 _Matcap_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _Matcap);
                o.viewNormal = mul((float3x3)UNITY_MATRIX_V, UnityObjectToWorldNormal(v.normal));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.viewNormal.xy * 0.5 + 0.5;

                float2 centered = uv * 2.0 - 1.0;
                if (dot(centered, centered) > 1.0) {
                    return fixed4(0, 0, 0, 1);
                }

                fixed3 col = tex2D(_Matcap, uv);
                return fixed4(col, 1);
            }

            ENDCG
        }
    }
}
