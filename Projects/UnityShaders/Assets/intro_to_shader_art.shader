Shader "Unlit/intro_to_shader_art"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed3 og_palette(float t, fixed3 a, fixed3 b, fixed3 c, fixed3 d) 
            {
                return a + b * cos(6.28318 * (c * t + d));
            }

            fixed3 palette(float t)
            {
                fixed3 a = fixed3(1.118, 0.948, 0.558);
                fixed3 b = fixed3(-1.306, 0.533, 0.370);
                fixed3 c = fixed3(0.608, 0.608, 0.863);
                fixed3 d = fixed3(-0.273, -1.273, -0.443);

                return og_palette(t, a, b, c, d);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 uv = i.uv * 2.0 - 1.0;
                fixed2 uv0 = uv;
                fixed3 finalColor = fixed3(0.0, 0.0, 0.0);

                for(float i = 0.0; i < 4.0; i++)
                {
                    uv = frac(uv * 1.5) - 0.5;
                    
                    float d = length(uv) * exp(-length(uv0));

                    fixed3 col = palette(length(uv0) + i * 0.4 + _Time * 0.4);

                    d = sin(d * 8.0 + _Time) / 8.0;
                    d = abs(d);
                    d = pow(0.01 / d, 1.8);

                    finalColor += col * d;
                }

                fixed4 col = fixed4(finalColor, 1.0);
                return col;
            }
            ENDCG
        }
    }
}
