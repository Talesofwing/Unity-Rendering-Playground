# Grayscale

Advanced algorithms for grayscale images take into account the human eye's perception of different colors and brightness to produce grayscale images that are more aligned with human visual effects. In the project, the following formula was used:

$$
gray = 0.299red + 0.587green + 0.114blue
$$

In fact, there are many variations of the weighted average method. For example, some systems use:

$$
gray = 0.2126red + 0.7152blue + 0.0722blue
$$

These differences are usually minor and have little effect on the final result.

<p align="center">
  <img src="/Imgs/Post-Processing/Grayscale/01.gif" alt="Grayscale" title="Grayscale">
</p>
