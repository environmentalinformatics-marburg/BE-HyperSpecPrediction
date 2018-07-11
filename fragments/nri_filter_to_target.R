library(plyr)
library(ggplot2)
library(viridis)
library(colorspace)
mypal <- colorspace::choose_palette()

# load nri
data_list <- lapply(list.files("~/ma/data/finished_df/", full.names = TRUE), readRDS)
names(data_list) <- list.files("~/ma/data/finished_df/", full.names = FALSE)

narrow <- data.frame(EPID = readRDS("~/ma/data/util/AEG_names.RDS"), stringsAsFactors = FALSE)
narrow <- join(narrow, data_list$narrow_bands.RDS, by = "EPID")

narrow$EPID <- NULL

# load targets
targets <- data_list$targets.RDS
target <- targets$nr_sp

# univariate nri correlation to a target variable
nri_cor <- function(narrow, target){
  metric <- lapply(seq(length(narrow)), function(p){
    correl <- cor(target, narrow[,p])
    lmod <- lm(target ~ narrow[,p])
    
    return(data.frame(var = colnames(narrow)[p],
                      correl = correl,
                      rsq = summary(lmod)$r.squared,
                      pvalue = summary(lmod)$coefficients[2,4]))

  })
  return(do.call(rbind, metric))
}

nri_correl <- nri_cor(narrow, target)

# create plot dataframe
plot_df <- readRDS("~/ma/data/util/narrow_band_combinations.RDS")
plot_df$cor_mean <- nri_correl[1:12720,2]
plot_df$rsq <- nri_correl[1:12720,3]
plot_df$pval <- nri_correl[1:12720,4]

plot_df[plot_df$pval < 0.05,]

ggplot(plot_df[plot_df$pval < 0.05,], aes(wl1, wl2, col = rsq))+
  geom_point()+
  scale_color_gradientn(colours = viridis(10))
  #coord_cartesian(xlim = c(650, 800), ylim = c(650,800))
boxplot(plot_df$cor_mean)
cor

