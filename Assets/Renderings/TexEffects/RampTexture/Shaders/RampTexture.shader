Shader "zer0/RampTexture" {

    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        [NoScaleOffset] _RampTex ("Ramp Texture", 2D) = "white" {}
    }

    SubShader {
        Tags {"RenderType" = "Opaque" "Queue" = "Geometry"}

        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			sampler2D _RampTex;
            fixed4 _Tint;

            struct a2v {
                float4 pos : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            v2f vert (a2v i) {
                v2f o;
                o.pos = UnityObjectToClipPos (i.pos);
                o.worldPos = mul (unity_ObjectToWorld, i.pos).xyz;
                // o.worldNormal = mul (i.normal, (float3x3)unity_ObjectToWorld).xyz;
                o.worldNormal = UnityObjectToWorldNormal (i.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                float3 camPos = _WorldSpaceCameraPos;
                fixed3 viewDir = normalize (UnityWorldSpaceViewDir (i.worldPos));
                fixed3 lightDir = normalize (UnityWorldSpaceLightDir (i.worldPos));
                float difLight = max (0, dot (i.worldNormal, lightDir));
                float rimLight = max (0, dot (i.worldNormal, viewDir));
                float difHLambert = difLight * 0.5 + 0.5;
                fixed3 ramp = tex2D (_RampTex, float2 (difHLambert, rimLight)).rgb;

                fixed3 col = ramp;
                return fixed4 (col, 1.0);
            }

            ENDCG

        }

    }

}
