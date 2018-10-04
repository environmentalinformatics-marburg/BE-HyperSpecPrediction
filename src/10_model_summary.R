# model results
library(magrittr)
library(caret, lib.loc = "F:/ma/BE-HyperSpecPrediction/src/Documents/R/win-library/3.2/")
library(CAST, lib.loc = "F:/ma/BE-HyperSpecPrediction/src/Documents/R/win-library/3.2/")
library(rgl, lib.loc = "F:/ma/BE-HyperSpecPrediction/src/Documents/Documents/R/win-library/3.2")
library(minpack.lm, lib.loc = "F:/ma/BE-HyperSpecPrediction/src/Documents/Documents/R/win-library/3.2")
library(qpcR, lib.loc = "F:/ma/BE-HyperSpecPrediction/src/Documents/Documents/R/win-library/3.2")

# normalize RMSE
#--------------------
nrmse <- function(models, target, target_stats, predictor_type){
  
  nrmse_mean <- models$errors / target_stats$mean_value[which(target_stats$predictor == target)]
  nrmse_sd <- models$errors / target_stats$sd[which(target_stats$predictor == target)]
  
  df <- as.data.frame(rbind(nrmse_mean, nrmse_sd))
  colnames(df) <- paste0("fold", seq(7))
  df$target_name <- target
  df$pred_type <- predictor_type
  df$norm_value <- c(target_stats$mean_value[which(target_stats$predictor == target)],
                     target_stats$sd[which(target_stats$predictor == target)])
  df$norm_type <- c("mean", "sd")
  return(df)
  
}


# tuning parameter and number of selected variables
#----------------------------------------------------

fold_stats <- function(models, target, predictor_type){
  tun <- lapply(seq(length(models$models)), function(i){
    nvar <- length(models$models[[i]]$model$selectedvars)
    bestTune <- as.numeric(models$models[[i]]$model$finalModel$tuneValue)
    return(rbind(nvar, bestTune))
  })
  tun <- as.data.frame(do.call(cbind, tun))
  colnames(tun) <- paste0("fold", seq(7))
  tun$target_name = target
  tun$pred_type <- predictor_type
  tun$param_name = c("nvar", "ncomp")
  return(tun)
}


# selected variables
#----------------------

fold_selvar <- function(models, target, predictor_type){
  selected_vars <- lapply(seq(length(models$models)), function(i){
    models$models[[i]]$model$selectedvars
  })
  selvar <- do.call(qpcR:::cbind.na, selected_vars)
  selvar <- as.data.frame(selvar)
  selvar$target <- target
  selvar$pred_group <- predictor_type
  colnames(selvar)[1:7] <- paste0("fold", seq(7))
  
  return(selvar)
}

####################################################################################
# # # CONTROLL # # #
#--------------------

model_fls <- list.files("F:/ma/data/models", recursive = TRUE, full.names = TRUE, pattern = "height")

target_names <- sapply(strsplit(model_fls, "/"), "[[", 5)
predictor_type <- sapply(strsplit(model_fls, "/"), "[[", 6) %>% strsplit("[.]") %>% sapply("[[", 1)
predictor_type <- gsub(".*_", "", predictor_type )

target_stats <- readRDS("F:/ma/data/util/target_mean_sd.RDS")

for(i in seq(length(model_fls))){
  m <- readRDS(model_fls[i])
  gc()
  n <- nrmse(models = m, target = target_names[i], target_stats = target_stats, predictor_type = predictor_type[i])
  saveRDS(n, paste0("F:/ma/data/results_new3/", target_names[i], "_nrmse_", predictor_type[i], ".RDS"))
  f <- fold_stats(models = m, target = target_names[i], predictor_type = predictor_type[i])
  saveRDS(f, paste0("F:/ma/data/results_new3/", target_names[i], "_tuning_", predictor_type[i], ".RDS"))
  if(predictor_type[i] == "ffs"){
    s <- fold_selvar(models = m, target = target_names[i], predictor_type = predictor_type[i])
    saveRDS(s, paste0("F:/ma/data/results_new3/", target_names[i], "_selvar_", predictor_type[i], ".RDS"))
    
  }
  rm(m)
  gc()
}

