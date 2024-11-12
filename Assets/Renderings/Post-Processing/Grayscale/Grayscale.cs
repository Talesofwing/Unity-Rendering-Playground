using UnityEngine;

namespace zer0.PostProcessing
{
    public class Grayscale : PostProcessingBase
    {
        private void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (_mat != null)
            {
                Graphics.Blit(src, dest, _mat);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
