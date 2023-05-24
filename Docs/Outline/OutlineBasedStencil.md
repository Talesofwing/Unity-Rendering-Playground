# OutlineBasedStencil

The article mentioned in the Reference is in Chinese, but not to worry, I will explain the principle clearly here.

In essence, the approach involves using two passes. The first pass renders the stencil and performs the regular rendering of the objects. In this example, the `ForwardAdd` is not included. The second pass expands the vertices based on their normals. It then checks whether the Stencil texture value exists for each pixel. If the Stencil texture value exists, it means that the pixel is not an edge and can be discarded through the Stencil Test. As a result, only the edges are rendered.

The vertex extrusion in this example is implemented using two methods:
- Calculation in model space, which results in the issue of exaggeration of the near and diminishing of the far
- Calculation in view space, which resolves the issue of exaggeration but may have a certain impact on performance

In practice, there is no significant difference in the results obtained from calculations in model space versus view space. Therefore, for performance reasons, it may be preferable to choose calculations in model space.

Additionally, due to the use of normal extrusion, as shown in the image, some discontinuous shapes may still exhibit issues with outlining being separated from the object.

![OutlineBasedStencil](/Imgs/Outlines/OutlineBasedStencil.png)

## References
1. [CSDN-unity 描边之stencil篇](https://blog.csdn.net/akak2010110/article/details/86149390?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-9-86149390-blog-78729906.235^v35^pc_relevant_increate_t0_download_v2_base&spm=1001.2101.3001.4242.6&utm_relevant_index=12)
