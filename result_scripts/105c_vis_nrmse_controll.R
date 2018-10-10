# plot model performance
library(ggplot2)
library(forcats)
library(dplyr)
library(plyr)
library(reshape2)

pa <- c("nrmse_single", "nrmse_vegind") 
  
  
bplots <- lapply(pa, function(i){
  nrmse <- lapply(list.files("~/ma/data/results/", pattern = i, recursive = TRUE, full.names = TRUE), readRDS)
  nrmse <- do.call(rbind, nrmse)
  nrmse$pred_type <- NULL
  
  nrmse_sd <- melt(nrmse[nrmse$norm_type == "sd",], value = "target_name", measure.vars = seq(7))
  
  nrmse_sd %>%
    mutate(target_name = fct_relevel(target_name, "leaf_N", "leaf_P", 
                                     "seedmass", "leaf_drymass", "SLA",
                                     "leaf_area", "SSD", "biomass_g",
                                     "height", "evenness", "shannon", "nr_sp")) %>%
    ggplot(aes(target_name, value))+
    geom_boxplot()+
    scale_x_discrete(name = NULL)+
    scale_y_continuous(name = "nRMSE")+
    geom_hline(yintercept = 1, linetype = "dotted")
 
})

pdf("~/ma/data/visualization/single_model_performance.pdf", width = 12, height = 3)
bplots[[1]]
dev.off()

pdf("~/ma/data/visualization/vegind_model_performance.pdf", width = 12, height = 3)
bplots[[2]]
dev.off()
