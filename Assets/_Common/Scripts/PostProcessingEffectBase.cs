using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class PostProcessingEffectBase : MonoBehaviour
{
    [SerializeField]
    protected Shader _shader;

    private Camera _camera;
    public Camera Cam
    {
        get
        {
            if (null == _camera)
            {
                _camera = GetComponent<Camera>();
            }

            return _camera;
        }
    }

    private Material _mat;
    public Material Mat
    {
        get
        {
            if (null == _mat)
            {
                _mat = new Material(_shader);
                _mat.hideFlags = HideFlags.DontSave;
            }

            return _mat;
        }
    }
}
