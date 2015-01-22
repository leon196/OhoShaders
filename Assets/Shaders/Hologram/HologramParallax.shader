Shader "Custom/HologramParallax" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _ParallaxOffset ("Parallax Offset", Range (0.0, 60.0)) = 10.0
	}
	SubShader {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        Lighting Off
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _ParallaxOffset;
        uniform float timeElapsed;

		struct Input {
			float2 uv_MainTex;
		};

		// hash based 3d value noise
		// function taken from [url]https://www.shadertoy.com/view/XslGRr[/url]
		// Created by inigo quilez - iq/2013
		// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
		 
		// ported from GLSL to HLSL
		float hash( float n )
		{
		    return frac(sin(n)*43758.5453);
		}
		 
		float noise( float3 x )
		{
		    // The noise function returns a value in the range -1.0f -> 1.0f
		 
		    float3 p = floor(x);
		    float3 f = frac(x);
		 
		    f       = f*f*(3.0-2.0*f);
		    float n = p.x + p.y*57.0 + 113.0*p.z;
		 
		    return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
		                   lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
		               lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
		                   lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
		}



		void surf (Input IN, inout SurfaceOutput o) {

            float2 uv =  IN.uv_MainTex;

			//half4 c = tex2D (_MainTex, IN.uv_MainTex);

			// This code is from https://www.shadertoy.com/view/4sSGD1
			// By TekF

			// pixellate
			float pixelSize = 4.0;
			float2 resolution = float2(1024.0, 1024.0);
			float depthSize = 2.0 + _ParallaxOffset;
			float2 pixel = uv * resolution - resolution * 0.5;
			pixel = floor(pixel/pixelSize);
			
			float3 col;
			for ( int i=0; i < 8; i++ )
			{
				// parallax position, whole pixels for retro feel
				float depth = depthSize+float(i);
				float2 uv2 = pixel;
				
				uv2 /= resolution;
				uv2 *= depth/depthSize;
				uv2 *= .4*pixelSize;
				
				col = tex2D( _MainTex, uv2+.5 ).rgb;
				
				if ( 1.0-col.y < float(i+1)/8.0 )
				{
					col = lerp( float3(.4,.6,.7), col, exp2(-float(i)*.1) );
					break;
				}
			}

			o.Emission = col.rgb;

			float lum = (col.r + col.g + col.b) / 3.0;
			o.Alpha = 1.0;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
