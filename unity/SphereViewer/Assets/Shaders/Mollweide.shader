﻿Shader "Custom/Mollweide"
{
    Properties
    {
    	_TintColor ("Tint Color", Color) = (1, 1, 1, 1) // (R, G, B, A)
    	_InitialPosition ("Initial Position", Vector) = (0, 0, 0, 0) // (R, G, B, A)
    	_FinalPosition ("Final Position", Vector) = (1, 1, 1, 1) // (R, G, B, A)
        _MainTex("Image", 2D) = "white"
    }
    Subshader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define PI 3.14

            float4 _TintColor;
            float2 _InitialPosition;
            float2 _FinalPosition;

            sampler _MainTex;

            struct vert_input
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vert_output
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            vert_output vert(vert_input i)
            {
                vert_output o;

                o.vertex = UnityObjectToClipPos(i.vertex);
                o.uv = i.uv;

                return o;
            }

            float4 frag(vert_output o) : COLOR
            {
				float2 raduv = o.uv;
				float2 uv;

				raduv.x = (raduv.x - 0.5) * 4;
				raduv.y = (raduv.y - 0.5) * 2;

				float theta = asin(raduv.y);

				uv.x = PI * raduv.x / (2  * cos(theta));
				uv.y = asin((2*theta + sin(2*theta))/PI);

				uv.x = uv.x / (2*PI) + 0.5;
				uv.y = uv.y * (1/PI) + 0.5;

				if (uv.x >= _InitialPosition.x && uv.x <= _FinalPosition.x &&
            		uv.y >= _InitialPosition.y && uv.y <= _FinalPosition.y) {
            		return _TintColor * tex2D(_MainTex, uv);
            	}

				if (uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1)
				{
					return float4(1,1,1,1);
				}

                return tex2D(_MainTex, uv);
            }

            ENDCG
        }
    }
}