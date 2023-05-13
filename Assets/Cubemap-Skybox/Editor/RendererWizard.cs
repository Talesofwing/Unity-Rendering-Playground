using System.IO;
using UnityEditor;
using UnityEngine;

public class RendererWizard : ScriptableWizard {
    [SerializeField] private Transform _root;
    [SerializeField] private Cubemap _cubemap;
    [SerializeField] private bool _saveTexture = true;
    [SerializeField] private string _savePath = "Cubemap-Skybox/Textures/Cubemap";
    [SerializeField] private string _textureName = "Cubemap";

    [Header ("Render Properties")]
    [SerializeField] private int _faceSize = 256;

    [Header ("Camera Properties")]
    [SerializeField] private LayerMask _mask;
    [SerializeField] private float _near = 0.01f;
    [SerializeField] private float _far = 1000.0f;

    // Camera's orientation
    private static readonly Vector3[] _cameraOrientation = new Vector3[6] {
        new Vector3 (0, 0, 0),		// forward
		new Vector3 (0, -180, 0),	// back
		new Vector3 (0, 90, 0),		// right
		new Vector3 (0, -90, 0),	// left
		new Vector3 (-90, 0, 0),	// up
		new Vector3 (90, 0, 0),		// down
	};

    // Cubemap's face
    private static readonly CubemapFace[] _cubmapFaces = new CubemapFace[6] {
        CubemapFace.PositiveZ,
        CubemapFace.NegativeZ,
        CubemapFace.PositiveX,
        CubemapFace.NegativeX,
        CubemapFace.PositiveY,
        CubemapFace.NegativeY,
    };

    private void OnWizardUpdate () {
        isValid = false;
        if (_cubemap == null) {
            helpString = "Select cubemap to render into";
        } else if (_far <= _near) {
            helpString = "Error: Far >= Near";
        } else {
            isValid = true;
        }
    }

    private void OnWizardCreate () {
        for (int i = 0; i < 6; ++i) {
            Vector3 position = _root == null ? Vector3.zero : _root.position;
            Vector3 orientation = _cameraOrientation[i];
            RenderTexture rt = GenerateRT ();

            GameObject camGo = new GameObject ("Camera");
            camGo.transform.position = position;
            camGo.transform.rotation = Quaternion.Euler (orientation);

            Camera cam = camGo.AddComponent<Camera> ();
            cam.enabled = false;
            cam.cullingMask = _mask;
            cam.fieldOfView = 90;
            cam.nearClipPlane = _near;
            cam.farClipPlane = _far;
            cam.targetTexture = rt;
            cam.aspect = 1.0f;
            cam.backgroundColor = new Color (0, 0, 0, 0);
            RenderTexture.active = rt;
            cam.Render ();

            Rect rect = new Rect (0, 0, _faceSize, _faceSize);
            Texture2D texture = new Texture2D (_faceSize, _faceSize, TextureFormat.RGB24, 0, false);
            texture.ReadPixels (rect, 0, 0);
            texture.Apply ();

            if (_saveTexture) {
                byte[] bytes = texture.EncodeToPNG ();
                string filename = Application.dataPath + "/" + _savePath + "/" + _textureName + "_" + _cubmapFaces[i].ToString () + ".png";
                File.WriteAllBytes (filename, bytes);
                Debug.Log ("Create Texture\n" + filename);
            }

            // Please refer to the documentation on Github for more details.

            Color[] colors = texture.GetPixels ();
            int width = texture.width;
            int height = texture.height;
            for (int y = 0; y < height / 2; y++) {
                for (int x = 0; x < width; x++) {
                    int topIndex = y * width + x;
                    int bottomIndex = (height - y - 1) * width + x;
                    Color temp = colors[topIndex];
                    colors[topIndex] = colors[bottomIndex];
                    colors[bottomIndex] = temp;
                }
            }

            texture.SetPixels (colors);
            texture.Apply ();

            _cubemap.SetPixels (texture.GetPixels (), _cubmapFaces[i]);

            RenderTexture.active = null;
            DestroyImmediate (camGo);
        }

        Debug.Log ("Rendering cubemap is finished.");
    }

    private RenderTexture GenerateRT () {
        RenderTexture rt = new RenderTexture (_faceSize, _faceSize, 1, RenderTextureFormat.Default);

        return rt;
    }

    [MenuItem ("zer0/Render Cubemap")]
    private static void RenderCubemap () {
        ScriptableWizard.DisplayWizard<RendererWizard> ("Render Cubemap", "Render");
    }

}
