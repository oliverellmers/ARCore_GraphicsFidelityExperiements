﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UB/InvisiblesDarkARKit" 
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
   
    SubShader {
        Tags { 
            "RenderType" = "Opaque"
        }

        CGPROGRAM

        #pragma surface surf Mine fullforwardshadows
       
        struct Input {
            float2 uv_MainTex;
            float4 screenPos;
        }; 
       
        uniform sampler2D _MainTex;
        float4 _MainTex_ST;

        half4 LightingMine (SurfaceOutput s, half3 lightDir, half atten) {
            //half NdotL = dot (s.Normal, lightDir);
            //half4 c; 
            //c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 2);
            //c.a = s.Alpha;
            //return c;
            half NdotL = dot (s.Normal, lightDir);
            half4 c; 
            c.rgb = s.Albedo * _LightColor0.rgb * atten;
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o) {
           
            
            //fixed3 nor = UnpackNormal (tex2D(_BumpMap, IN.uv_BumpMap));
           
            fixed2 screenUV = (IN.screenPos.xy) / (IN.screenPos.w);
           
            //screenUV.xy += nor *_ReflDistort;
           
            fixed4 tex = tex2D (_MainTex, screenUV);
           
            o.Albedo = tex.rgb;// *_Color.rgb;
            //o.Normal = nor.rgb;
            //o.Emission = refl *_ReflAmount; 
        }
        ENDCG
    }
   
    FallBack "Diffuse"
}

