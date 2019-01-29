# LUT mean and sd per trait per EP

source("/home/marvin/be_hyperspectral/BE-HyperSpecPrediction/src/set_environment.R")


# load traits
traits <- readRDS(paste0(p$field_data$here, "targets.RDS"))
traits$EP <- substr(traits$EPID, 1,1)

# calculate means and sd over each exploratory and trait
trait_means <- aggregate(traits[,2:13], by = list(EP = traits$EP), FUN = "mean", na.rm = TRUE)
trait_sd <- aggregate(traits[,2:13], by = list(EP = traits$EP), FUN = "sd", na.rm = TRUE)

trait_means$method <- "mean"
trait_sd$method <- "sd"

# combine to LUT
trait_norm <- rbind(trait_means, trait_sd)
trait_norm <- melt(trait_norm, id.vars = c("EP", "method"))

# save results for further use
saveRDS(trait_norm, paste0(p$util$here, "EP_trait_mean_sd.RDS"))