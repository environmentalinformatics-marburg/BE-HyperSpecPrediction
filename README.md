# BE-HyperSpecPrediction
Prediction of biodiversity variables using hyperspectral observations.

Workflow for the prediction of plant traits and biodiversity on grasslands in the biodiversity exploratories.

## Prepare hyperspectral data
Scripts:
1. set_environment
1. get_hyperspectral_data
   * locate 10m centers in GIS, avoid roads, climate stations etc.
1. crop_hyperspectral_data

## Indices and plot based summary
Scripts:
1. vegetation_indices
1. narrow_range_indices
1. single_bands

Output format of the data frames:

| EPID | WL / Index | mean | sd |
|------|------------|------|----|

This gets converted to a data frame with one row per Plot. Because of previous model namings, the column names need to be:
* Single bands: mean400.4
* Vegetation index: Carter_mean, Carter_sd
* NRI: mean_wl_400_404
