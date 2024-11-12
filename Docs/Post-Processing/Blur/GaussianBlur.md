# GaussianBlur

Gaussian blur is a commonly used blurring method. In this example, a filter with $\sigma = 0.84089642$ and a 5x5 kernel is used. The convolution filter is as follows:

$$
M = \begin {bmatrix} 0.0030 & 0.0133 & 0.0219 & 0.0133 & 0.0030 \\ 0.0133 & 0.0596 & 0.0983 & 0.0596 & 0.0133 \\ 0.0219 & 0.0983 & 0.1621 & 0.0983 & 0.0219 \\ 0.0133 & 0.0596 & 0.0983 & 0.0596 & 0.0133 \\ 0.0030 & 0.0133 & 0.0219 & 0.0133 & 0.0030 \\ \end {bmatrix}
$$

Directly using this filter would require $N \times N \times W \times H$ calculations. However, it can be split into two passes, reducing the computational cost to $2 \times N \times W \times H$.

$$
M = \begin{bmatrix} 0.0545 \\ 0.2442 \\ 0.4026 \\ 0.2442 \\ 0.5450 \end{bmatrix} \begin{bmatrix} 0.0545 & 0.2442 & 0.4026 & 0.2442 & 0.5450 \end{bmatrix}
$$

![03](/Imgs/Post-Processing/GaussianBlur/01.gif)