Shader "zer0/Post-Processing/Color Grading"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            #include "Assets/_Common/Shaders/CGIncludes/Tools.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Brightness;
			float _Saturation;
			float _Contrast;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float3 Brightness(float3 col, float brigthness) {
                return col * brigthness;
            }

            float3 Saturation(float3 col, float luminance, float saturation) {
                float3 c = float3(luminance, luminance, luminance);
                return lerp(c, col, saturation);
            }

            float3 Contrast(float3 col, float contrast) {
                float3 centered = col - 0.5;
                float3 adjusted = centered * contrast;
                return adjusted + 0.5;
            }

            float4 frag (v2f i) : SV_Target
            {   
                float4 col = tex2D(_MainTex, i.uv);
                float a = col.a;    

                float3 final;
                final = Brightness(col, _Brightness);
                final = Saturation(final, Luminance(col.rgb), _Saturation);
                final = Contrast(final, _Contrast);
                
                return float4(final, a);
            }
            ENDCG
        }
    }
}
