Shader "zer0/Diffuse-Shadow"  {

	Properties {
		_MainTex ("Main Tex", 2D) = "white" {}
		_Color ("Main Color", Color) = (1, 1, 1, 1)
	}

	Subshader {
		Tags {"RenderType" = "Opaque" "LightMode" = "ForwardBase"}

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"

			sampler2D _ScreenSpceShadowMap;
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct a2v {
				float4 pos : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed4 clip_pos : TEXCOORD1;
				float3 world_normal : TEXCOORD2;
			};
			
			v2f vert (a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos (i.pos);
				o.uv = TRANSFORM_TEX (i.uv, _MainTex);
				o.clip_pos = o.pos;
				o.world_normal = normalize (mul (i.normal, (float3x3)unity_WorldToObject));
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed4 albedo = tex2D (_MainTex, i.uv) * _Color;

				i.clip_pos.xy = i.clip_pos.xy / i.clip_pos.w;
				float2 screen_uv = i.clip_pos.xy * 0.5 + 0.5f;		// pixel center

			// #if UNITY_UV_STARTS_AT_TOP
				// DirectX
				screen_uv.y = _ProjectionParams.x < 0 ? 1 - screen_uv.y : screen_uv.y;
			// #endif

				fixed shadow = tex2D (_ScreenSpceShadowMap, screen_uv).r;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 world_light = normalize (_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * albedo * saturate (dot (i.world_normal, world_light));

				return fixed4 (ambient + diffuse * shadow, 1.0);
			}

			ENDCG
		}

	}

	Fallback off
}