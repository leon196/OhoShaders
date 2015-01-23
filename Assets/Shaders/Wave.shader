Shader "Custom/Wave" {
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
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float4 _Color;
		uniform float timeElapsed;

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
        // Dat random function for glsl
        float rand(float2 co){ return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453); }

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float3 position;
		};

		void vert (inout appdata_full v, out Input o) 
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);

			float wave = noise(v.vertex + timeElapsed * 0.2);
			float wave2 = cos(timeElapsed + v.vertex.x + v.vertex.y * 0.5);
			float wave3 = noise(v.vertex - timeElapsed);
			v.vertex.xyz += v.normal.xyz + float3(0.0, 0.0, 10.0) * wave;//lerp(wave, wave2, 0.25);
			o.position = v.vertex.xyz;
		}

		void surf (Input IN, inout SurfaceOutput o) {

			float luminance = IN.worldPos.y / 2.0;
			o.Albedo = o.Normal.xyz;//_Color.rgb * luminance;
			o.Alpha = _Color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
