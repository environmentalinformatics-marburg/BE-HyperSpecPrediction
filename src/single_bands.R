# single band stats and vegetation index stats

source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")

# load all hyperspectral plots
hy10 <- list.files(p$hyperspectral$hy_10m$here, pattern = ".tif$", full.names = TRUE)
hy_names <- substr(list.files(p$hyperspectral$hy_10m$here, pattern = ".tif$", full.names = FALSE), 8, 12)
hy_info <- readRDS(paste0(p$util$here, "hyperspectral_band_info.RDS"))


single_band_stats <- lapply(seq(length(hy10)), function(i){
  data.frame(EPID = hy_names[i],
             wl = hy_info$wavelength,
             mean = cellStats(brick(hy10[i]), mean),
             sd = cellStats(brick(hy10[i]), sd))
  
})

single_band_stats <- do.call(rbind, single_band_stats)

saveRDS(single_band_stats, paste0(p$aerial_summary$here, "be_hy_single_bands.RDS"))













