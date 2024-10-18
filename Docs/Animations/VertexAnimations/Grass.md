# Grass

## Introduction

This project implemented simple `vertex animation` and `billboard` effects to simulate grass. In the future, I will try to incorporate Noise textures to handle wind direction and implement `shadow-caster`.

### Wind Simulation

The principle is to use a periodic function to apply displacement to the vertices. In this case, the `sin()` function is used.

### Billboard

The principle is to transform the local coordinate system of the object into a camera-facing coordinate system.

First, the coordinate system where the "Z-axis points towards the camera" is calculated. By applying this transformation, the local coordinate system can be converted into the camera-facing coordinate system. Additionally, since the rotation occurs around the Y-axis, setting the Y component of the vector pointing to the camera to 0 can prevent rotation on the XZ plane from tilting up or down.

## Usage
1. Play Unity
2. Click `Space` button to change wind direction

## References
- This project uses [Grass And Flowers Pack 1](https://assetstore.unity.com/packages/2d/textures-materials/nature/grass-and-flowers-pack-1-17100) assets.