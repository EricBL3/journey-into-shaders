Shader "USB/USB_simple_color"
{
    Properties
    {
        [Header(Specular properties)]
        _Specularity ("Specularity", Range(0.01, 1)) = 0.08
        _Brightness ("Brightness", Range(0.01, 1)) = 0.08
        _SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
        [Space(20)]
        [Header(Texture Properties)]
         _MainTex ("Texture", 2D) = "white" {}

        _Reflection("Reflection", Cube) = "black" {}
        _3DTexture("3D Texture", 3D) = "white" {}
        _Factor("Color Factor", Float) = 0.3
        _Cid("Color id", Int) = 2
        _Color("Tint", Color) = (1, 1, 1, 1)
        _VPos("Vertex Position", Vector) = (0, 0, 0, 1)

        [Toggle] _Enable("Enable ?", Float) = 0

        [KeywordEnum(Off, Red, Blue)]
        _Options("Color Options", Float) = 0

        [Enum(Off, 0, Front, 1, Back, 2)]
        _Face ("Face Culling", Float) = 0

        [PowerSlider(3.0)]
        _Brightness("Brightness", Range (0.01, 1)) = 0.08

        [IntRange]
        _Samples ("Samples", Range(0, 255)) = 100

        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull[_Face]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#pragma shader_feature _ENABLE_ON
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE

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
            float4 _Color;
            float _Brightness;
            int _Samples;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
                #if _OPTIONS_OFF
                    return col;
                #elif _OPTIONS_RED
                    return col * float4(1, 0, 0, 1);
                #elif _OPTIONS_BLUE
                    return col * float4(0, 0, 1, 1);
                #endif
            }
            ENDCG
        }
    }
}
