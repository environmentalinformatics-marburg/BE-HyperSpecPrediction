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

Script: plot_based_summary <br/>
Converted to a data frame with one row per Plot. Because of previous model namings, the column names need to be:
* Single bands: mean400.4
* Vegetation index: Carter_mean, Carter_sd
* NRI: mean_wl_400_404 (Wavelength rounded)

## Initial modelling with AEG
the 26 plots of the Alb Exploratory are used in the Scripts:
1. 07_merge_predictors
1. 08_model_preparation
1. 09a_independent_fold_training
1. 09b_independent_fold_control

## Model validation
the other two exploratories are used afterwards for model validation on independent regions
Scripts:
1. field_data_summary
1. extract_aeg_model_variables
1. predict_aeg_hai_sch
