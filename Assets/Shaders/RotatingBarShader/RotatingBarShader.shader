Shader "MyShaders/RotatingBarShader"
{
    // From https://www.youtube.com/watch?v=rXn86kVyEe4
    // "Writing Custom Bar Shader In Unity | Shaders Without Textures"

    Properties
    {
        _Color("Color: ", color) = (0,0,0,0)
        _Speed("Speed: ", float) = 10
        _Intensity("Intensity: ", float) = 50
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Color;
            float _Speed;
            float _Intensity;

            fixed4 frag (v2f i) : SV_Target
            {
                float barEffect = sin(
                    (1 - i.uv.x) // have bars move from left to right
                    * _Intensity // number of bars
                    + _Time.y * _Speed) // rotate bars
                    * 0.5 + 0.5; // sinus returns value [-1..1], transform to [0..1]
                float4 color = barEffect * _Color;

                return fixed4(color.rgb, barEffect);
            }
            ENDCG
        }
    }
}
