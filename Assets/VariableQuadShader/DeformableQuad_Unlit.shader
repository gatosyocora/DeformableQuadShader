Shader "Gato/DeformableQuad_Unlit"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
		[Enum(UnityEngine.Rendering.CullMode)]
		_Cull("Cull", Float) = 2
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize; // Add this variable
			
			v2f vert (appdata v)
			{
				v2f o;

				// Get width & height of _MainTex
				float w = _MainTex_TexelSize.x;
				float h = _MainTex_TexelSize.y;

				// h > w -> Resize horizontal
				// w > h -> Resize Vertical
				v.vertex.x *= h / max(w, h);
				v.vertex.y *= w / max(w, h);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
