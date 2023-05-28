using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Outlines.OutlineBasedStencilSmoothNormal {

    public class OutlineObject : MonoBehaviour {
        [SerializeField] private Material _outlineMat;
        private Renderer[] _renderers;
        private MeshFilter[] _meshFilters;
        private SkinnedMeshRenderer[] _skinnedMeshRenderers;

        private void Awake () {
            _renderers = GetComponentsInChildren<Renderer> ();
            _meshFilters = GetComponentsInChildren<MeshFilter> ();
            _skinnedMeshRenderers = GetComponentsInChildren<SkinnedMeshRenderer> ();
            LoadSmoothNormals ();
        }

        private void OnEnable () {
            foreach (var renderer in _renderers) {
                List<Material> materials = renderer.sharedMaterials.ToList ();
                materials.Add (_outlineMat);
                renderer.materials = materials.ToArray ();
            }
        }

        private void OnDisable () {
            foreach (var renderer in _renderers) {
                List<Material> materials = renderer.sharedMaterials.ToList ();
                materials.Remove (_outlineMat);
                renderer.materials = materials.ToArray ();
            }

            foreach (var skinnedMeshRenderer in _skinnedMeshRenderers) {
                skinnedMeshRenderer.sharedMesh.uv4 = new Vector2[skinnedMeshRenderer.sharedMesh.vertexCount];
                CombineSubmeshes (skinnedMeshRenderer.sharedMesh, skinnedMeshRenderer.sharedMaterials.Length);
            }
        }

        private void LoadSmoothNormals () {
            foreach (MeshFilter meshFilter in _meshFilters) {
                List<Vector3> smoothNormals = SmoothNormals (meshFilter.sharedMesh);
                meshFilter.sharedMesh.SetUVs (3, smoothNormals);
                Renderer renderer = meshFilter.GetComponent<Renderer> ();
                if (renderer != null)
                    CombineSubmeshes (meshFilter.sharedMesh, renderer.sharedMaterials.Length);
            }
        }

        private List<Vector3> SmoothNormals (Mesh mesh) {
            var groups = mesh.vertices.Select ((vertex, index) => new KeyValuePair<Vector3, int> (vertex, index)).GroupBy (pair => pair.Key);
            List<Vector3> smoothNormals = new List<Vector3> (mesh.normals);
            foreach (var group in groups) {
                if (group.Count () == 1) {
                    continue;
                }

                Vector3 smoothNormal = Vector3.zero;
                foreach (var pair in group) {
                    smoothNormal += smoothNormals[pair.Value];
                }
                smoothNormal.Normalize ();

                foreach (var pair in group) {
                    smoothNormals[pair.Value] = smoothNormal;
                }
            }

            return smoothNormals;
        }

        private void CombineSubmeshes (Mesh mesh, int materialsLength) {
            if (mesh.subMeshCount == 1)
                return;

            if (mesh.subMeshCount > materialsLength)
                return;

            mesh.subMeshCount++;
            mesh.SetTriangles (mesh.triangles, mesh.subMeshCount - 1);
        }

    }

}
