# summary data:
library(dplyr)
library(plyr)
data_list <- lapply(list.files("~/ma/data/finished_df/", full.names = TRUE), readRDS)
names(data_list) <- list.files("~/ma/data/finished_df/", full.names = FALSE)

colnames(data_list$lidar_indices.RDS)[1] <- "EPID"

# predictors in one data frame
predictors <- data.frame(EPID = readRDS("~/ma/data/util/AEG_names.RDS"), stringsAsFactors = FALSE)

predictors <- join(predictors, data_list$vegindices.RDS, by = "EPID")
predictors <- join(predictors, data_list$single_bands.RDS, by = "EPID")
predictors <- join(predictors, data_list$narrow_bands.RDS, by = "EPID")
predictors <- join(predictors, data_list$lidar_indices.RDS, by = "EPID")

# targets in another
targets <- data_list$targets.RDS

