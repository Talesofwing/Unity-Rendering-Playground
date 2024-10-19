# Outline-Based-Convolution

In this project, the Outline rendering for the specified layer is implemented. By setting the `Layer` of the `GameObject` to `Outline`, it will be automatically rendered.

![01](/Imgs/Outlines/Post-Processing/OutlineBasedConvolution/01.png)

## Principle
1. Use a new camera to render the objects of the specified layer (Outline). Use `Camera.RenderWithShader(shader, "")`. A simple shader is preferred at this step because we only want to render a texture to indicate which pixels are covered by objects on this layer.
2. Use a 3x3 convolution matrix to overlay the color values of the surrounding pixels on the processed pixels. When the overlaid color value is 0, it means there are no pixels covered by objects around it, so there's no need to render the outline, and the original color is returned. Otherwise, the outline color is returned.
    
    In the 9-grid, if color values are sampled, the processed pixel will be rendered with the outline color.

    ![02](/Imgs/Outlines/Post-Processing/OutlineBasedConvolution/02.png)

    In the 9-grid, if there is no color sampled, the pixel being processed will be rendered with the original texture color.
    
    ![03](/Imgs/Outlines/Post-Processing/OutlineBasedConvolution/03.png)

It's actually a type of convolution application. Other convolution kernels can be used to achieve this effect.