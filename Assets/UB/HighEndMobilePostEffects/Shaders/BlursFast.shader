// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UB/PostEffects/BlursFast"
{
	Properties
	{
		[HideInInspector]_Loop("Loop Count", float) = 9
		[HideInInspector]_Jump("Jump N Pixels", float) = 1
		[HideInInspector]_MainTex("Base (RGB)", 2D) = "" {}
	}

	SubShader
	{
		Pass
		{
            Tags{ "Queue" = "Opaque" }
            Cull Off ZWrite Off ZTest Always
			//ZTest Always 
			//Cull Off
			//Fog{ Mode off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Loop;
			float _Jump;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float2 Circle(float mStart, float mPoints, float mPoint) 
			{
				float Rad = (3.141592 * 2.0 * (1.0 / mPoints)) * (mPoint + mStart);
				return float2(sin(Rad), cos(Rad));
			}

			fixed4 frag(v2f i) : COLOR
			{
				float stepX = (1.0 / (_ScreenParams.xy / _ScreenParams.w).x);
				float stepY = (1.0 / (_ScreenParams.xy / _ScreenParams.w).y);

				half4 color = float4 (0,0,0,0);

				fixed2 copyUV;

				for(int x = 1; x<=_Loop; x++)
				{
					copyUV = i.uv + Circle(0, _Loop, x)*float2(stepX,stepY)*_Jump;
					color += tex2D (_MainTex, copyUV)/_Loop;

				}

				return color;
			}

			ENDCG
		}
	}
}

