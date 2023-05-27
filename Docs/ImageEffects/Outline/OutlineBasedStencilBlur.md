# Outline-Based-Stencil-Blur

## Introduction

This Outline rendering is achieved through Stencil and Blur. First, a Stencil rendering is performed on the objects that require Outline rendering. In this project, the built-in Stencil Text in Unity is not used. Instead, an additional rendering pass is done to obtain a Stencil Texture. This is because the aim is to obtain a texture with outward expansion through blurring the Stencil Texture, rather than using the Normal-based approach.

![Stencil](/Imgs/ImageEffects/Outline/OutlineBasedStencilBlur/stencil.png)

The expanded texture obtained through blurring. The result is better than using Normal-based approach.

![Blur](/Imgs/ImageEffects/Outline/OutlineBasedStencilBlur/stencil_blur.png)

Then, by using the rendered Stencil texture and Blur texture, another rendering pass is performed to obtain the final result.

![result](/Imgs/ImageEffects/Outline/OutlineBasedStencilBlur/result.png)

However, the color value of the Stencil should not be black, as it will be considered as returning the original texture color due to `any (stencil.rgb)`. Additionally, in the `Composite` Shader, there are two ways to return the Outline color. One way is to use solid color, while the other way is to interpolate between the Blur's Texture alpha channel and the original texture color, resulting in a blurred Outline effect. Readers can uncomment/comment the relevant lines in the Shader to switch between different return methods.

This approach does increase the number of `SetPass` calls because the outline objects are re-rendered. If there are a large number of objects with outlines, it can lead to performance issues.

## Principle
1. Render Stencil Texture.
2. Render Blur Texture.
3. Perform the final rendering: If a pixel in the Stencil Texture has color, return the original texture color. Otherwise, if a pixel in the Blur Texture has color, return the outline color.