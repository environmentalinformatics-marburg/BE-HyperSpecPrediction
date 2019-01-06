# calculate NRIs for Hainich and Schorfheide in the red edge (650nm - 800nm)
library(hsdar)

source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")

band_info <- readRDS(paste0(p$util$here, "hyperspectral_band_info.RDS"))

# list hyperspectral files
hy_fls <- list.files(p$hyperspectral$hy_10m$here, pattern = ".tif$", full.names = TRUE)
hy_names <- substr(list.files(p$hyperspectral$hy_10m$here, pattern = ".tif$", full.names = FALSE), 8, 12)


# define function for mean and sd of narrow band indices for one plot
nri_stats <- function(Nri){
  wl1 <- lapply(seq(length(Nri@wavelength)), function(i){
    wl2 <- lapply(seq(length(Nri@wavelength)), function(j){
      data.frame(wl1 = Nri@wavelength[i],
                 wl2 = Nri@wavelength[j],
                 nri_mean = mean(Nri@nri[i,j,]),
                 nri_sd = sd(Nri@nri[i,j,]))
    })
    do.call(rbind, wl2)
  })
  wl1 <- do.call(rbind,wl1)
  wl1 <- na.omit(wl1)
  return(wl1)
}



# calculate NRI in the red edge, its mean and SD

nri_stats <- lapply(seq(length(hy_fls)), function(i){
  
  hy <- speclib(brick(hy_fls[i]), wavelength = band_info$wavelength)
  # reduce to 650 - 800
  hy <- hy[,which(band_info$wavelength >= 650 & band_info$wavelength <=800)]
  hy_nri <- nri(hy, recursive = TRUE)
  
  
  nri_s <- nri_stats(hy_nri)
  nri_s$EPID <- hy_names[i]
  return(nri_s)
  
})

nri_stats <- do.call(rbind, nri_stats)
saveRDS(nri_stats, paste0(p$aerial_summary$here, "be_hy_nri.RDS"))


