# Outline-Based-Stencil-SmoothNormal

This project supports both `MeshRenderer` and `SkinnedMeshRenderer`.

The principle of this project is consistent with [Outline-Based-Stencil](OutlineBasedStencil.md), with the addition of vertex normal processing to achieve smooth transitions and reduce discontinuities. This allows for smoother transitions between normals, resulting in reduced fragmentation. The effect can be observed in the accompanying image.

![01](/Imgs/Outlines/ApplicationToModel/OutlineBasedStencilSmoothNormal/01.png)

The main operation performed is the summation and normalization of the normals of identical vertices. For example, in a Cube mesh, there are three copies of vertices at the same position. The normals of these three copies are summed and then normalized. Finally, the new normalized normal is assigned to the vertex.

## Refenrences
1. [Outline-Based-Stencil](OutlineBasedStencil.md)