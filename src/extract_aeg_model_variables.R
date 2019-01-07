# get variable names from the ffs models

library(reshape2)
library(plyr)

source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")


selvar <- list.files(p$results$here, recursive = TRUE, full.names = TRUE, pattern = "selvar_ffs")


var_ext <- lapply(seq(length(selvar)), function(x){
  
  cur <- readRDS(selvar[x])
  curm <- melt(data = cur, id.vars = 8, measure.vars = 1:7)
  colnames(curm) <- c("trait", "fold", "variable")
  curm <- na.omit(curm)
  return(curm)
  
})

var_df <- do.call(rbind, var_ext)
saveRDS(var_df, paste0(p$results$here, "ffs_variable_list.RDS"))



# filter the selected variables of ALB models
si <- readRDS(paste0(p$aerial_summary$here, "be_hy_single_bands_plots.RDS"))
nr <- readRDS(paste0(p$aerial_summary$here, "be_hy_nri_plots.RDS"))
ve <- readRDS(paste0(p$aerial_summary$here, "be_hy_vegetation_indices_plots.RDS"))

input_df <- join_all(list(si, nr, ve), by = "EPID")
input_df <- input_df[,which(colnames(input_df) %in% c("EPID", var_df$variable))]


saveRDS(input_df, paste0(p$aerial_summary$here, "alb_model_variables.RDS"))



