# independent fold control
# PLS models without a feature selection for every group of predictor variables
# target for now is the number of species

source("~/ma/BE-HyperSpecPrediction/src/07_merge_predictors.R")
source("~/ma/BE-HyperSpecPrediction/src/08_model_preparations.R")
source("~/ma/BE-HyperSpecPrediction/src/09a_independent_fold_training.R")

# for the lidar variables
lidar_sp_nr <- indep_fold_train(model_runs = model_folds,
                                pred = data_list$lidar_indices.RDS,
                                target = data_list$targets.RDS$nr_sp)

mean(lidar_sp_nr$errors)


# for the vegetation indices
vegind_sp_nr <- indep_fold_train(model_runs = model_folds,
                                 pred = data_list$vegindices.RDS,
                                 target = data_list$targets.RDS$nr_sp)
mean(vegind_sp_nr$errors)
sd(vegind_sp_nr$errors)

# for the vegetation indices, but only with the variables selected in the testrun of the ffs
ffs_testrun <- readRDS("~/ma/data/models/ffs_vegind_fold1.RDS")
ffs_testrun$selectedvars

vegind_subset_sp_nr <- indep_fold_train(model_runs = model_folds,
                                        pred = data_list$vegindices.RDS[,ffs_testrun$selectedvars],
                                        target = data_list$targets.RDS$nr_sp)
mean(vegind_subset_sp_nr$errors)
sd(vegind_subset_sp_nr$errors)

# for the single bands
single_sp_nr <- indep_fold_train(model_runs = model_folds,
                                 pred = data_list$single_bands.RDS,
                                 target = data_list$targets$nr_sp)
mean(single_sp_nr$errors)
sd(single_sp_nr$errors)


# for the lidar with a ffs
lidar_ffs_sp_nr <- indep_fold_ffs(model_runs = model_folds,
                                  pred = data_list$lidar_indices.RDS,
                                  target = data_list$targets.RDS$nr_sp)
mean(lidar_ffs_sp_nr$errors)
sd(lidar_ffs_sp_nr$errors)

for(i in seq(7)){
  print(lidar_ffs_sp_nr$models[[i]]$model$selectedvars)
  CAST::plot_ffs(lidar_ffs_sp_nr$models[[i]]$model)
}

CAST::plot_ffs(lidar_ffs_sp_nr$models[[1]]$model)


# for the nri but filtered to red edge band combinations (650 - 800 nm)
nri_info <- round(readRDS("~/ma/data/util/narrow_band_combinations.RDS"))
red_edge <- (nri_info$wl1 > 650 & nri_info$wl1 < 800) & (nri_info$wl2 > 650 & nri_info$wl2 < 800)

nri <- data_list$narrow_bands.RDS[,red_edge]


nri_re_sp_nr <- indep_fold_train(model_runs = model_folds,
                                    pred = nri,
                                    target = data_list$targets.RDS$nr_sp)

# i thinks its overfitted
mean(nri_re_sp_nr$errors)
sd(nri_re_sp_nr$errors)


# with lidar and recursive feature elimination
lidar_rfe_sp_nr <- indep_fold_rfe(model_runs = model_folds,
                                  pred = data_list$lidar_indices.RDS,
                                  target = data_list$targets.RDS$nr_sp)



