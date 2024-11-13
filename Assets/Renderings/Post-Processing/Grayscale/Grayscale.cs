using UnityEngine;

namespace zer0.PostProcessing
{
    public class Grayscale : PostProcessingBase
    {
        private void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (Mat != null)
            {
                Graphics.Blit(src, dest, Mat);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
