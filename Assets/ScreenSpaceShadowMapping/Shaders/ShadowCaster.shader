Shader "zer0/Shadow Caster" {

	SubShader {

		Tags { 			
		    "RenderType" = "Opaque"
		}

		Pass {
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
	 
			#include "UnityCG.cginc"
	
			struct a2v {
				float4 pos : POSITION;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 clip_depth : TEXCOORD0;
			};
	
			v2f vert (a2v i) {
				v2f o;
				o.pos = UnityObjectToClipPos(i.pos);
				o.clip_depth = o.pos.zw;
				return o;
			}
		
			fixed4 frag (v2f i) : SV_Target {
				float depth = i.clip_depth.x / i.clip_depth.y;
				depth = 1 - depth;       // Reversed-Z [1, 0] -> [0, 1]
				return depth;
			}

			ENDCG 
		}	

	}

	Fallback Off
}
