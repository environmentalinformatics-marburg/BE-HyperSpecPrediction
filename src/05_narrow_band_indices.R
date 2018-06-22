# 04 narrow band indices
# takes a long time, so I did this on a lab pc

library(signal, lib.loc = "F:/be_hyperspectral/library")
library(hsdar, lib.loc = "F:/be_hyperspectral/library")

# get hyperspectral plot data
hy_fls <- list.files("F:/be_hyperspectral/hy_10m/", pattern = ".tif$", full.names = TRUE)
hy_names <- substr(hy_fls, 35, 39)

band_info <- readRDS("F:/be_hyperspectral/hy_10m/hyperspectral_band_info.RDS")

# define function for mean and sd of narrow band indices for one plot
nri_stats <- function(Nri){
  wl1 <- lapply(seq(length(Nri@wavelength)), function(i){
    print(i)
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

# calculate for all plots
for(k in seq(length(hy_fls))){
  aeg <- speclib(brick(hy_fls[k]), band_info$wavelength)
  aeg_nri <- nri(aeg, recursive = TRUE)
  
  print(hy_names[k])
  nri_df <- nri_stats(aeg_nri)
  saveRDS(nri_df, paste0("F:/be_hyperspectral/nri/", hy_names[k], "_nri.RDS"))
}
