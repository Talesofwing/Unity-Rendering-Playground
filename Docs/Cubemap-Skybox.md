# Cubemap-Skybox

This project implements the manual rendering of `Cubemap`, `Cubemap` sampling, and `Skybox`.

There are many detailed explanations of `Cubemap` and the principles of sampling `Cubemap` available online, so there is no need to go into detail here.

I encountered a lot of problems during implementation, and the most troublesome one was how to fill the `RenderTexture` into the `Cubemap`.

After rendering 6 `RenderTextures` with 6 cameras, they are transformed into `Texture2D` and then filled into a `Cubemap`. This process causes the textures in the `Cubemap` to be inverted vertically. After some testing, the following conclusions were obtained.

- When using `Cubemap.SetPixels()`, left-right inversion and flipping of the y-value of the origin point with respect to the `Texture2D` are automatically handled, so there is no need to manually adjust them.
    
    - According to the [Unity Docs](https://docs.unity3d.com/ScriptReference/Texture2D.ReadPixels.html), the origin of `Texture2D` is in the lower-left corner, so the origin of `Cubemap` is in the upper-left corner.
    - In order to assign the color values of `Texture2D` to `Cubemap`, it needs to be flipped vertically.
    - Since `Cubemap.SetPixels()` already automatically swaps left and right, there is no need to handle it manually.

Also, if you want to use the generated `Texture2D`, you need to flip it horizontally again when generating the `Texture2D` so that it can be used for `Cubemap`.

## Introducation

- `Assets/Shaders/Skybox.shader`
    - Custom Skybox Shader。
- `Assets/Shaders/Reflection.shader`
    - Custom Reflection Shader。

## Usage
- Click on `zer0/Render Cubemap` in the toolbar
- Select `Cubemap` to render into
- Select `Transform` as camera position. If it is null, use `(0, 0, 0)` as the camera position.
- Click `Render` button

`Reference_Cubemap` is a `Cubemap` generated using `Camera.RenderToCubemap()`.

## Conclusion
I originally wanted to customise the rendering process of the `Skybox`, but I gave up for now because I'm not familiar with Unity's rendering commands. I'll come back to it later.

## References

- This project uses [Avionx Skybox](https://assetstore.unity.com/packages/2d/textures-materials/sky/skybox-series-free-103633) assets.