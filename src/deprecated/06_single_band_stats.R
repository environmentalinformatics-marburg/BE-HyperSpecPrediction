library(raster)
library(dplyr)
library(reshape2)

hy_fls <- list.files("~/ma/data/hyperspectral/10m_plots/", pattern = ".tif$", full.names = TRUE)
hy_names <- readRDS("~/ma/data/util/AEG_names.RDS")
hy_info <- readRDS("~/ma/data/util/hyperspectral_band_info.RDS")


# function for mean and sd off all bands as one line data frames
sbs <- function(aeg, aeg_name){
  single_band_stats <- lapply(seq(nlayers(aeg)), function(b){
    data.frame(wl = hy_info$wavelength[b],
               mean = cellStats(aeg[[b]], mean),
               sd = cellStats(aeg[[b]], sd))
  })
  single_band_stats <- do.call(rbind, single_band_stats)
  single_band_stats <- melt(single_band_stats, id=c("wl"))  
  sbs_names <- paste0(single_band_stats$variable, single_band_stats$wl)
  
  single_band_stats$wl <- NULL
  single_band_stats$variable <- NULL
  
  single_band_stats <- as.data.frame(t(single_band_stats))
  colnames(single_band_stats) <- as.character(sbs_names)  
  single_band_stats$EPID <- aeg_name
  return(single_band_stats)
}

all_bands <- lapply(seq(length(hy_fls)), function(f){
  print(f)
  st <- sbs(aeg = brick(hy_fls[f]), aeg_name = hy_names[f])
})
ab <- do.call(rbind, all_bands)

saveRDS(ab, "~/ma/data/finished_df/single_bands.RDS")
