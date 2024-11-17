# Bloom

The Bloom implementation process can be broken down into three main parts:

1. Brightness Extraction: This stage identifies and isolates bright areas of the image that exceed a specified threshold.
2. Blur: The extracted brightness values are blurred to create the glow effect.
3. Blending: The blurred brightness values are combined with the original image to create the final Bloom effect.

In this example, include three brightness extraction methods:
- Hard Thresholding: Pixels above the threshold are considered bright; those below are discarded.
- Linear Interpolation: A smooth transition between bright and dark pixels is achieved using linear interpolation around the threshold.
- Quadratic Interpolation: A more pronounced and stylized transition is achieved using a quadratic curve around the threshold.

and use [Gaussian blur](Blur/GaussianBlur.md) for the blurring stage, along with two blending modes:
- Additive Blending: Directly adding the blurred brightness to the original image.
- Screen Blending: A softer blending method that multiplies the inverse of the brightness and the original image, then inverts the result.

<p align="center">
  <img src="/Imgs/Post-Processing/Bloom/01.gif" alt="Bloom" title="Bloom">
</p>