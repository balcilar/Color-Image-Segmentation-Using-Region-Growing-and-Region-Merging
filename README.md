# Unsupervised color image segmentation using Region Growing and Region Merging

This project is reimplementation of research on color image segmentataion using region growing and region merging respectively [1]. We prepared a demo code that you can load flower image and see 4 different level of region growing results from coarsed one to refined one. After you can see how the region merging has an effect on refined version of region growing. Here is the original input, all 4 level of region growing results and also final segmentation result. In this demo we feed region merging function with scale1 region growing results. But note you can feed the region merging function with either sclae 2, scale 3 or scale 4. 

![Sample image](Outputs/result.jpg?raw=true "Title")

To run provided demo, please run Demo script as follows;

```
> Demo
```

## Reference
[1] Balasubramanian, Guru Prashanth, et al. "Unsupervised color image segmentation using a dynamic color gradient thresholding algorithm." Human Vision and Electronic Imaging XIII. Vol. 6806. International Society for Optics and Photonics, 2008.
