# Unity-ScreenSpaceShadowMapping

I currently don't have a deep understanding of SSSM, so I will supplement my notes when more detailed shadows can be rendered later.

### Questions

1. How to make the camera cover the entire scene and obtain a high-quality shadow-map in the case of directional light source.

### TODO
- [x] Shadow Caster
- [x] Shadow Collector
- [x] Display shadow-map
- [ ] Shadow Quality
- [ ] CSM(Cascade Shadow Map)
- [ ] Point Light
- [ ] Spot Light
- [ ] Soft Shadow

### Results

Camera Depth Texture
![camera-depth](/Imgs/Shadow/camera_depth_tex.png)

Light Depth Texture
![light-depth](/Imgs/Shadow/light_depth_tex.png)

Shadow Map
![shadow-map](/Imgs/Shadow/shadow_map.png)

Result
![result](/Imgs/Shadow/result.png)