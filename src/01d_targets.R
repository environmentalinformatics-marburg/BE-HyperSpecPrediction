# Target gathering:
library(plyr)

traits15 <- readRDS("~/ma/data/alb/alb_traits_15.RDS")
div <- readRDS("~/ma/data/alb/alb_diversity.RDS")


div <- div[div$Year == 2015, ]

traits15$Region <- NULL
traits15$Year <- NULL

div$PlotID <- NULL
div$Year <- NULL
div$total.cover.cum <- NULL

# create one database with all the target variables
targets <- join(div, traits15, by = "EPID")
targets$speciesrichness <- NULL
targets$doy_biomass <- NULL
targets$EPID <- as.character(targets$EPID)

# list of my plots:
plots <- as.character(readRDS("~/ma/data/finished_df/lidar_indices.RDS")$name)
targets <- targets[targets$EPID %in% plots,]

saveRDS(targets, "~/ma/data/finished_df/targets.RDS")







