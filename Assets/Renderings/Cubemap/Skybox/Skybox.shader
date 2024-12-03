Shader "zer0/Cubemap/Skybox" {

    Properties 
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _Exposure ("Exposure", Range(0, 8)) = 1
        _Rotation ("Rotation", Range(0, 360)) = 0
		[NoScaleOffset] _Cubemap ("Cubemap", Cube) = "_Cubemap" {}
    }

    SubShader 
    {
        Tags { "RenderType" = "Background" "Queue" = "Background" "PreviewType" = "Skybox" }

        Pass {
            ZWrite Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

            float4 _Tint;
			samplerCUBE _Cubemap;
            float _Rotation;
            float _Exposure;

            struct a2v 
            {
                float4 pos : POSITION;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float3 viewDir : TEXCOORD0;
            };

            v2f vert(a2v i) {
                v2f o;
                o.pos = UnityObjectToClipPos(i.pos);
                o.viewDir = normalize(mul(unity_WorldToObject, float4(_WorldSpaceCameraPos,1)) - i.pos.xyz);
                return o;
            }

            float4 frag(v2f i) : SV_Target {
                float rad = radians(_Rotation);
                float c = cos(rad);
                float s = sin(rad);
                float3x3 rot = float3x3(
                    c, 0, s,
                    0, 1, 0,
                    -s, 0, c
                );
                i.viewDir = mul(rot, i.viewDir);
                float3 color = texCUBE(_Cubemap, -i.viewDir) * _Tint;

                return float4(color * _Exposure, 1.0);
            }

            ENDCG

        }

    }

}
