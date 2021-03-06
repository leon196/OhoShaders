﻿Shader "Custom/Perlin" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Scale ("Scale", Range (1.0, 100.0)) = 10.0
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

			float3 uv = float3(IN.uv_MainTex.xy * _Scale + timeElapsed, timeElapsed * 0.5);
			float perlin;
            perlin  = 0.5000 * noise( uv ); uv *= 2.01;
            perlin += 0.2500 * noise( uv ); uv *= 2.02;
            perlin += 0.1250 * noise( uv ); uv *= 2.03;
            perlin += 0.0625 * noise( uv ); uv *= 2.04;
			
			//tex2D (_MainTex, IN.uv_MainTex);
			o.Emission = perlin * _Color.rgb;
			o.Alpha = 1.0;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
