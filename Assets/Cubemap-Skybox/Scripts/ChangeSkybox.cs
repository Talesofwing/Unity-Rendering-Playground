using UnityEngine;

public class ChangeSkybox : MonoBehaviour {
	[SerializeField] private Material[] _skyboxMats;

	private void Update () {
		if (Input.GetKeyDown (KeyCode.Space)) {
			RandomSkybox ();
		}
	}

	private void RandomSkybox () {
		if (_skyboxMats == null || _skyboxMats.Length <= 0)
			return;

		int index = Random.Range (0, _skyboxMats.Length);
		RenderSettings.skybox = _skyboxMats[index];
	}

}
