using UnityEngine;

[RequireComponent (typeof (Camera))]
public class ScreenSpaceShadowMapping : MonoBehaviour {
	private const string c_Shader_Key_Camera_Depth_Texture = "_CameraDepthTex";
	private const string c_Shader_Key_Light_Depth_Texture = "_LightDepthTex";
	private const string c_Shader_Key_Screen_Space_Shadow_Map = "_ScreenSpceShadowMap";
	private const string c_Shader_Key_Matrix_Inverse_VP = "_InverseVP";
	private const string c_Shader_Key_Matrix_World_To_Light = "_WorldToLight";

	[SerializeField] private Material _shadowCasterMat;
	[SerializeField] private Material _shadowCollectorMat;
	[SerializeField] private Transform[] _lightTfs;
	[SerializeField] private RenderTexture _cameraDepthTexture;     // main camera depth map
	[SerializeField] private RenderTexture _sssm;                   // Screen Space Shadow Map

	private Camera _mainCamera;
	private Camera[] _lightCameras;

	private RenderTexture[] _lightDepthTextures;

	private int _length;

	private void Awake () {
		Shader.EnableKeyword ("_ReceiveShadow");

		_mainCamera = GetComponent<Camera> ();

		_length = _lightTfs.Length;
		_lightCameras = new Camera[_length];
		_lightDepthTextures = new RenderTexture[_length];
		for (int i = 0; i < _length; ++i) {
			_lightDepthTextures[i] = GenerateRT ();
			_lightCameras[i] = GenerateLightCamera (_lightTfs[i], _lightDepthTextures[i]);
		}

		Shader.SetGlobalTexture (c_Shader_Key_Screen_Space_Shadow_Map, _sssm);
	}

	private void LateUpdate () {
		// Renders MainCamera depth texture
		_mainCamera.enabled = false;
		_mainCamera.clearFlags = CameraClearFlags.SolidColor;
		_mainCamera.targetTexture = _cameraDepthTexture;

		_mainCamera.RenderWithShader (_shadowCasterMat.shader, "");

		_mainCamera.targetTexture = null;
		_mainCamera.clearFlags = CameraClearFlags.Skybox;
		_mainCamera.enabled = true;

		// Renders LightCamera depth texture
		for (int i = 0; i < _length; ++i) {
			_lightCameras[i].RenderWithShader (_shadowCasterMat.shader, "");
		}

		// Transformation: Screen Space -> World Space
		Matrix4x4 projectionMatrix = GL.GetGPUProjectionMatrix (_mainCamera.projectionMatrix, false);
		Shader.SetGlobalMatrix (c_Shader_Key_Matrix_Inverse_VP, Matrix4x4.Inverse (projectionMatrix * _mainCamera.worldToCameraMatrix));

		// Transfomration: World Space -> Screen Space in the view of the light
		projectionMatrix = GL.GetGPUProjectionMatrix (_lightCameras[0].projectionMatrix, false);
		Shader.SetGlobalMatrix (c_Shader_Key_Matrix_World_To_Light, projectionMatrix * _lightCameras[0].worldToCameraMatrix);

		_shadowCollectorMat.SetTexture (c_Shader_Key_Camera_Depth_Texture, _cameraDepthTexture);
		_shadowCollectorMat.SetTexture (c_Shader_Key_Light_Depth_Texture, _lightDepthTextures[0]);
		Graphics.Blit (_cameraDepthTexture, _sssm, _shadowCollectorMat);
	}

	/// <summary>
	///  Generate camera at the position of the light for rendering the depth map
	/// </summary>
	private Camera GenerateLightCamera (Transform parent, RenderTexture rt) {
		GameObject lightCamGo = new GameObject ("Light Camera");
		lightCamGo.transform.SetParent (parent);
		lightCamGo.transform.localPosition = Vector3.zero;
		lightCamGo.transform.localRotation = Quaternion.identity;

		Camera lightCam = lightCamGo.AddComponent<Camera> ();

		lightCam.backgroundColor = Color.white;
		lightCam.clearFlags = CameraClearFlags.SolidColor;
		lightCam.orthographic = true;
		lightCam.orthographicSize = 6f;
		lightCam.nearClipPlane = 0.3f;
		lightCam.farClipPlane = 20;
		lightCam.enabled = false;
		lightCam.targetTexture = rt;

		return lightCam;
	}

	private RenderTexture GenerateRT () {
		RenderTexture rt = new RenderTexture (Screen.width, Screen.height, 24, RenderTextureFormat.ARGB32);

		return rt;
	}

}
