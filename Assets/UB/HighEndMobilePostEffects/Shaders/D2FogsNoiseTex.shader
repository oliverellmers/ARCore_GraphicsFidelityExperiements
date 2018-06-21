﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UB/PostEffects/D2FogsNoiseTex" {
    Properties{
        [HideInInspector]_Size("Size", float) = 2.0
		[HideInInspector]_Speed("Horizontal Speed", float) = 0.2
		[HideInInspector]_VSpeed("Vertical Speed", float) = 0
        [HideInInspector]_Density("Density", float) = 1
        [HideInInspector]_MainTex("Base (RGB)", 2D) = "white" {}
        [HideInInspector]_Color("Color", Color) = (1, 1, 1, 1)
		[HideInInspector]_NoiseTex("Noise", 2D) = "white" {}
    }

    Subshader{

        Pass{
            Tags{ "Queue" = "Opaque" }
            Cull Off ZWrite Off ZTest Always
            //Tags{ "Queue" = "Opaque" }

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;
            float _Size;
            float _Speed;
			float _VSpeed;
            float _Density;
            float4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vertexOutput {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            vertexOutput vert(appdata v)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

			float texNoise(float2 uv) {
				return tex2D(_NoiseTex, uv.xy).r;
			}
   
            float fog(in float2 uv)
            {
				float direction = _Time.y * _Speed;
				float Vdirection = _Time.y * _VSpeed;
                float color = 0.0;
                float total = 0.0;
                float k = 0.0;

                for (float i=0; i<6; i++)
                {
					k = pow(2.0, i);
					color += texNoise(
										float2(
												(uv.x * _Size + direction * (i + 1.0)*0.2) * k,
												(uv.y * _Size + Vdirection * (i + 1.0)*0.2) * k
											  )
					                 ) / k;
                    total += 1.0/k;
                }
                color /= total;
                
                return clamp(color, 0.0, 1.0);

            }

            half4 frag(vertexOutput i) : SV_Target
            {
                float f = fog(i.uv);
                float m = min(f*_Density, 1.);
                return tex2D(_MainTex, i.uv)*(1-m)  + m*_Color;
            }
            ENDCG
        }
    }
}