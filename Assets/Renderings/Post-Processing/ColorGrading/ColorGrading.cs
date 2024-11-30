using UnityEngine;

namespace zer0.PostProcessing
{
    public class ColorGrading : PostProcessingBase
    {
        [SerializeField, Range(0.0f, 3.0f)]
        private float _brightness = 1.0f;
        [SerializeField, Range(0.0f, 3.0f)]
        private float _saturation = 1.0f;
        [SerializeField, Range(0.0f, 3.0f)]
        private float _contrast = 1.0f;

        private void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (Mat != null)
            {
                Mat.SetFloat("_Brightness", _brightness);
                Mat.SetFloat("_Saturation", _saturation);
                Mat.SetFloat("_Contrast", _contrast);

                Graphics.Blit(src, dest, Mat);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
