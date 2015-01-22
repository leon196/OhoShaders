Shader "Custom/HologramStarWars" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        Lighting Off
        LOD 200
        CGPROGRAM
        #pragma surface surf Lambert
        #include "UnityCG.cginc"

        // Dat random function for glsl
        float rand(float2 co){ return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453); }

        // Pixelize coordinates
        float2 pixelize(float2 uv, float details) { return floor(uv.xy * details) / details; }

        sampler2D _MainTex;
        uniform float timeElapsed;
        half4 _Color;

        struct Input {
            float2 uv_MainTex;
            float4 screenPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float2 uv =  IN.uv_MainTex;
            float2 screenUV = IN.screenPos.xy;

            float random1 = rand(pixelize(uv - float2(0, timeElapsed * 0.1), pow(2.0, 10.0)).yy);
            float random2 = rand(pixelize(uv + float2(0, timeElapsed * 0.1), pow(2.0, 6.0)).yy) * 0.025 * random1;
            float random3 = rand(pixelize(float2(0, timeElapsed), pow(2.0, 4.0)).yy);
            float random4 = rand(pixelize(uv + float2(0, timeElapsed * 0.1), pow(2.0, 10.0)).yy);

            float timing = (cos(timeElapsed) * 0.5 + 0.5);
            float timingGlitch = step(random3, timing);

            half4 textureGlitch = tex2D (_MainTex, uv + random2);

            half4 textureColor = tex2D (_MainTex, uv);

            // float blurSize = 1.0/1024.0;
   			// half4 textureBlur = tex2D(_MainTex, uv) * 0.16;
			// textureBlur += tex2D(_MainTex, float2(uv.x - 4.0*blurSize, uv.y)) * 0.05;
			// textureBlur += tex2D(_MainTex, float2(uv.x - 3.0*blurSize, uv.y)) * 0.09;
			// textureBlur += tex2D(_MainTex, float2(uv.x - 2.0*blurSize, uv.y)) * 0.12;
			// textureBlur += tex2D(_MainTex, float2(uv.x - blurSize, uv.y)) * 0.15;
			// textureBlur += tex2D(_MainTex, float2(uv.x + blurSize, uv.y)) * 0.15;
			// textureBlur += tex2D(_MainTex, float2(uv.x + 2.0*blurSize, uv.y)) * 0.12;
			// textureBlur += tex2D(_MainTex, float2(uv.x + 3.0*blurSize, uv.y)) * 0.09;
			// textureBlur += tex2D(_MainTex, float2(uv.x + 4.0*blurSize, uv.y)) * 0.05;

			float4 color = lerp(textureColor, textureGlitch, timingGlitch);

            float luminance = (color.r + color.g + color.b) / 3.0;

            o.Emission = _Color.rgb * luminance;
            o.Alpha = color.a * _Color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}