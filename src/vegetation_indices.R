# vegetation indices for hyperspectral data
source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")

# load band wavelengths
band_info <- readRDS(paste0(p$util$here, "hyperspectral_band_info.RDS"))

# create list of vegetation indices
vi <- read.table(paste0(s$indices, "hsdar_indices.txt"), header = TRUE, sep = ";", stringsAsFactors = FALSE)
vi <- as.vector(vi$hsdar)

# list hyperspectral files
hy_fls <- list.files(p$hyperspectral$hy_10m$here, pattern = ".tif$", full.names = TRUE)
hy_names <- substr(list.files(p$hyperspectral$hy_10m$here, pattern = ".tif$", full.names = FALSE), 8, 12)



# calculate VI, its mean and SD

vi_stats <- lapply(seq(length(hy_fls)), function(i){
  
  hy <- speclib(brick(hy_fls[i]), band_info$wavelength)
  hy_indices <- vegindex(hy, index = vi)
  hy_indices <- hy_indices@spectra@spectra_ra
  names(hy_indices) <- vi
  #writeRaster(hy_indices, paste0(p$hyperspectral$vegetation_indices_10m$here, hy_names[i], "_vegindex.tif"),
   #           overwrite = TRUE)
  
  vi_means <- cellStats(hy_indices, stat = "mean")
  vi_sd <- cellStats(hy_indices, stat = "sd")
  
  return(data.frame(EPID = hy_names[i], index = vi, mean = vi_means, sd = vi_sd))
  
})

# format results a bit
vi_table <- do.call(rbind, vi_stats)
vi_table <- na.omit(vi_table)


saveRDS(vi_table, paste0(p$aerial_summary$here, "be_hy_vegetation_indices.RDS"))
