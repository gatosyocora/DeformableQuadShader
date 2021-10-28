Shader "Gato/DeformableQuad_Unlit"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
		[Enum(UnityEngine.Rendering.CullMode)]
		_Cull("Cull", Float) = 2

		[Space]
		[Header(Frame)]

		[Toggle]
		_UseFrame("Use Frame", Float) = 0

		_Scale("Scale", Range(0, 1)) = 0.2

		_Thickness("Thickness", Range(0, 1)) = 0.1

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
			
			fixed4 frag(g2f i) : SV_Target
			{
				fixed4 col;
				if (i.uv.x >= 0) {
					col = tex2D(_MainTex, i.uv);
				}
				else {
					col = tex2D(_FrameTex, -i.uv) * _FrameColor;
				}
				return col;
			}
			ENDCG
		}
	}
}
