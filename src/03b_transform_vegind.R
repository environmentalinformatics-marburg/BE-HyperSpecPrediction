library(plyr)
library(dplyr)

vi_stats <- readRDS("~/ma/data/hyperspectral/10m_vegindex/vegind_stats_plotlist.RDS")

epid <- readRDS("~/ma/data/util/AEG_names.RDS")

vi_colnames <- c(paste0(v$index, "_mean"), paste0(v$index, "_sd"))

vi_df <- lapply(vi_stats, function(v){
  c(v$mean, v$sd)
})
vi_df <- as.data.frame(do.call(rbind, vi_df))
colnames(vi_df) <- vi_colnames

# find out which indices are out of range of the wavelengths:

na_cols <- colnames(vi_df)[is.na(vi_df[1,])]
vi_df[,which(colnames(vi_df) %in% na_cols)] <- NULL

vi_df$EPID <- epid

saveRDS(vi_df, "~/ma/data/finished_df/vegindices.RDS")

