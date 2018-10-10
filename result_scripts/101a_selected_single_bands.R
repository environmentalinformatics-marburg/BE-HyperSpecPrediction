# compare vegetation indices between targets
library(dplyr)
library(plyr)
library(reshape2)
library(ggplot2)
library(viridis)

# load the sleected variables
s_list <- lapply(list.files("~/ma/data/results", pattern = "selvar_single", recursive = TRUE, full.names = TRUE), readRDS)
# convert all factors to strings
for(i in seq(length(s_list))){
  s_list[[i]] %>% dplyr::mutate_if(is.factor, as.character) -> s_list[[i]]
}

s_unique <- lapply(s_list, function(x){
  unique_selvar <- as.data.frame(table(do.call(c, x[,1:7])))
  unique_selvar <- unique_selvar[order(unique_selvar$Freq, decreasing = TRUE),]
  unique_selvar$target <- x$target[1]
  return(unique_selvar)
})
s_df <- do.call(rbind, s_unique)

# get info on mean or sd
s_df$type <- substr(s_df$Var1, 1,1)
# convert Var1 to a wavelength column
s_df$wl <- as.numeric(gsub("[a-z]","", s_df$Var1))


# draw a spectrum and mark the selected bands
veg_spec <- readRDS("~/ma/data/finished_df/single_bands.RDS")
veg_spec_2 <- readRDS("~/ma/data/util/hyperspectral_band_info.RDS")

spec_gg <- data.frame(wl = veg_spec_2$wavelength)
spec_gg$ref_mean <- colMeans(veg_spec[,1:160])
spec_gg$ref_sd <- t(colwise(sd)(veg_spec[,1:160]))

# change lab position based on target type
lab_positions <- data.frame(target = c("nr_sp", "shannon", "evenness", "height", "biomass_g",
                                       "SSD", "leaf_area", "SLA", "leaf_drymass", "seedmass", "leaf_P", "leaf_N"),
                            pos = seq(220, 6000, 500))

s_df <- join(s_df, lab_positions, by = "target")

# plot nice graphic
pdf("~/ma/data/visualization/selected_single_bands.pdf", height = 4.5)
ggplot(spec_gg, mapping = aes(x = wl, y = ref_mean))+
  #geom_line(color = "gray40")+
  scale_x_continuous(limits = c(400, 1000), name = "Wavelength [nm]", breaks = seq(400, 1000, 50), expand = c(0.02, 0.02))+
  scale_y_continuous(name = NULL, breaks = lab_positions$pos, labels = lab_positions$target)+
  #geom_ribbon(aes(ymax = ref_mean+ref_sd, ymin = ref_mean - ref_sd), alpha = 0.15)+
  geom_point(data = s_df, aes(x = wl, y = pos, col = type), alpha = 0.9, size = 2.5, shape = 15)+
  scale_color_discrete(name = NULL, labels = c("mean", "sd"))+
  theme(panel.grid.major.y = element_line(color = "gray70", linetype = "dotted"),
        panel.grid.minor = element_blank(),
        legend.position = "none")+
  geom_vline(xintercept = 650, color = "grey50", linetype = "dashed")+
  geom_vline(xintercept = 800, color = "grey50", linetype = "dashed")
dev.off()