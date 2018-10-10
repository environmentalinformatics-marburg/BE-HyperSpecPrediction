# compare vegetation indices between targets
library(dplyr)
library(plyr)
library(reshape2)
library(ggplot2)
library(viridis)

# load the selected variables
s_list <- lapply(list.files("~/ma/data/results", pattern = "selvar_nri", recursive = TRUE, full.names = TRUE), readRDS)
# convert all factors to strings and clean up the mess with nri lists
for(i in seq(length(s_list))){
  if(length(s_list[[i]]) <= 2){
    s_list[[i]] <- s_list[[i]][[1]]
    #print(i)
  }
  s_list[[i]] %>% dplyr::mutate_if(is.factor, as.character) -> s_list[[i]]
}

x <- s_list[[1]]
s_unique <- lapply(s_list, function(x){
  unique_selvar <- data.frame(Var1 = as.vector(as.matrix(x[, 1:7])))
  unique_selvar$target <- x$target[1]
  return(unique_selvar)
})

s_df <- do.call(rbind, s_unique)
s_df <- na.omit(s_df)

# convert Var1 to a wavelength column

s_df$wl1 <- as.numeric(unlist(lapply(strsplit(as.character(s_df$Var1), split = "_"), "[[", 3)))
s_df$wl2 <- as.numeric(unlist(lapply(strsplit(as.character(s_df$Var1), split = "_"), "[[", 4)))


# draw a spectrum and mark the selected bands
veg_spec <- readRDS("~/ma/data/finished_df/single_bands.RDS")
veg_spec_2 <- readRDS("~/ma/data/util/hyperspectral_band_info.RDS")

spec_gg <- data.frame(wl = veg_spec_2$wavelength)
spec_gg$ref_mean <- colMeans(veg_spec[,1:160])
spec_gg$ref_sd <- t(colwise(sd)(veg_spec[,1:160]))

spec_gg <- spec_gg[spec_gg$wl > 650 & spec_gg$wl < 800,]

# change lab position based on target type
lab_positions <- data.frame(target = c("nr_sp", "shannon", "evenness", "height", "biomass_g",
                                       "SSD", "leaf_area", "SLA", "leaf_drymass", "seedmass", "leaf_P", "leaf_N"),
                            pos = seq(220, 3500, length.out = 12))

s_df <- join(s_df, lab_positions, by = "target")


# plot nice graphic

pdf("~/ma/data/visualization/selected_nri.pdf")
ggplot(data = spec_gg, mapping = aes(wl, ref_mean))+
  geom_line(color = "grey40")+
  geom_curve(s_df, mapping = aes(x = wl1, y = pos, xend = wl2, yend = pos, color = target), curvature = 0.3, ncp = 5)+
  scale_color_manual(values = viridis(12))+
  scale_x_continuous(name = "Wavelength [nm]")+
  scale_y_continuous(name = NULL, breaks = lab_positions$pos, labels = lab_positions$target, limits = c(200, 4000))+
  theme(panel.background = element_blank(), 
        panel.grid.major.y = element_line(color = "gray70", linetype = "dashed"),
        panel.grid.major.x = element_blank(),
        legend.position = "none")
dev.off()
