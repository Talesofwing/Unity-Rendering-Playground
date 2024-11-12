Shader "zer0/Post-Processing/Blurs/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGINCLUDE

        #include "UnityCG.cginc"

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 uv[5] : TEXCOORD0;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        float2 _MainTex_TexelSize;

        fixed4 frag(v2f i) : SV_Target {
            float weight[3] = {0.4026, 0.2442, 0.0545};
            fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
            for (int it = 1; it < 3; it++) {
                sum += tex2D(_MainTex, i.uv[it * 2 - 1]).rgb * weight[it];
                sum += tex2D(_MainTex, i.uv[it * 2]).rgb * weight[it];
            }
            return fixed4(sum, 1.0f);
        }

        ENDCG

        Pass
        {
            // Vertically
            NAME "GAUSSIAN_BLUR_VERTICAL"

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            float _VerticalBlurSize;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float2 uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv[0] = uv;
                o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.y * 1.0) * _VerticalBlurSize;
                o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0) * _VerticalBlurSize;
                o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.y * 2.0) * _VerticalBlurSize;
                o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0) * _VerticalBlurSize;
                return o;
            }

            ENDCG
        }

        Pass {
            // Horizontally
            NAME "GAUSSIAN_BLUR_HORIZONTAL"

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            float _HorizontalBlurSize;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float2 uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv[0] = uv;
                o.uv[1] = uv + float2(_MainTex_TexelSize.x * 1.0, 0.0) * _HorizontalBlurSize;
                o.uv[2] = uv - float2(_MainTex_TexelSize.x * 1.0, 0.0) * _HorizontalBlurSize;
                o.uv[3] = uv + float2(_MainTex_TexelSize.x * 2.0, 0.0) * _HorizontalBlurSize;
                o.uv[4] = uv - float2(_MainTex_TexelSize.x * 2.0, 0.0) * _HorizontalBlurSize;
                return o;
            }

            ENDCG
        }
    }
}
