using UnityEngine;

namespace zer0
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public abstract class PostProcessingBase : MonoBehaviour
    {
        [SerializeField]
        private Shader _shader;

        private Camera _cam;
        private Material _mat;

        protected Camera Cam
        {
            get
            {
                if (_cam == null)
                {
                    _cam = GetComponent<Camera>();
                }

                return _cam;
            }
        }

        protected Material Mat
        {
            get
            {
                if (_mat == null)
                {
                    if (_shader == null)
                    {
                        Debug.LogWarning("Shader is not set.");
                    }
                    else
                    {
                        _mat = new Material(_shader);
                        _mat.hideFlags = HideFlags.DontSave;
                    }
                }

                return _mat;
            }
        }
    }
}
