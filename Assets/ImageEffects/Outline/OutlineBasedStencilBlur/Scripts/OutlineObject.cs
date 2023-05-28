using UnityEngine;
using UnityEngine.Rendering;

namespace ImageEffects.Outlines {

    public class OutlineObject : MonoBehaviour {
        [SerializeField] private Shader _stencilShader;

        private Material _mat;
        public Material Mat {
            get {
                if (null == _mat) {
                    _mat = new Material (_stencilShader);
                    _mat.SetColor ("_Color", Color.white);
                    _mat.hideFlags = HideFlags.DontSave;
                }

                return _mat;
            }
        }

        private void OnEnable () {
            OutlineBasedStencilBlur.RenderEvent += OnRenderEvent;
        }

        private void OnDisable () {
            OutlineBasedStencilBlur.RenderEvent -= OnRenderEvent;
        }

        private void OnRenderEvent (CommandBuffer commandBuffer) {
            Renderer[] renderers = this.GetComponentsInChildren<Renderer> ();
            foreach (Renderer r in renderers) {
                commandBuffer.DrawRenderer (r, Mat);
            }
        }

    }

}
