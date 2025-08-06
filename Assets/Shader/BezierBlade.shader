Shader "Unlit/BezierBlade"
{
    Properties
    {
        [Header(Shape)]
        _Height("Height", Float) = 1 // 草叶长度
        _Tilt("Tilt", Float) = 0.9 // 草尖到地面高度
        _BladeWidth("Blade Width", Float) = 0.1 // 草叶底部宽度
        _TaperAmount("Taper Amount", Float) = 0 // 草叶宽度衰减(从底部到顶部)
        _CurvedNormalAmount("Curved Normal Amount", Range(0,5)) = 1 // 草叶两侧法线弯曲程度，用来实现草叶的厚度
        _p1Offset("p1 Offset", Float) = 1 
        _p2Offset("p2 Offset", Float) = 1
        
        [Header(Shading)]
        _TopColor("Top Color", Color) = (.25,.5,.5,1)
        _BottomColor("Bottom Color", Color) = (.25,.5,.5,1)
        _GrassAlbedo("Grass Albedo", 2D) = "white" {}
        _GrassGloss("Grass Gloss", 2D) = "white" {}
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

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _SHADOWS_SOFT
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "../ShaderLibrary/CubicBezier.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            float _Height;
            float _Tilt;
            float _BladeWidth;
            float _TaperAmount;
            float _p1Offset;
            float _p2Offset;
            float _CurvedNormalAmount;

            float4 _TopColor;
            float4 _BottomColor;
            TEXTURE2D(_GrassAlbedo);
            SAMPLER(sampler_GrassAlbedo);
            TEXTURE2D(_GrassGloss);
            SAMPLER(sampler_GrassGloss);
            
            struct Attributes
            {
                float4 positionOS   : POSITION;
                float4 color        : COLOR;
                float2 texcorrd      : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float3 curvedNormal : TEXCOORD1;
                float3 originalNormal : TEXCOORD2;
                float2 uv : TEXCOORD3;
                float t : TEXCOORD4;
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

                // 计算切线，并通过切线来计算法线
                float3 tangent = CubicBezierTangent(p0, p1, p2, p3, t);
                float3 normal = normalize(cross(tangent, float3(0, 0, 1)));

                float3 curvedNormal = normal;
                // 乘side表示左右端点方向
                curvedNormal.z += side * _CurvedNormalAmount;
                curvedNormal = normalize(curvedNormal);

                // 顶点位置转换到裁剪空间
                OUT.positionCS = TransformObjectToHClip(vertexPos);
                // 法线转换到世界坐标系
                OUT.curvedNormal = TransformObjectToWorldNormal(curvedNormal);
                OUT.originalNormal = TransformObjectToWorldNormal(normal);
                // 顶点位置转换到世界坐标系 
                OUT.positionWS = TransformObjectToWorld(vertexPos);
                OUT.uv = IN.texcorrd;
                OUT.t = t;
                return OUT;
            }

            half4 frag(Varyings i,bool isFrontFace : SV_IsFrontFace) : SV_Target
            {
                float3 n = isFrontFace ? normalize(i.curvedNormal) : -reflect(-normalize(i.curvedNormal), normalize(i.originalNormal));

                Light mainLight = GetMainLight(TransformWorldToShadowCoord(i.positionWS));
                float3 v = normalize(GetCameraPositionWS() - i.positionWS);

                float3 grassAlbedo = saturate(_GrassAlbedo.Sample(sampler_GrassAlbedo,i.uv));
                float4 grassCol = lerp(_BottomColor, _TopColor, i.t);
                float3 albedo = grassCol.rgb * grassAlbedo;
                float gloss =(1-_GrassGloss.Sample(sampler_GrassGloss,i.uv).r)*0.2;

                half3 GI = SampleSH(n);

                BRDFData brdfData;
                half alpha =1;

                InitializeBRDFData(albedo, 0, half3(1,1,1), gloss, alpha, brdfData);
                float3 directBRDF = DirectBRDF(brdfData, n,mainLight.direction,  v)* mainLight.color;

                // final color calculate
                float3 finalColor = GI * albedo + directBRDF*(mainLight.shadowAttenuation*mainLight.distanceAttenuation);

                float4 col;
                col = float4(finalColor,grassCol.a); // alpha from grasscol

                return half4(col);
            }
            ENDHLSL
        }
    }
    Fallback "Hidden/InternalErrorShader"
}