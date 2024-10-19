# Outline-Based-Normal

Outline based on normals is quite simple. It only requires two passes: one for drawing the outline and one for drawing the object itself.

In the pass for drawing the outline, you need to set Cull to Front, which means only the back faces are rendered, while the front faces are culled. Additionally, the vertices should be offset along their normal direction by a small amount.

This method is highly effective for continuous meshes, but for discrete meshes, it can lead to separation issues.

![01](/Imgs/Outlines/ApplicationToModel/OutlineBasedNormal/01.png)

## Principle
1. Get the mesh that needs to draw the outline
2. Use `Graphics.DrawMesh()` to render the Mesh again
3. In the Shader, expand the vertices in the direction of the normal, obtain new vertex positions and color them.

The result will be good for continuous meshes like Sphere.

![02](/Imgs/Outlines/ApplicationToModel/OutlineBasedNormal/02.png)

Separation phenomenon will occur for non-continuous meshes like Cube.

![03](/Imgs/Outlines/ApplicationToModel/OutlineBasedNormal/03.png)

The solution can be found [here](/Docs/Outlines/ApplicationToModel/OutlineBasedStencilSmoothNormal.md).