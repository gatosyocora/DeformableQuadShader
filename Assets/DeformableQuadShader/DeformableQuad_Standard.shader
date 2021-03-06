Shader "Gato/DeformableQuad_Standard"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
		[Enum(UnityEngine.Rendering.CullMode)]
		_Cull("Cull", Float) = 2

		_ShadeMinValue("ShadeMinValue", Range(0, 1.0)) = 0

		[Space]
		[Header(Frame)]

		[Toggle]
		_UseFrame("Use Frame", Float) = 0

		_Scale("Scale", Range(0, 0.1)) = 0.075

		_Thickness("Thickness", Range(0, 0.1)) = 0.05

		_FrameTex("Frame Texture", 2D) = "white" {}

		_FrameColor("Frame Color", Color) = (1, 1, 1, 1)
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull [_Cull]

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			#include "DeformableQuad.cginc"
			#include "Lighting.cginc"

			float _ShadeMinValue;
			
			fixed4 frag(g2f i) : SV_Target
			{
				fixed4 col;
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float diffuse = max(_ShadeMinValue, dot(i.normal, lightDir));
				if (i.uv.x >= 0) {
					col = tex2D(_MainTex, i.uv) * diffuse * _LightColor0;
				}
				else {
					col = tex2D(_FrameTex, -i.uv) * diffuse * _LightColor0 * _FrameColor;
				}
				return col;
			}
			ENDCG
		}
	}
}
