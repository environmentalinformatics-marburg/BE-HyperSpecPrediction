# independent fold control

source("~/ma/BE-HyperSpecPrediction/src/08_model_preparations.R")
source("~/ma/BE-HyperSpecPrediction/src/09a_independent_fold_training.R")


lidar_sp_nr <- indep_fold_train(model_runs = ffs_preparations,
                                pred = predictors,
                                target = targets$nr_sp)

mean(lidar_sp_nr$errors)


vegind_sp_nr <- indep_fold_train(model_runs = ffs_preparations,
                                 pred = predictors,
                                 target = targets$nr_sp)
mean(vegind_sp_nr$errors)

single_sp_nr <- indep_fold_train(model_runs = ffs_preparations,
                                 pred = predictors,
                                 target = targets$nr_sp)
mean(single_sp_nr$errors)
