# RampTexture

Often used for Toon Rendering (later will implement some cartoon rendering shaders). It can be divided into:
- 1D: Considering lighting direction
- 2D: Considering lighting and viewing angle

It is a fake BRDF texture.

In the 1D case, the y-value of the texture remains unchanged, while the x-value represents the diffuse coefficient. When sampling, dot(n, litDir) is used. As the angle between the light direction and the normal increases, the resulting dot product value becomes smaller, obtaining values on the left side of the texture. Conversely, as the angle decreases, the dot product value becomes larger, obtaining values on the right side of the texture.

In the 2D case, the xy-values of the texture represent the diffuse coefficient and the specular reflection coefficient (the specific name of the latter is unknown to me, so it is temporarily referred to as the specular reflection coefficient). The principle is similar to the 1D case: as the angle between the viewing direction and the normal increases, the dot product value becomes smaller, obtaining values towards the bottom of the texture. Conversely, as the angle decreases, the dot product value becomes larger, obtaining values towards the top of the texture. When the viewing direction, light direction, and normal are parallel, the value at the top-right corner of the texture (1, 1) is obtained.

The following image is a Ramp Texture from the 《Unity Shaders and Effects Cookbook》.
![Ramp_01](/Imgs/TexEffects/RampTex/ramp_01.jpg)