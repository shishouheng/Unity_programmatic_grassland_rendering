Shader "Unlit/BezierBlade"
{
    Properties
    {
        [Header(Shape)]
        _Height("Height", Float) = 1 // 草叶长度
        _Tilt("Tilt", Float) = 0.9 // 草尖到地面高度
        _BladeWidth("Blade Width", Float) = 0.1 // 草叶底部宽度
        _TaperAmount("Taper Amount", Float) = 0 // 草叶宽度衰减(从底部到顶部)
        _p1Offset("p1 Offset", Float) = 1 
        _p2Offset("p2 Offset", Float) = 1
    }
    SubShader
    {
        Name "Simple Grass Blade"
        Tags { "LightMode"="Opaque" "RenderPipeline"="UniversalPipeline" }

        Pass
        {
            Name "Simple Grass Blade"
            Tags { "LightMode"="UniversalForward"}
            
            Cull Off
            
            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "../ShaderLibrary/CubicBezier.hlsl"

            float _Height;
            float _Tilt;
            float _BladeWidth;
            float _TaperAmount;
            float _p1Offset;
            float _p2Offset;
            
            struct Attributes
            {
                float4 positionOS   : POSITION;
                float4 color        : COLOR;
                float2 texcorrd      : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
            };

            float3 GetP0()
            {
                return float3(0,0,0);
            }

            float3 GetP3(float height, float tilt)
            {
                float p3y = tilt * height;
                float p3x = sqrt(height * height - p3y * p3y);
                return float3(-p3x, p3y, 0);
            }

            void GetP1P2(float3 p0,float3 p3, out float3 p1, out float3 p2)
            {
                p1 = lerp(p0, p3, 0.33);
                p2 = lerp(p0, p3, 0.66);

                float3 bladeDir = normalize(p3 - p0);
                float3 bezCtrlOffsetDir = normalize(cross(bladeDir, float3(0, 0, 1)));

                p1 += bezCtrlOffsetDir * _p1Offset;
                p2 += bezCtrlOffsetDir * _p2Offset;
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                float3 p0 = GetP0();
                float3 p3 = GetP3(_Height, _Tilt);
                float3 p1 = float3(0,0,0);
                float3 p2 = float3(0,0,0);
                GetP1P2(p0, p3, p1, p2);

                float t = IN.color.r;
                float3 centerPos = CubicBezier(p0, p1, p2, p3, t);

                float width = _BladeWidth * (1 - t * _TaperAmount);
                float side = IN.color.g*2 - 1;
                float3 vertexPos = centerPos+float3(0,0,side*width);

                OUT.positionHCS = TransformObjectToHClip(vertexPos);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return half4(0, 1, 0, 1);
            }
            ENDHLSL
        }
    }
    Fallback "Hidden/InternalErrorShader"
}
