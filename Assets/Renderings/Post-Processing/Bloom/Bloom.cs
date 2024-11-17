using System;

using UnityEngine;

namespace zer0.PostProcessing
{
    [Flags]
    public enum BloomStepFlags
    {
        Luminance = 1,
        Gaussian_Blur = 2,
        Blend = 4,
    }

    public enum LuminanceCalculationType
    {
        Hard_Threshold,
        Linear_Threshold,
        Quadratic_Threshold
    }

    public enum BlendType
    {
        Additive_Blend,
        Screen_Blend
    }

    public class Bloom : PostProcessingBase
    {
        [SerializeField]
        private BloomStepFlags _flags = (BloomStepFlags)~0;

        [SerializeField]
        private LuminanceCalculationType _luminanceCalculattionType = LuminanceCalculationType.Hard_Threshold;

        [SerializeField]
        private BlendType _blendType = BlendType.Additive_Blend;

        [SerializeField]
        [Range(0, 1)]
        private float _threshold = 0.4f;

        [SerializeField]
        private float _intensity = 1.0f;

        [SerializeField]
        [DisplayProperty("_luminanceCalculattionType", (int)LuminanceCalculationType.Linear_Threshold)]
        private float _slope = 2.0f;

        [SerializeField]
        [DisplayProperty("_luminanceCalculattionType", (int)LuminanceCalculationType.Quadratic_Threshold)]
        [Range(0, 1)]
        private float _knee = 1.0f;

        [Header("Gaussian Blur")]
        [SerializeField]
        [Range(0, 10)]
        private int _iterations = 3;

        [SerializeField]
        [Range(1, 8)]
        private int _downSample = 2;

        [SerializeField]
        [Range(0, 8)]
        private float _horizontalBlurSize = 1.0f;

        [SerializeField]
        [Range(0, 8)]
        private float _verticalBlurSize = 1.0f;

        private void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (Mat != null)
            {
                RenderTexture temp = RenderTexture.GetTemporary(src.width, src.height, 0);
                temp.filterMode = FilterMode.Bilinear;

                RenderTexture result = RenderTexture.GetTemporary(src.width, src.height, 0);
                result.filterMode = FilterMode.Bilinear;

                Graphics.Blit(src, result);

                if (_flags.HasFlag(BloomStepFlags.Luminance))
                {
                    Mat.SetFloat("_Threshold", _threshold);
                    Mat.SetFloat("_Intensity", _intensity);

                    int shaderIndex = 0;
                    switch (_luminanceCalculattionType)
                    {
                        case LuminanceCalculationType.Hard_Threshold:
                            shaderIndex = 0;
                            break;
                        case LuminanceCalculationType.Linear_Threshold:
                            Mat.SetFloat("_Slope", _slope);
                            shaderIndex = 1;
                            break;
                        case LuminanceCalculationType.Quadratic_Threshold:
                            Mat.SetFloat("_Knee", _knee);
                            shaderIndex = 2;
                            break;
                    }
                    Graphics.Blit(result, temp, Mat, shaderIndex);
                    Graphics.Blit(temp, result);
                }

                if (_flags.HasFlag(BloomStepFlags.Gaussian_Blur))
                {
                    Mat.SetFloat("_VerticalBlurSize", _verticalBlurSize);
                    Mat.SetFloat("_HorizontalBlurSize", _horizontalBlurSize);

                    int rtW = src.width / _downSample;
                    int rtH = src.height / _downSample;

                    RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
                    buffer0.filterMode = FilterMode.Bilinear;
                    RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                    buffer1.filterMode = FilterMode.Bilinear;

                    Graphics.Blit(result, buffer0);

                    for (int i = 0; i < _iterations; ++i)
                    {
                        Graphics.Blit(buffer0, buffer1, Mat, 3);    // vertial
                        Graphics.Blit(buffer1, buffer0, Mat, 4);    // horizontal
                    }

                    Graphics.Blit(buffer0, result);

                    RenderTexture.ReleaseTemporary(buffer0);
                    RenderTexture.ReleaseTemporary(buffer1);
                }

                if (_flags.HasFlag(BloomStepFlags.Blend))
                {
                    Mat.SetTexture("_Bloom", result);
                    int shaderIndex = 5;
                    switch (_blendType)
                    {
                        case BlendType.Additive_Blend:
                            shaderIndex = 5;
                            break;
                        case BlendType.Screen_Blend:
                            shaderIndex = 6;
                            break;
                    }
                    Graphics.Blit(src, temp, Mat, shaderIndex);
                    Graphics.Blit(temp, result);
                }

                Graphics.Blit(result, dest);

                RenderTexture.ReleaseTemporary(temp);
                RenderTexture.ReleaseTemporary(result);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
