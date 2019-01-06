# transform data frames:
library(reshape2)
library(plyr)

source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")


# reshape vegetation indices
vegind <- readRDS(paste0(p$aerial_summary$here, "be_hy_vegetation_indices.RDS"))

v_mean <- dcast(vegind, formula = EPID ~ index , value.var = "mean")
colnames(v_mean) <- c("EPID", paste0(colnames(v_mean)[-1], "_mean"))

v_sd <- dcast(vegind, formula = EPID ~ index , value.var = "sd")
colnames(v_sd) <- c("EPID", paste0(colnames(v_sd)[-1], "_sd"))

v <- join(v_mean, v_sd, "EPID")
saveRDS(v, paste0(p$aerial_summary, "be_hy_vegetation_indices_plots.RDS"))


# reshape single bands
single  <- readRDS(paste0(p$aerial_summary$here, "be_hy_single_bands.RDS"))

s_mean <- dcast(single, formula = EPID ~ wl, value.var = "mean")
colnames(s_mean) <- c("EPID", paste0("mean", colnames(s_mean)[-1]))

s_sd <- dcast(single, formula = EPID ~ wl, value.var = "sd")
colnames(s_sd) <- c("EPID", paste0("sd", colnames(s_sd)[-1]))

s <- join(s_mean, s_sd, "EPID")
saveRDS(s, paste0(p$aerial_summary, "be_hy_single_bands_plots.RDS"))



# reshape nri
nri <- readRDS(paste0(p$aerial_summary$here, "be_hy_nri.RDS"))

nri$wl_comb <- paste0("mean_wl_", round(nri$wl1), "_",  round(nri$wl2))
n_mean <- dcast(nri, formula = EPID ~ wl_comb, value.var = "nri_mean")

saveRDS(n_mean, paste0(p$aerial_summary, "be_hy_nri_plots.RDS"))



