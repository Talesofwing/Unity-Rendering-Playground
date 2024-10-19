# Outline-Based-Fresnel

The implementation is effective for spherical objects. It uses the [Schlick Approximation](https://en.wikipedia.org/wiki/Schlick%27s_approximation), with the following formulas:

$$
R(0) = (\frac{\eta_1 - \eta_2}{\eta_1 + \eta_2})^2 \\
F(v, n) = R_0 + (1 - R_0) \cdot (1 - \cos(\theta))^5
$$

- $R_0$ is the reflectance calculated from the refractive indices of the two media.In the project, $R_0$ is directly provided as an input parameter.
- $\eta_1$ is the refractive index of the incident medium, and $\eta_2$ is the refractive index of the exiting medium.
- $\theta$ is the angle between the normal and the view direction.