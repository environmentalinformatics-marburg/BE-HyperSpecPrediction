# visualization of nRMSE in matix
library(ggplot2)
library(viridis)
library(magrittr)
library(dplyr)
library(forcats)
# load all nrmse results
nrmse_df <- do.call(rbind, lapply(list.files("~/ma/data/results/", 
                                      recursive = TRUE, pattern = "nrmse",
                                      full.names = TRUE), readRDS))
# choose the sd as normalization value
nrmse_df <- nrmse_df[nrmse_df$norm_type == "sd",]
# exclude lidar
nrmse_df <- nrmse_df[nrmse_df$pred_type != "lidar",]
# create the mean of all folds
nrmse_df$nrmse_mean <- rowMeans(nrmse_df[,1:7])
# look for each trait, which model is the best, mark it with a "*"
nrmse_df$id <- seq(nrow(nrmse_df))
best_id <- nrmse_df %>% group_by(target_name) %>% filter(nrmse_mean == min(nrmse_mean)) %>% select(id)

nrmse_df$best <- ""
nrmse_df$best[best_id$id] <- "*"


pdf("~/ma/data/visualization/nrmse_matrix.pdf")
nrmse_df %>%
  mutate(target_name = fct_relevel(target_name, "leaf_N", "leaf_P", 
                                   "seedmass", "leaf_drymass", "SLA",
                                   "leaf_area", "SSD", "biomass_g",
                                   "height", "evenness", "shannon", "nr_sp")) %>%
  mutate(pred_type = fct_relevel(pred_type, "single", "vegind", "nri", "train", "ffs")) %>%
ggplot(aes(pred_type, target_name, fill = nrmse_mean))+
  geom_raster()+
  xlab("Predictor group")+
  ylab("Target")+
  scale_fill_gradientn(colors = viridis(20, direction = -1), breaks = seq(0,1,0.2),guide = "colorbar" ,name = "nRMSE")+
  geom_text(aes(label = paste0(round(nrmse_mean, 3), best)))+
  theme(panel.background = element_blank())

dev.off()






