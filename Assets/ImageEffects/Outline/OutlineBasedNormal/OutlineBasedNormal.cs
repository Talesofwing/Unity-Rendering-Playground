using UnityEngine;

namespace ImageEffects.Outlines {

    public class OutlineBasedNormal : BaseImageEffect {
        [SerializeField] private Shader _drawOccupyShader;
        [SerializeField] private Camera _extraCamera;
        [SerializeField] private Color _edgeColor;
        [SerializeField] private float _edgeSize = 6;
        [SerializeField] private GameObject[] _outlineGos;

        private void Update () {
            if (_outlineGos != null && _outlineGos.Length > 0) {
                Mat.SetFloat ("_EdgeSize", _edgeSize);
                Mat.SetColor ("_EdgeColor", _edgeColor);
                for (int i = 0; i < _outlineGos.Length; ++i) {
                    Mesh mesh;
                    if (_outlineGos[i].GetComponent<MeshFilter> () != null) {
                        mesh = _outlineGos[i].GetComponent<MeshFilter> ().sharedMesh;
                    } else {
                        mesh = _outlineGos[i].GetComponent<SkinnedMeshRenderer> ().sharedMesh;
                    }
                    Graphics.DrawMesh (mesh, _outlineGos[i].transform.localToWorldMatrix, Mat, 0);
                }
            }
        }

    }

}
