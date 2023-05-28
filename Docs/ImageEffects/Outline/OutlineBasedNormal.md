# OutlineBasedNormal

## Introduction
In this project, contour rendering based on vertex expansion in the direction of the normal was implemented. By passing a GameObject with `MeshFilter` or `SkinnedMeshRenderer` to `OutlineBasedNormal` in the Camera, the outline can be automatically rendered. 

However, as shown in the figure, the effect is not as good as expected. When the vertices are not continuous (such as Cube), separation occurs. Moreover, because the Mesh needs to be rendered again, if the Mesh is complex, it will consume more performance.

![result](/Imgs/ImageEffects/Outlines/OutlineBasedNormal/01.png)

## Principle
1. Get the mesh that needs to draw the outline
2. Use `Graphics.DrawMesh()` to render the Mesh again
3. In the Shader, expand the vertices in the direction of the normal, obtain new vertex positions and color them.

The result will be good for continuous meshes like Sphere.

![01](/Imgs/ImageEffects/Outlines/OutlineBasedNormal/02.png)

Separation phenomenon will occur for non-continuous meshes like Cube.

![02](/Imgs/ImageEffects/Outlines/OutlineBasedNormal/03.png)