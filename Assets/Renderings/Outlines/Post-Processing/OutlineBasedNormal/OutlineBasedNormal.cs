using UnityEngine;

namespace ImageEffects.Outlines
{

    public class OutlineBasedNormal : PostProcessingEffectBase
    {
        [SerializeField] private Shader _drawOccupyShader;
        [SerializeField] private Camera _extraCamera;
        [SerializeField] private Color _OutlineColor;
        [SerializeField] private float _OutlineSize = 0.05f;
        [SerializeField] private GameObject[] _outlineGos;

        private void Update()
        {
            if (_outlineGos != null && _outlineGos.Length > 0)
            {
                Mat.SetFloat("_OutlineSize", _OutlineSize);
                Mat.SetColor("_OutlineColor", _OutlineColor);
                for (int i = 0; i < _outlineGos.Length; ++i)
                {
                    Mesh mesh;
                    if (_outlineGos[i].GetComponent<MeshFilter>() != null)
                    {
                        mesh = _outlineGos[i].GetComponent<MeshFilter>().sharedMesh;
                    }
                    else
                    {
                        mesh = _outlineGos[i].GetComponent<SkinnedMeshRenderer>().sharedMesh;
                    }
                    Graphics.DrawMesh(mesh, _outlineGos[i].transform.localToWorldMatrix, Mat, 0);
                }
            }
        }

    }

}
