using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace ImageEffects.Outlines {

    public class OutlineBasedStencilBlur : BaseImageEffect {
        public static Action<CommandBuffer> RenderEvent;
        [SerializeField] private Shader _blurShader;
        [SerializeField] private float _blurScale = 2;
        [SerializeField] private int _iterate = 3;
        [SerializeField] private float _OutlineScale = 3;
        [SerializeField] private Color _outlineColor = Color.black;

        private CommandBuffer _commandBuffer;
        private RenderTexture _stencilTex;
        private RenderTexture _blurTex;

        [SerializeField] private GameObject[] _AllObjects;
        private List<GameObject> _outlineObjects = new List<GameObject> ();

        private Material _blurMat;
        public Material BlurMat {
            get {
                if (null == _blurMat) {
                    _blurMat = new Material (_blurShader);
                    _blurMat.hideFlags = HideFlags.DontSave;
                }

                return _blurMat;
            }
        }

        private void Awake () {
            _commandBuffer = new CommandBuffer ();
        }

        private void Update () {
            if (Input.GetMouseButtonDown (0)) {
                Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
                RaycastHit hit;
                if (Physics.Raycast (ray, out hit)) {
                    GameObject hitGo = hit.collider.gameObject;
                    if (Input.GetKey (KeyCode.LeftControl) || Input.GetKey (KeyCode.RightControl)) {
                        if (_outlineObjects.Contains (hitGo)) {
                            _outlineObjects.Remove (hitGo);
                        } else {
                            _outlineObjects.Add (hitGo);
                        }
                    } else {
                        _outlineObjects.Clear ();
                        _outlineObjects.Add (hitGo);
                    }
                } else {
                    _outlineObjects.Clear ();
                }
            }

            SetOutline ();
        }

        private void SetOutline () {
            foreach (GameObject go in _AllObjects) {
                go.GetComponent<OutlineObject> ().enabled = false;
            }

            foreach (GameObject go in _outlineObjects) {
                go.GetComponent<OutlineObject> ().enabled = true;
            }
        }

        private void OnRenderImage (RenderTexture src, RenderTexture dest) {
            if (RenderEvent != null) {
                RenderStencil ();
                RenderBlur ();
                RenderComposite (src, dest);
                _commandBuffer.Clear ();
            } else {
                Graphics.Blit (src, dest);
            }
        }

        private void RenderStencil () {
            _stencilTex = RenderTexture.GetTemporary (Screen.width, Screen.height, 0);
            _commandBuffer.SetRenderTarget (_stencilTex);
            _commandBuffer.ClearRenderTarget (true, true, Color.clear);
            RenderEvent.Invoke (_commandBuffer);
            Graphics.ExecuteCommandBuffer (_commandBuffer);
        }

        private void RenderBlur () {
            _blurTex = RenderTexture.GetTemporary (Screen.width, Screen.height, 0);
            RenderTexture temp = RenderTexture.GetTemporary (Screen.width, Screen.height, 0);
            BlurMat.SetFloat ("_BlurScale", _blurScale);
            Graphics.Blit (_stencilTex, _blurTex, BlurMat);
            for (int i = 0; i < _iterate; i++) {
                Graphics.Blit (_blurTex, temp, BlurMat);
                Graphics.Blit (temp, _blurTex, BlurMat);
            }
            RenderTexture.ReleaseTemporary (temp);
        }

        private void RenderComposite (RenderTexture src, RenderTexture dest) {
            Mat.SetTexture ("_MainTex", src);
            Mat.SetTexture ("_StencilTex", _stencilTex);
            Mat.SetTexture ("_BlurTex", _blurTex);
            Mat.SetFloat ("_OutlineScale", _OutlineScale);
            Mat.SetColor ("_OutlineColor", _outlineColor);
            Graphics.Blit (src, dest, Mat);
            RenderTexture.ReleaseTemporary (_stencilTex);
            RenderTexture.ReleaseTemporary (_blurTex);
            _stencilTex = null;
            _blurTex = null;
        }

    }

}
