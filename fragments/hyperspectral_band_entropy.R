# variance and entropy of hyperspectral data

library(raster)
library(hsdar)
library(ggplot2)
library(viridis)

hy <- brick("~/ma/data/hyperspectral/10m_plots/hy_10m_AEG01.tif")
hy2 <- brick("~/ma/data/hyperspectral/10m_plots/hy_10m_AEG02.tif")
hy_wl <- readRDS("~/ma/data/util/hyperspectral_band_info.RDS")

hy <- speclib(c(hy, hy2), hy_wl$wavelength)
plot(hy)

#
nri_comb <- readRDS("~/ma/data/util/narrow_band_combinations.RDS")
nri1 <- readRDS("~/ma/data/hyperspectral/narrow_band_indices/AEG01_nri.RDS")

nri_comb$sd <- nri1$nri_sd
ggplot(nri_comb, aes(wl1, wl2, col = var))+
  geom_point()+
  scale_color_gradientn(colours = viridis(10))


plot(seq(12720), nri1$nri_sd, type ="l")





hy <- as.data.frame(hy)
head(hy)
hy_var <- lapply(seq(160), function(i){
  entrop(hy[,i])
})
hy_var <- do.call(c, hy_var)
plot(seq(160), hy_var, type = "l")


# information entropy
entrop <- function(x){
  p <- (table(x)/length(x))
  -sum(p*log(p))
}



