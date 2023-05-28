# ImageEffect - Outline

## Introducation
This project implements Outline rendering using various methods, including:

1. [Outline-Based-Convolution](Outline/OutlineBasedConvolution.md)
2. [Outline-Based-Normal](Outline/OutlineBasedNormal.md)
3. [Outline-Based-Stencil-Blur](Outline/OutlineBasedStencilBlur.md)

There are many methods for rendering Outline. In the book "Real Time Rendering, third edition", the author categorizes these methods into five types:

- Outline rendering based on viewing angle and surface normal
- Outline rendering based on procedural geometry 
- Outline rendering based on image processing
- Outline rendering based on edge detection
- Mixing several rendering methods mentioned above

More detailed information can be found in the book.

## Other

There are various methods for rendering Outline, each with its own advantages and disadvantages. Currently, I has not found a universal algorithm for Outline rendering. Depending on the requirements, different implementation approaches can be chosen.

This project is based on screen post-processing and also implements an Outline Shader that can be directly applied to objects. You can find it in `Assets/Outline` or refer to the documentation in [Outline](/Docs/Outline/Outline.md) for more information.

## References
1. [CSDN-指定layer的外轮廓渲染](https://blog.csdn.net/l773575310/article/details/78701756)
2. [CSDN-对物体网格顶点的外扩](https://blog.csdn.net/l773575310/article/details/78714406)
3. [CSDN-结合方法1的外轮廓渲染、方法2的选择网格](https://blog.csdn.net/l773575310/article/details/78729906)
5. [CSDN-选中物体描边特效](https://zhyan8.blog.csdn.net/article/details/127937019?spm=1001.2101.3001.6650.10&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-10-127937019-blog-86149390.235%5Ev35%5Epc_relevant_increate_t0_download_v2_base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-10-127937019-blog-86149390.235%5Ev35%5Epc_relevant_increate_t0_download_v2_base&utm_relevant_index=15&ydreferer=aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FrYWsyMDEwMTEwL2FydGljbGUvZGV0YWlscy84NjE0OTM5MD91dG1fbWVkaXVtPWRpc3RyaWJ1dGUucGNfcmVsZXZhbnQubm9uZS10YXNrLWJsb2ctMn5kZWZhdWx0fmJhaWR1anNfYmFpZHVsYW5kaW5nd29yZH5kZWZhdWx0LTktODYxNDkzOTAtYmxvZy03ODcyOTkwNi4yMzVedjM1XnBjX3JlbGV2YW50X2luY3JlYXRlX3QwX2Rvd25sb2FkX3YyX2Jhc2Umc3BtPTEwMDEuMjEwMS4zMDAxLjQyNDIuNiZ1dG1fcmVsZXZhbnRfaW5kZXg9MTI%3D&ydreferer=aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FrYWsyMDEwMTEwL2FydGljbGUvZGV0YWlscy84NjE0OTM5MD91dG1fbWVkaXVtPWRpc3RyaWJ1dGUucGNfcmVsZXZhbnQubm9uZS10YXNrLWJsb2ctMn5kZWZhdWx0fmJhaWR1anNfYmFpZHVsYW5kaW5nd29yZH5kZWZhdWx0LTktODYxNDkzOTAtYmxvZy03ODcyOTkwNi4yMzVedjM1XnBjX3JlbGV2YW50X2luY3JlYXRlX3QwX2Rvd25sb2FkX3YyX2Jhc2Umc3BtPTEwMDEuMjEwMS4zMDAxLjQyNDIuNiZ1dG1fcmVsZXZhbnRfaW5kZXg9MTI%3D)