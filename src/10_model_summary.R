# ffs fold model summary functions
library(CAST)
library(qpcR)
library(ggplot2)
library(caret)
library(Rsenal)


targets <- readRDS("~/ma/data/finished_df/targets.RDS")


# # # selected variables per fold model # # #
#-------------------------------------------#
fold_selvar <- function(models){
  
  # selected variables and their occurence
  selected_vars <- lapply(seq(length(models$models)), function(i){
    models$models[[i]]$model$selectedvars
  })
  raw_selvar <- do.call(qpcR:::cbind.na, selected_vars)
  
  # with occurence
  unique_selvar <- as.data.frame(table(do.call(c, selected_vars)))
  unique_selvar <- unique_selvar[order(unique_selvar$Freq, decreasing = TRUE),]
  unique_selvar$Var1 <- factor(unique_selvar$Var1, levels = unique_selvar$Var1[order(unique_selvar$Freq, decreasing = FALSE)])
  plot_selvar <- ggplot(unique_selvar, aes(x = Var1, y = Freq))+
    geom_bar(stat = "identity")+
    coord_flip()
  
  return(list(raw_selvar = raw_selvar,
              unique_selvar = unique_selvar,
              plot_selvar = plot_selvar))
  }
 

# # # tuning parameter and quality per fold model # # #
#-----------------------------------------------------#

fold_tuning <- function(models, target_name){
  
  # error values for each fold #
  source("~/ma/BE-HyperSpecPrediction/src/08_model_preparations.R")
  er <- lapply(seq(length(models$models)), function(i){
    Rsenal::regressionStats(prd = models$models[[i]]$indep_pred,
                            obs = targets[[folds[[i]]], which(colnames(targets == target_name))])
  })
  er <- do.call(rbind, er)

  # tuning parameter for each fold #
  tun <- lapply(seq(length(models$models)), function(i){
    nvar <- length(models$models[[i]]$model$selectedvars)
    bestTune <- as.numeric(models$models[[i]]$model$finalModel$tuneValue)
    return(data.frame(nvar = nvar,
                      bestTune = bestTune))
  })
  tun <- do.call(rbind, tun)
  
  # combine to one df
  id <- data.frame(model = paste0("Model", sprintf("%02d",seq(length(models$models)))))
  id <- cbind(id, tun, er)
  return(id)
}


ft <- fold_tuning(models)
sv <- fold_selvar(models)
sv$plot_selvar


