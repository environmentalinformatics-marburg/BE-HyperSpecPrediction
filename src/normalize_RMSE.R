source("/home/marvin/be_hyperspectral/BE-HyperSpecPrediction/src/set_environment.R")


# mean and sd of the traits per EP
trait_lut <- readRDS(paste0(p$util$here, "EP_trait_mean_sd.RDS"))


# predictions
trait_pred <- readRDS(paste0(p$results$here, "ep_rmse.RDS"))


# define criteria
m <- trait_lut$method == "mean"
colnames(trait_lut) <- c("EP", "method", "trait", "value")

# get the mean values
trait_pred <- join(trait_pred, trait_lut[trait_lut$method == "mean",], by = c("EP", "trait"))
trait_pred$method <- NULL
colnames(trait_pred)[5] <- "lut_mean"


# and the sd
trait_pred <- join(trait_pred, trait_lut[trait_lut$method == "sd",], by = c("EP", "trait"))
trait_pred$method <- NULL
colnames(trait_pred)[6] <- "lut_sd"


trait_pred$meanRMSE <- trait_pred$RMSE / trait_pred$lut_mean
trait_pred$meanSD <- trait_pred$RMSE / trait_pred$lut_sd

saveRDS(trait_pred, paste0(p$results$here, "EP_nrmse.RDS"))



