#ifndef CUSTOM_SHADER_TOOLS
#define CUSTOM_SHADER_TOOLS

static const float3 LuminanceConv = float3(0.2126, 0.7152, 0.0722);

float luminance(float3 rgb) 
{
    return dot(rgb, LuminanceConv);
}

#endif // CUSTOM_SHADER_TOOLS