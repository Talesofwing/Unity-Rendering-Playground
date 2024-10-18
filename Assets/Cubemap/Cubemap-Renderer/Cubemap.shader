Shader "zer0/Cubemap/Cubemap" {

    Properties {
		_Cubemap ("Reflection Cubemap", Cube) = "_Skybox" {}
    }

    SubShader {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass {

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			samplerCUBE _Cubemap;

            struct a2v {
                float4 pos : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                fixed3 worldNormal : TEXCOORD1;
            };

            v2f vert (a2v i) {
                v2f o;
                o.pos = UnityObjectToClipPos(i.pos);
                o.worldNormal = UnityObjectToWorldNormal(i.normal);
                o.worldPos = mul (unity_ObjectToWorld, i.pos).xyz;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed3 worldNormal = normalize (i.worldNormal);
                fixed3 worldLightDir = normalize (UnityWorldSpaceLightDir (i.worldPos));
                fixed3 worldViewDir = normalize (UnityWorldSpaceViewDir (i.worldPos));
                fixed3 worldRefl = reflect (-worldViewDir, i.worldNormal);
                fixed3 reflection = texCUBE(_Cubemap, worldRefl).rgb;

                return fixed4 (reflection, 1.0);
            }

            ENDCG

        }

    }

    FallBack "Reflective/VertexLit"
}
