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

float3 CubicBezier2D(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
    float a = lerp(p0, p1, t);
    float b = lerp(p2, p3, t);
    float c = lerp(p1, p2, t);
    float d = lerp(a, c, t);
    float e = lerp(c, b, t);
    return lerp(d, e, t);
}

#endif