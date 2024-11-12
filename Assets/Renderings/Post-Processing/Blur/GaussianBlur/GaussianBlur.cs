using UnityEngine;

namespace zer0.PostProcessing
{
    public class GaussianBlur : PostProcessingBase
    {
        [SerializeField]
        [Range(0, 4)]
        private int _iterations = 3;

        [SerializeField]
        [Range(1, 8)]
        private int _downSample = 2;

        [SerializeField]
        [Range(0, 5)]
        private float _horizontalBlurSize = 1.0f;

        [SerializeField]
        [Range(0, 5)]
        private float _verticalBlurSize = 1.0f;

        private void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (_mat != null)
            {
                _mat.SetFloat("_VerticalBlurSize", _verticalBlurSize);
                _mat.SetFloat("_HorizontalBlurSize", _horizontalBlurSize);

                int rtW = src.width / _downSample;
                int rtH = src.height / _downSample;

                RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
                buffer0.filterMode = FilterMode.Bilinear;
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                buffer1.filterMode = FilterMode.Bilinear;
                Graphics.Blit(src, buffer0);

                for (int i = 0; i < _iterations; ++i)
                {
                    Graphics.Blit(buffer0, buffer1, _mat, 0);   // vertical
                    Graphics.Blit(buffer1, buffer0, _mat, 1);   // horizontal
                }

                Graphics.Blit(buffer0, dest);
                RenderTexture.ReleaseTemporary(buffer0);
                RenderTexture.ReleaseTemporary(buffer1);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
