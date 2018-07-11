# model with vegetation indices

library(CAST)
library(ggplot2)


ffs1 <- ffs(predictors = predictors, response = targets$nr_sp,
            method = "pls",
            metric = "RMSE",
            tuneLength = 2,
            trControl = ffs_preparations[[1]]$train_control,
            preProc = c("center", "scale", "zv"),
            allowParallel = FALSE,
            verbose = FALSE)


saveRDS(ffs1, "~/ma/ffs_vegind_fold1.RDS")
ffs1 <- readRDS("~/ma/ffs_vegind_fold1.RDS")
ffs1$selectedvars_perf
plot_ffs(ffs_model = ffs1)


pred1 <- predict(ffs1, newdata = predictors[ffs_preparations[[1]]$indep_valid,])
pred1
targets[ffs_preparations[[1]]$indep_valid,]$nr_sp
RMSE(pred = pred1, obs = targets[ffs_preparations[[1]]$indep_valid,]$nr_sp)
install.packages("ggplot2")
library(ggplot2)
