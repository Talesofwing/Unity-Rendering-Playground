Shader "zer0/Post-Processing/Bloom"
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
            float2 uv : TEXCOORD0;
        };

        sampler2D _MainTex;

        fixed luminance(fixed3 color) 
        {
            return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
        }

        fixed hard_threshold(fixed3 color, fixed threshold) 
        {
            return step(luminance(color), 1 - threshold);
        }

        fixed linear_threshold(fixed3 color, fixed threshold, float slope) 
        {
            return clamp((luminance(color) - threshold) * slope, 0.0, 1.0);
        }

        fixed quadratic_threshold(fixed3 color, fixed threshold, fixed knee) 
        {
            fixed l = luminance(color);
            float soft = threshold * knee;
            float rq = clamp(l + soft - threshold, 0.0, 2.0 * soft);
            rq = (rq * rq) / (4.0 * soft + 1e-4);
            return max(rq, l - threshold);
        }

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            return o;
        }

        ENDCG

        Pass
        {
            // Luminance Pass (Hard Threshold)
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            fixed _Threshold;
            float _Intensity;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed3 brightness = hard_threshold(col, _Threshold);
                return fixed4(col * brightness * _Intensity, 1.0);
            }
            
            ENDCG
        }

        Pass
        {
            // Luminance Pass (Linear Threshold)
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            fixed _Threshold;
            float _Intensity;
            float _Slope;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed3 brightness = linear_threshold(col, _Threshold, _Slope);
                return fixed4(col * brightness * _Intensity, 1.0);
            }
            
            ENDCG
        }

        Pass
        {
            // Luminance Pass (Quadratic Threshold)
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            fixed _Threshold;
            float _Intensity;
            float _Knee;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed3 brightness = quadratic_threshold(col, _Threshold, _Knee);
                return fixed4(col * brightness * _Intensity, 1.0);
            }
            
            ENDCG
        }

        UsePass "zer0/Post-Processing/Blurs/Gaussian-Blur/GAUSSIAN_BLUR_VERTICAL"

        UsePass "zer0/Post-Processing/Blurs/Gaussian-Blur/GAUSSIAN_BLUR_HORIZONTAL"

        Pass 
        {
            // Additive Blending
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _Bloom;

            fixed4 frag(v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv.xy) + tex2D(_Bloom, i.uv.xy);
            }

            ENDCG
        }

        Pass 
        {
            // Screen Blending
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _Bloom;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 a = tex2D(_MainTex, i.uv.xy);
                fixed3 b = tex2D(_Bloom, i.uv.xy);
                return fixed4(1 - (1 - a) * (1 - b), 1.0);
            }

            ENDCG
        }
    }
}
