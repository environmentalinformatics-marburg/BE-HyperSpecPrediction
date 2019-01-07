# predict AEG models on SCH and HAI
library(CAST)
library(pls)

source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")


input <- readRDS(paste0(p$aerial_summary$here, "alb_model_variables.RDS"))
targets <- readRDS(paste0(p$field_data$here, "targets.RDS"))

tnames <- c("biomass_g", "evenness", "height", "leaf_area",
            "leaf_drymass", "leaf_N", "leaf_P", "nr_sp",
            "seedmass", "shannon", "SLA", "SSD")

models <- list.files(p$models$here, recursive = TRUE, full.names = TRUE, pattern = "nested_ffs")

valid_df <- lapply(seq(length(models)), function(i){
  # load all models for one trait
  mod <- readRDS(models[i])
  # iterate these models and predict
  seven_predictions <- lapply(seq(7), function(m){
    pr <- predict(mod$models[[m]]$model, input)
    return(pr)
  })
  pred_df <- data.frame(EPID = input$EPID, target = tnames[i],
                        do.call(cbind, seven_predictions),
                        targets[,which(colnames(targets) == tnames[i])])
  colnames(pred_df) <- c("EPID", "target", paste0("fold", seq(7)), "observation") 
  return(pred_df)
})

vdf <- do.call(rbind, valid_df)
saveRDS(vdf, paste0(p$results$here, "trait_prediction.RDS"))





