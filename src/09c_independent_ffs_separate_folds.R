# 09c independent fold ffs separate
library(caret, lib.loc = "F:/ma/BE-HyperSpecPrediction/src/Documents/R/win-library/3.2/")
library(CAST, lib.loc = "F:/ma/BE-HyperSpecPrediction/src/Documents/R/win-library/3.2/")
source("F:/ma/BE-HyperSpecPrediction/src/07_merge_predictors.R")
source("F:/ma/BE-HyperSpecPrediction/src/08_model_preparations.R")

indep_fold_ffs <- function(model_runs, pred, target){
  indep_valid <- lapply(model_runs, function(p){
    model <- CAST::ffs(predictors = pred, response = target,
                       method = "pls",
                       metric = "RMSE",
                       tuneLength = 10,
                       trControl = p[[1]],
                       preProc = c("center", "scale", "zv"),
                       withinSE = TRUE,
                       verbose = TRUE)
    indep_pred <- predict(model, newdata = pred[p[[2]],])
    error <- RMSE(pred = indep_pred, obs = target[p[[2]]])
    
    return(list(model = model,
                indep_pred = indep_pred,
                error = error))
  })
  error <- lapply(indep_valid, "[[", 3)
  return(list(models = indep_valid,
              errors = do.call(c, error)))
  
}

targets <- data_list$targets.RDS[,16:27]

# # # prepare predictors # # #
# reduce nri to red edge
nri_info <- round(readRDS("F:/ma/data/util/narrow_band_combinations.RDS"))
red_edge <- (nri_info$wl1 > 650 & nri_info$wl1 < 800) & (nri_info$wl2 > 650 & nri_info$wl2 < 800)


pred_groups <- list(nri = data_list$narrow_bands.RDS[,red_edge])
# only take the nri means
pred_groups$nri <- pred_groups$nri[,1:820]


# modified function, only does one ffs of the 7
tn <- "height"
t <- targets[,which(colnames(targets) == tn)]

p <- pred_groups[[1]]
pn <- "nri"

mod <- indep_fold_ffs(model_runs = list(model_folds[[1]]),
                      pred = p,
                      target = t)

saveRDS(mod, paste0("F:/ma/data/nri_models/", tn, "_", pn, "fold1.RDS"))
gc()
  






