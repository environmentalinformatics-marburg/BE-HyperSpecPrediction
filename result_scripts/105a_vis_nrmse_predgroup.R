# visualization of fold model performance for one predictor group
library(ggplot2)
library(forcats)
library(dplyr)
library(plyr)
library(reshape2)

# CHOOSE PREDICTOR 
#------------------
pred <- "ffs"

# plot model quality based on sd normalised RMSE
# everything under 1 us good because that means, the model predicted within the range of the standard deviation
# of the original data
nrmse <- lapply(list.files("~/ma/data/results/", pattern = paste0("nrmse_", pred), recursive = TRUE, full.names = TRUE), readRDS)
nrmse <- do.call(rbind, nrmse)
nrmse$pred_type <- NULL

nrmse_sd <- melt(nrmse[nrmse$norm_type == "sd",], value = "target_name", measure.vars = seq(7))

pdf(paste0("~/ma/data/visualization/",pred,"_model_performance.pdf"), width = 12, height = 4)

nrmse_sd %>%
  mutate(target_name = fct_relevel(target_name, "leaf_N", "leaf_P", 
                                   "seedmass", "leaf_drymass", "SLA",
                                   "leaf_area", "SSD", "biomass_g",
                                   "height", "evenness", "shannon", "nr_sp")) %>%
  ggplot(aes(target_name, value))+
  stat_boxplot(geom = "errorbar")+
  geom_boxplot()+
  scale_x_discrete(name = NULL)+
  scale_y_continuous(name = "nRMSE")+
  geom_hline(yintercept = 1, linetype = "dotted")

dev.off()
