Shader "zer0/Outlines/Application/Outline Based Fresnel" {
    
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _R0 ("Reflectance", Range(0, 1)) = 0
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {
            Tags { "LightMode" = "ForwardBase" "Queue" = "Geometry" }

            CGPROGRAM

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _OutlineColor;
            float _R0;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 posW : TEXCOORD0;
                float3 normalW : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            #pragma vertex vert
            #pragma fragment frag

            v2f vert (a2v i) {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.normalW = mul(i.normal, (float3x3)unity_WorldToObject).xyz;
                // o.normalW = UnityObjectToWorldNormal (i.normal);
                o.posW = mul(unity_ObjectToWorld, i.vertex);
                o.uv = TRANSFORM_TEX(i.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                float3 n = normalize(i.normalW);
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.posW);
                float fresnel = _R0 + (1 - _R0) * pow(1.0 - saturate(dot(n, viewDir)), 5);
                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed4 outlineColor = fresnel * _OutlineColor;

                return texColor + outlineColor;
            }

            ENDCG

        }

    }

    FallBack Off
}