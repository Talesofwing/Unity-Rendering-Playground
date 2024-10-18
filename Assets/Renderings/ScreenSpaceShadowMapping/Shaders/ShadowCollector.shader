Shader "zer0/Shadow Collector"  {

	Subshader {
		ZTest off 
		Lighting Off
		ZWrite Off
		
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			sampler2D _CameraDepthTex;
			sampler2D _LightDepthTex;

			float4x4 _InverseVP;
			float4x4 _WorldToLight;

			struct a2v {
				float4 pos : POSITION;
				float4 uv : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			v2f vert (a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos (i.pos);
				o.uv = i.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed cameraDepth = tex2D(_CameraDepthTex, i.uv).r;
				cameraDepth = 1 - cameraDepth;		// Reversed-Z [1, 0] -> [0, 1]

				// Reconstructs world position
				float4 clipPos;
				clipPos.xy = i.uv * 2 - 1;	// Center pixel
				clipPos.z = cameraDepth;
				clipPos.w = 1;

				float4 posWorld = mul(_InverseVP, clipPos);
				posWorld /= posWorld.w;

				fixed4 light_pos = mul(_WorldToLight, posWorld);

				fixed2 uv = light_pos.xy;
				uv = uv * 0.5 + 0.5;	// [-1, 1] -> [0, 1]

				fixed depth = light_pos.z / light_pos.w;
				depth = 1 - depth;		// Reversed-Z [1, 0] -> [0, 1]

				fixed light_depth = tex2D(_LightDepthTex, uv).r;

				fixed shadow = (light_depth < depth - 0.05) ? 0 : 1;

				return shadow;
			}

			ENDCG
		}

	}

	Fallback off
}