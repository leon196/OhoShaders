Shader "Custom/Perlin" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Scale ("Scale", Range (1.0, 60.0)) = 10.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		half4 _Color;
		float _Scale;
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

			float2 uv = IN.uv_MainTex.xy * _Scale;
			// float perlin = noise(float3(uv.x, uv.y, 0.0));

			// This code is from https://www.shadertoy.com/view/4sSGD1
			// By TekF

			// pixellate
			float pixelSize = 2.0;
			float2 resolution = float2(64.0, 64.0);
			float depthSize = 20.0;
			float2 pixel = uv * resolution - resolution * 0.5 * _Scale;
			pixel = floor(pixel/pixelSize);

			float2 offset = float2(timeElapsed*2000.0, 0.0);
			
			float3 col;
			for ( int i=0; i < 8; i++ )
			{
				// parallax position, whole pixels for retro feel
				float depth = depthSize+float(i);
				float2 uv2 = pixel;// + floor(offset/depth);
				
				uv2 /= resolution;
				uv2 *= depth/depthSize;
				uv2 *= .4*pixelSize;
				
				col = float3(1.0, 1.0, 1.0) * noise(float3(timeElapsed, uv2+.5));
				//tex2D( _MainTex, uv2+.5 ).rgb;
				
				if ( 1.0-col.y < float(i+1)/8.0 )
				{
					col = lerp( _Color.rgb, col, exp2(-float(i)*.1) );
					break;
				}
			}
			
			//tex2D (_MainTex, IN.uv_MainTex);
			o.Emission = col.rgb;
			o.Alpha = 1.0;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
