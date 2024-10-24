using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class PostProcessingBase : MonoBehaviour
{
    [SerializeField]
    private Shader _shader;

    protected Camera _cam;
    protected Material _mat;

    protected virtual void Awake()
    {
        _cam = GetComponent<Camera>();

        _mat = new Material(_shader);
        _mat.hideFlags = HideFlags.DontSave;
    }
}
