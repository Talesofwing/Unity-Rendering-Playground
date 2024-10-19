# Outline-Based-Normal

Outline based on normals is quite simple. It only requires two passes: one for drawing the outline and one for drawing the object itself.

In the pass for drawing the outline, you need to set Cull to Front, which means only the back faces are rendered, while the front faces are culled.

This method is highly effective for continuous meshes, but for discrete meshes, it can lead to separation issues.

![01](/Imgs/Outlines/ApplicationToModel/OutlineBasedNormal/01.png)

For more details, you can refer to [here](/Docs/Outlines/Post-Processing/OutlineBasedNormal.md).