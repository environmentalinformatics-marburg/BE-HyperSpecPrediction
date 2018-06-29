nri_fls <- list.files("~/ma/data/hyperspectral/narrow_band_indices/", full.names = TRUE)

# get one file for colnames
nri_testfile <- readRDS(nri_fls[1])
nri_mean_names <- paste0("mean_wl_", round(nri_testfile$wl1), "_", round(nri_testfile$wl2))
nri_sd_names <- paste0("sd_wl_", round(nri_testfile$wl1), "_", round(nri_testfile$wl2))
nri_colnames <- c(nri_mean_names, nri_sd_names)

# loop over the 26 files
nri <- lapply(seq(26), function(i){
  cur <- readRDS(nri_fls[i])
  cur_row <- as.data.frame(t(c(cur$nri_mean, cur$nri_sd)))
})
nri <- do.call(rbind, nri)
colnames(nri) <- nri_colnames

nri$EPID <- readRDS("~/ma/data/util/AEG_names.RDS")

saveRDS(nri, "~/ma/data/finished_df/narrow_bands.RDS")


