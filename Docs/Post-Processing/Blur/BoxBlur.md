# BoxBlur

Box blur is a convolution operation with uniform weighting. In this example, a 5x5 kernel is used. The convolution filter is as follows:

$$
M = 
\begin{bmatrix} 
  0.04 & 0.04 & 0.04 & 0.04 & 0.04 \\ 
  0.04 & 0.04 & 0.04 & 0.04 & 0.04 \\ 
  0.04 & 0.04 & 0.04 & 0.04 & 0.04 \\ 
  0.04 & 0.04 & 0.04 & 0.04 & 0.04 \\ 
  0.04 & 0.04 & 0.04 & 0.04 & 0.04 
\end{bmatrix}
$$

Directly using this filter would require $N \times N \times W \times H$ calculations. However, it can be split into two passes, reducing the computational cost to $2 \times N \times W \times H$.

$$
M = 
\begin{bmatrix} 
  0.2 \\ 
  0.2 \\ 
  0.2 \\ 
  0.2 \\ 
  0.2 
\end{bmatrix} 
\begin{bmatrix} 
  0.2 & 0.2 & 0.2 & 0.2 & 0.2 
\end{bmatrix}
$$

<p align="center">
  <img src="/Imgs/Post-Processing/BoxBlur/01.gif" alt="Box Blur" title="Box Blur">
</p>
