Shader "zer0/ImageEffects/Outline Layer" {
    
    Properties {
        _MainTex ("Main Texture", 2D) = "black" {}
        _OutlineTex ("Outline Texture", 2D) = "black" {}
        _EdgeColor ("Edge Color",Color) = (0, 1, 0, 1)
        _EdgeSize ("Edge Size", int) = 4
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {

            CGPROGRAM

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _OutlineTex;
            float2 _OutlineTex_TexelSize;
            fixed4 _EdgeColor;
            float _EdgeSize;

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv[9] : TEXCOORD0;       // uv[4] is the center pixel
            };

            #pragma vertex vert
            #pragma fragment frag

            v2f vert (appdata_img i) {
                v2f o;
                o.pos = UnityObjectToClipPos (i.vertex);

                half2 uv = i.texcoord;
                float horizontal = _OutlineTex_TexelSize.x * _EdgeSize;
                float vertical = _OutlineTex_TexelSize.y * _EdgeSize;

                // 9x9
                o.uv[0] = uv + float2 (-1, -1) * float2 (horizontal, vertical);
                o.uv[1] = uv + float2 (-1, 0) * float2 (horizontal, vertical);
                o.uv[2] = uv + float2 (-1, 1) * float2 (horizontal, vertical);
                o.uv[3] = uv + float2 (0, -1) * float2 (horizontal, vertical);
                o.uv[4] = uv;
                o.uv[5] = uv + float2 (0, 1) * float2 (horizontal, vertical);
                o.uv[6] = uv + float2 (1, -1) * float2 (horizontal, vertical);
                o.uv[7] = uv + float2 (1, 0) * float2 (horizontal, vertical);
                o.uv[8] = uv + float2 (1, 1) * float2 (horizontal, vertical);

                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                float colorCollector = 0.0f;

                // Because the background of the extra camera is set to black, 
                // if the sampled color value isn't black, it means that there is an object at that pixel, 
                // so the original color value can be directly returned.
                fixed4 col = tex2D (_OutlineTex, i.uv[4]);
                if (col.r > 0)
                    return tex2D (_MainTex, i.uv[4]);

                // Checking whether there is a color value in the surrounding 8 pixels. 
                // Here r value is used for judging.
                colorCollector += tex2D (_OutlineTex, i.uv[0]).r;
                colorCollector += tex2D (_OutlineTex, i.uv[1]).r;
                colorCollector += tex2D (_OutlineTex, i.uv[2]).r;
                colorCollector += tex2D (_OutlineTex, i.uv[3]).r;
                colorCollector += tex2D (_OutlineTex, i.uv[5]).r;
                colorCollector += tex2D (_OutlineTex, i.uv[6]).r;
                colorCollector += tex2D (_OutlineTex, i.uv[7]).r;
                colorCollector += tex2D (_OutlineTex, i.uv[8]).r;

                // Return the original texture if there is no color value around it.
                if (colorCollector == 0)
                    return tex2D (_MainTex, i.uv[4]);

                // Return the edge color if there is any color value around it.
                return _EdgeColor;
            }

            ENDCG

        }

    }

}