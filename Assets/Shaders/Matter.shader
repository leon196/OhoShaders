Shader "Custom/Matter" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _LightOffset ("Light Offset", Range (0.0, 2.0)) = 1.0
        _Color ("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		half4 _Color;
		float _LightOffset;

		uniform float timeElapsed;

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
		};

        // Dat random function for glsl 
        float rand(float2 co){ return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453); }

        // Pixelize coordinates
        float2 pixelize(float2 uv, float details) { return floor(uv.xy * details) / details; }

		void vert (inout appdata_full v) 
		{
			v.vertex.xzy += 0.05 * v.normal.zxy * cos(4.0 * timeElapsed + v.vertex.x + v.vertex.z + v.vertex.y);
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half3 light = dot(normalize(IN.viewDir), -o.Normal) + _LightOffset;

			o.Emission = _Color.rgb * (1.0 - light) + light;
			o.Alpha = 1.0;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
