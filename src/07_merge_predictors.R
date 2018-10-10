# summary data:
library(dplyr)
library(plyr)
data_list <- lapply(list.files("~/ma/data/finished_df/", full.names = TRUE), readRDS)
names(data_list) <- list.files("~/ma/data/finished_df/", full.names = FALSE)

data_list$lidar_indices.RDS$name <- NULL
data_list$narrow_bands.RDS$EPID <- NULL
data_list$single_bands.RDS$EPID <- NULL
data_list$vegindices.RDS$EPID <- NULL
data_list$AEG <- as.character(readRDS("~/ma/data/util/AEG_names.RDS"))