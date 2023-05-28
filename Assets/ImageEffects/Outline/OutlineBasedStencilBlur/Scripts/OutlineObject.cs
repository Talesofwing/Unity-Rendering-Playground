using UnityEngine;
using UnityEngine.Rendering;

namespace ImageEffects.Outlines {

    public class OutlineObject : MonoBehaviour {
        [SerializeField] private Material _stencilMat;

        private void OnEnable () {
            OutlineBasedStencilBlur.RenderEvent += OnRenderEvent;
        }

        private void OnDisable () {
            OutlineBasedStencilBlur.RenderEvent -= OnRenderEvent;
        }

        private void OnRenderEvent (CommandBuffer commandBuffer) {
            Renderer[] renderers = this.GetComponentsInChildren<Renderer> ();
            foreach (Renderer r in renderers) {
                commandBuffer.DrawRenderer (r, _stencilMat);
            }
        }

    }

}
