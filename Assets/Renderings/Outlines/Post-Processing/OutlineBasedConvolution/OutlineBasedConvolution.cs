using UnityEngine;

public class OutlineBasedConvolution : PostProcessingEffectBase
{
    [SerializeField]
    private Shader _drawOccupyShader;
    [SerializeField]
    private Camera _extraCamera;
    [SerializeField]
    private Color _outlineColor;
    [SerializeField]
    private Color _backgroundColor;
    [Range(3, 10)]
    [SerializeField]
    private int _outlineSize = 6;
    [Range(0, 1)]
    [SerializeField]
    private float _outlineFactor = 0;     // 0: display all, 1: only outline with background color

    private GameObject _lastGo;

    private Camera ExtraCamera
    {
        get
        {
            if (null == _extraCamera)
            {
                if (transform.childCount < 0)
                {
                    GameObject go = new GameObject();
                    _extraCamera = go.AddComponent<Camera>();
                }
                else
                {
                    Transform tf = transform.GetChild(0);
                    _extraCamera = tf.GetComponent<Camera>();
                    if (_extraCamera == null)
                    {
                        GameObject go = new GameObject();
                        _extraCamera = go.AddComponent<Camera>();
                    }
                }

                _extraCamera.name = "Extra Camera";
                _extraCamera.CopyFrom(Cam);
                _extraCamera.transform.SetParent(Cam.transform);
                _extraCamera.clearFlags = CameraClearFlags.Color;
                _extraCamera.backgroundColor = Color.black;
                _extraCamera.cullingMask = LayerMask.NameToLayer("Outline");
                _extraCamera.enabled = false;
            }

            return _extraCamera;
        }
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Vector3 mousePos = Input.mousePosition;
            mousePos.z = 1.0f;
            Ray ray = Cam.ScreenPointToRay(mousePos);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, float.MaxValue))
            {
                GameObject hitGo = hit.collider.gameObject;
                if (hitGo.layer == LayerMask.NameToLayer("Outline"))
                {
                    hitGo.layer = 0;
                    _lastGo = null;
                }
                else
                {
                    if (_lastGo != null)
                    {
                        _lastGo.layer = 0;
                    }

                    hitGo.layer = LayerMask.NameToLayer("Outline");
                    _lastGo = hitGo;
                }
            }
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (Mat != null && _drawOccupyShader != null)
        {
            RenderTexture rt = new RenderTexture(src.width, src.height, 0);

            ExtraCamera.targetTexture = rt;

            // Render on a specified layer.
            ExtraCamera.RenderWithShader(_drawOccupyShader, "");

            Mat.SetTexture("_OutlineTex", rt);
            Mat.SetColor("_OutlineColor", _outlineColor);
            Mat.SetColor("_BackgroundColor", _backgroundColor);
            Mat.SetInt("_OutlineSize", _outlineSize);
            Mat.SetFloat("_OutlineFactor", _outlineFactor);

            Graphics.Blit(src, dest, Mat);

            rt.Release();
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
