Shader "zer0/Cubemap/Skybox" {

    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
		_Skybox ("Skybox", Cube) = "_Skybox" {}
    }

    SubShader {
        Tags { "RenderType" = "Background" "Queue" = "Background" "PreviewType" = "Skybox" }

        Pass {
            ZWrite Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

            fixed4 _Tint;
			samplerCUBE _Skybox;

            struct a2v {
                float4 pos : POSITION;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert (a2v i) {
                v2f o;
                o.pos = UnityObjectToClipPos(i.pos);
                o.worldPos = mul(unity_ObjectToWorld, i.pos).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                float3 camPos = _WorldSpaceCameraPos;
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 color = texCUBE(_Skybox, -viewDir) * _Tint;

                return fixed4 (color, 1.0);
            }

            ENDCG

        }

    }

}
