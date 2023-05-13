Shader "zer0/VertexAnim/Grass" {

    Properties {
        _MainTex ("Main Tex", 2D) = "white" {}
        _Magnitude ("Distortion Magnitude", Float) = 1
        _Frequency ("Distortion Frequency", Float) = 1
    }

    SubShader {
        Tags { "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" "DisableBatching" = "True" }

        Pass {
            Tags { "LightMode" = "ForwardBase" }

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Magnitude;
            float _Frequency;
            float3 _Wind;

            struct a2v {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (a2v i) {
                v2f o;

                float3 displacement;
                displacement = sin (_Wind * _Time.y) * _Magnitude;
                displacement *= i.uv.y;     // the root don't move
                i.pos.xyz += displacement;

                // billboard
                float3 center = float3 (0, 0, 0);
                float3 viewer = mul (unity_WorldToObject, float4 (_WorldSpaceCameraPos, 1));
                float3 normalDir = normalize (viewer - center);
                normalDir.y = 0.0f;     // rotate around y-axis
                float3 upDir = abs (normalDir.y) > 0.999 ? float3 (0, 0, 1) : float3 (0, 1, 0);
                float3 rightDir = normalize (cross (normalDir, upDir));
                upDir = normalize (cross (rightDir, normalDir));
                float3 centerOffset = i.pos.xyz - center;
                float3 localPos = center + rightDir * centerOffset.x + upDir * centerOffset.y + normalDir * centerOffset.z;

                o.pos = UnityObjectToClipPos (localPos);
                o.uv = TRANSFORM_TEX (i.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
 				fixed4 c = tex2D (_MainTex, i.uv);
				
				return c;
            }

            ENDCG

        }

    }

    FallBack "VertexLit"
}