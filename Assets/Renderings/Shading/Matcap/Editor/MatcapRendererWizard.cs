using System.IO;

using UnityEngine;
using UnityEditor;

public class MatcapRendererWizard : ScriptableWizard
{
    [SerializeField]
    private Camera _camera;

    [SerializeField]
    private Transform _sphere;

    [SerializeField]
    private TextureSize _textureSize = TextureSize.Size_512;

    [SerializeField]
    private string _savePath = "Renderings/Shading/Matcap";

    [SerializeField]
    private string _textureName = "Matcap";

    [SerializeField]
    private bool _adjustOnRender = false;

    private void OnWizardCreate()
    {
        if (_adjustOnRender)
        {
            AdjustCamera();
        }

        Render();
    }

    private void OnWizardOtherButton()
    {
        AdjustCamera();
    }

    private void Render()
    {
        if (_camera != null && _sphere != null)
        {
            (RenderTexture rt, Texture2D texture) = GenerateRT();
            RenderTexture.active = rt;
            _camera.targetTexture = rt;
            _camera.Render();

            Rect rect = new Rect(0, 0, texture.width, texture.height);
            texture.ReadPixels(rect, 0, 0);
            texture.Apply();

            byte[] bytes = texture.EncodeToPNG();
            string path = Path.Combine(Application.dataPath, _savePath, _textureName) + "-" + _textureSize.ToString() + ".png";
            File.WriteAllBytes(path, bytes);
            AssetDatabase.Refresh();

            _camera.targetTexture = null;
            RenderTexture.active = null;
            RenderTexture.ReleaseTemporary(rt);

            Debug.Log("Rendering matcap is finished.");
        }
        else
        {
            Debug.LogWarning("Please set camera and sphere.");
        }
    }

    private void AdjustCamera()
    {
        if (_camera != null && _sphere != null)
        {
            Vector3 lookat = _sphere.position - _camera.transform.position;
            lookat.Normalize();
            _camera.transform.rotation = Quaternion.LookRotation(lookat);
            _camera.transform.position = _sphere.position - lookat;
            _camera.orthographic = true;
            _camera.orthographicSize = _sphere.localScale.x * 0.5f;
        }
        else
        {
            Debug.LogWarning("Please set camera and sphere.");
        }
    }

    private (RenderTexture, Texture2D) GenerateRT()
    {
        int width = 0, height = 0;
        switch (_textureSize)
        {
            case TextureSize.Size_512:
                width = height = 512;
                break;
            case TextureSize.Size_1024:
                width = height = 1024;
                break;
        }

        return (RenderTexture.GetTemporary(width, height), new Texture2D(width, height, TextureFormat.RGBA32, 0, false));
    }

    [MenuItem("zer0/Renderer/Matcap Renderer")]
    private static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard<MatcapRendererWizard>("Matcap Renderer", "Render", "Adjust Camera");
    }

    public enum TextureSize
    {
        Size_512,
        Size_1024,
    }
}
