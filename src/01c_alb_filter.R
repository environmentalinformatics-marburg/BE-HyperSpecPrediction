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
# get plot locations from RS db
library(rPointDB)

rs <- RemoteSensing$new("http://137.248.191.215:8081", "marvin.ludwig:XXX") # remote server
rois <- rs$roi_group("be_alb_roi")
pois <- rs$poi_group("be_alb_poi")

saveRDS(rois, "~/ma/data/plots/alb_rois.RDS")
saveRDS(pois, "~/ma/data/plots/alb_pois.RDS")

# # # convert grassland plots to shapefiles # # # # # 
# ------------------------------------------------- #
rois <- readRDS("~/ma/data/plots/alb_rois.RDS")

rois_grass <- rois[substr(rois$name, 1, 3) == "AEG",]
rois_points <- data.frame(EPID = rois_grass$name,
                          x = unlist(lapply(rois_grass$center, "[[", 1)),
                          y = unlist(lapply(rois_grass$center, "[[", 2)))

coordinates(rois_points) <- ~ x + y
projection(rois_points) <- crs("+init=epsg:32632")
mapview(rois_points)

writeOGR(rois_points, dsn = "/home/marvin/ma/data/plots/plot_points.shp",
         driver = "ESRI Shapefile", layer = "plot_points")
r_poly_coords <- rois_grass$polygon

r_polygons <- lapply(seq(length(r_poly_coords)), function(p){
  r_polygon <- Polygon(r_poly_coords[[p]])
  r_polygons <- Polygons(list(r_polygon), p)
  r_sp_polygons <- SpatialPolygons(list(r_polygons), proj4string = crs("+init=epsg:32632"))
  return(r_sp_polygons)
})
rownames(rois_grass) <- seq(50)
r_spdf <- SpatialPolygonsDataFrame(do.call(rbind, r_polygons), data = rois_grass)
mapview(r_spdf)
r_spdf@data$center <- NULL
r_spdf@data$polygon <- NULL

writeOGR(r_spdf, "/home/marvin/ma/data/plots/plot_polygons.shp", driver = "ESRI Shapefile", layer = "plot_polygons")


