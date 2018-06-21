# vegetation indices for hyperspectral data
source("~/ma/BE-HyperSpecPrediction/src/00_set_environment.R")

# load band wavelengths
band_info <- readRDS("~/ma/data/rdata/hyperspectral_band_info.RDS")

# create list of vegetation indices
vi <- read.table("~/ma/BE-HyperSpecPrediction/indices/hsdar_indices.txt", header = TRUE, sep = ";")
vi <- as.character(vi$hsdar)

# list hyperspectral files
hy_fls <- list.files("~/ma/data/hyperspectral/", pattern = ".tif$", full.names = TRUE)
hy_names <- substr(list.files("~/ma/data/hyperspectral/", pattern = ".tif$", full.names = FALSE), 8, 12)

# calculate VI, its mean and SD
vi_stats <- lapply(seq(length(hy_fls)), function(i){
  
  hy <- speclib(brick(hy_fls[i]), band_info$wavelength)
  hy_indices <- vegindex(hy, index = vi)
  hy_indices <- hy_indices@spectra@spectra_ra
  names(hy_indices) <- vi
  writeRaster(hy_indices, paste0("~/ma/data/hyperspectral/10m_vegindex/", hy_names[i], "_vegindex.tif"))
  
  vi_means <- cellStats(hy_indices, stat = "mean")
  vi_sd <- cellStats(hy_indices, stat = "sd")
  
  return(data.frame(index = vi, mean = vi_means, sd = vi_sd))
  
})

