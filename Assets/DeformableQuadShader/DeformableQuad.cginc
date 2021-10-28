#include "UnityCG.cginc"

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
};

struct v2g
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 vertex : TEXCOORD1;
    float3 wnormal : TEXCOORD2;
};

struct g2f
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
};

sampler2D _MainTex;
float4 _MainTex_ST;
float4 _MainTex_TexelSize; // Add this variable

float _UseFrame;
float _Scale;
float _Thickness;
sampler2D _FrameTex;

v2g vert (appdata v)
{
    v2g o;

    // Get width & height of _MainTex
    float w = _MainTex_TexelSize.z;
    float h = _MainTex_TexelSize.w;

    // h > w -> Resize horizontal
    // w > h -> Resize Vertical
    v.vertex.x *= w / max(w, h);
    v.vertex.y *= h / max(w, h);

    o.vertex = v.vertex;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.wnormal = UnityObjectToWorldNormal(v.normal);
    return o;
}

float3 calcWorldNormal(float3 p1, float3 p2, float3 p3) {
    float3 vec1 = p2 - p1;
    float3 vec2 = p3 - p2;
    return UnityObjectToWorldNormal(normalize(cross(vec1, vec2)));
}

void addRectangle(inout TriangleStream<g2f> outStream, float3 p1, float3 p2, float3 p3, float3 p4) {
    g2f o;
    float3 normal = calcWorldNormal(p1, p2, p3);
    o.pos = UnityObjectToClipPos(p1);
    o.uv = -float2(0, 0);
    o.normal = normal;
    outStream.Append(o);
    o.pos = UnityObjectToClipPos(p2);
    o.uv = -float2(1, 0);
    o.normal = normal;
    outStream.Append(o);
    o.pos = UnityObjectToClipPos(p3);
    o.uv = -float2(1, 1);
    o.normal = normal;
    outStream.Append(o);
    outStream.RestartStrip();

    normal = calcWorldNormal(p3, p4, p1);
    o.pos = UnityObjectToClipPos(p3);
    o.uv = -float2(1, 1);
    o.normal = normal;
    outStream.Append(o);
    o.pos = UnityObjectToClipPos(p4);
    o.uv = -float2(1, 0);
    o.normal = normal;
    outStream.Append(o);
    o.pos = UnityObjectToClipPos(p1);
    o.uv = -float2(0, 0);
    o.normal = normal;
    outStream.Append(o);
    outStream.RestartStrip();
}

[maxvertexcount(42)]
void geom(triangle v2g IN[3], inout TriangleStream<g2f> outStream)
{
    g2f o;
    float3 normal = calcWorldNormal(IN[0].vertex, IN[1].vertex, IN[2].vertex);
    for (int i = 0; i < 3; i++) {
        o.pos = IN[i].pos;
        o.uv = IN[i].uv;
        o.normal = normal;
        outStream.Append(o);
    }
    outStream.RestartStrip();

    if (!_UseFrame) return;

    float3 vec10 = normalize(IN[0].vertex.xyz - IN[1].vertex.xyz);
    float3 vec01 = normalize(IN[1].vertex.xyz - IN[0].vertex.xyz);
    float3 vec12 = normalize(IN[2].vertex.xyz - IN[1].vertex.xyz);
    float3 vec02 = normalize(IN[2].vertex.xyz - IN[0].vertex.xyz);
    float3 triangleNormal = normalize(cross(vec01, vec02));

    float w = _MainTex_TexelSize.z;
    float h = _MainTex_TexelSize.w;

    // back
    float backZ = -triangleNormal.z * 0.01; // z-fighting対策
    float3 p0 = IN[0].vertex.xyz + vec10 * _Scale;
    float3 p1 = IN[1].vertex.xyz + vec01 * _Scale;
    float3 p2 = IN[2].vertex.xyz + (vec02 + vec12) * _Scale * float3(w / max(w, h), h / max(w, h), 0);
    normal = calcWorldNormal(p0, p1, p2);

    o.pos = UnityObjectToClipPos(p0 + float3(0, 0, backZ));
    o.uv = -IN[0].uv;
    o.normal = normal;
    outStream.Append(o);
    o.pos = UnityObjectToClipPos(p1 + float3(0, 0, backZ));
    o.uv = -IN[1].uv;
    o.normal = normal;
    outStream.Append(o);
    o.pos = UnityObjectToClipPos(p2 + float3(0, 0, backZ));
    o.uv = -IN[2].uv;
    o.normal = normal;
    outStream.Append(o);
    outStream.RestartStrip();

    // front
    float frontZ = triangleNormal.z * _Thickness;

    // front up
    addRectangle(
        outStream,
        p2 + float3(0, 0, frontZ),
        p0 + float3(0, 0, frontZ),
        IN[0].vertex + float3(0, 0, frontZ),
        IN[2].vertex + float3(0, 0, frontZ)
    );

    // front side
    addRectangle(
        outStream,
        IN[2].vertex + float3(0, 0, frontZ),
        IN[1].vertex + float3(0, 0, frontZ),
        p1 + float3(0, 0, frontZ),
        p2 + float3(0, 0, frontZ)
    );

    // side
    addRectangle(
        outStream,
        p2 + float3(0, 0, backZ),
        p2 + float3(0, 0, frontZ),
        p1 + float3(0, 0, frontZ),
        p1 + float3(0, 0, backZ)
    );

    // top
    addRectangle(
        outStream,
        p2 + float3(0, 0, backZ),
        p0 + float3(0, 0, backZ),
        p0 + float3(0, 0, frontZ),
        p2 + float3(0, 0, frontZ)
    );

    // inside top
    addRectangle(
        outStream,
        IN[2].vertex + float3(0, 0, frontZ),
        IN[0].vertex + float3(0, 0, frontZ),
        IN[0].vertex,
        IN[2].vertex
    );

    // inside side
    addRectangle(
        outStream,
        IN[1].vertex + float3(0, 0, frontZ),
        IN[2].vertex + float3(0, 0, frontZ),
        IN[2].vertex,
        IN[1].vertex
    );
}
