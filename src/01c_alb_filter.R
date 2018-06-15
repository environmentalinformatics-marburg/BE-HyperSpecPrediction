source("~/ma/BE-HyperSpecPrediction/src/00_set_environment.R")

# create data for alb
veg_species <- readRDS("~/ma/data/rdata/veg_species.RDS")
species_alb <- veg_species[substr(veg_species$EPID, 1,1) == "A",]
saveRDS(species_alb, "~/ma/data/alb/alb_species.RDS")


veg_cover <- readRDS("~/ma/data/rdata/veg_cover.RDS")
cover_alb <- veg_cover[substr(veg_cover$EPID, 1,1) == "A",]
saveRDS(cover_alb, "~/ma/data/alb/alb_diversity.RDS")

traits_14 <- readRDS("~/ma/data/rdata/traits_14.RDS")
alb_traits_14 <- traits_14[traits_14$Region == "AEG",]
saveRDS(alb_traits_14, "~/ma/data/alb/alb_traits_14.RDS")

traits_15 <- readRDS("~/ma/data/rdata/traits_15.RDS")
alb_traits_15 <- traits_15[traits_15$Region == "AEG",]
saveRDS(alb_traits_15, "~/ma/data/alb/alb_traits_15.RDS")

lui <- readRDS("~/ma/data/rdata/lui.RDS")
alb_lui <- lui[substr(lui$EPID, 1,1)=="A",]
saveRDS(alb_lui, "~/ma/data/alb/alb_lui.RDS")


# # # # # # # # # # # 
# get plot locations
library(rPointDB)

rs <- RemoteSensing$new("http://137.248.191.215:8081", "marvin.ludwig:XXX") # remote server
rois <- rs$roi_group("be_alb_roi")
pois <- rs$poi_group("be_alb_poi")

saveRDS(rois, "~/ma/data/plots/alb_rois.RDS")
saveRDS(pois, "~/ma/data/plots/alb_pois.RDS")






