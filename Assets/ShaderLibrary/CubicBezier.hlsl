#ifndef CUBIC_BEZIER_INCLUDED
#define CUBIC_BEZIER_INCLUDED

float3 CubicBezier(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
    float omt =1 -t;
    float omt2 = omt * omt;
    float t2 = t* t;
    
    return p0*(omt*omt2)+
        p1*(3*omt2*t)+
        p2*(3*omt*t2)+
        p3*(t2*t);
}

// 计算出曲线的切线
float3 CubicBezierTangent(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
    float omt =1 -t;
    float omt2 = omt * omt;
    float t2 = t* t;

    float3 tangent =
            p0 * (-omt2) +
            p1 * (3 * omt2 - 2 * omt) +
            p2 * (-3 * t2 + 2 * t) +
            p3 * (t2);

    return normalize(tangent);
}

#endif