# Skybox

Implementing a Skybox using a Cubemap is a very common and effective method. The principle is to place a cube at the outermost layer, surrounding the entire 3D environment. Generally, the Skybox is rendered first to ensure it always appears behind other objects.

In the actual Shader code, you only need to know the direction from the Camera to the rendering point to sample the Cubemap. Additionally, in Unity Shader, you can use `texCUBE()` to sample the Cubemap. The process is as follows:

```csharp
fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
fixed3 color = texCUBE(_Skybox, -viewDir);
```

I originally wanted to customise the rendering process of the `Skybox`, but I gave up for now because I'm not familiar with Unity's rendering commands. I'll come back to it later.

## References

- This project uses [Avionx Skybox](https://assetstore.unity.com/packages/2d/textures-materials/sky/skybox-series-free-103633) assets.