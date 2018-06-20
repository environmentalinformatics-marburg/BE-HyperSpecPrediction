source("~/ma/BE-HyperSpecPrediction/src/00_set_environment.R")

# get hyperspectral data for all plots

alb_hy <- rs$rasterdb("be_alb_hyperspectral")
alb_hy_names <- names(re)

# reduce plots to hyperspectral extend
alb_hy$extent

# get the 50 m plot data
for(i in seq(length(re))){
  hy <- alb_hy$raster(re[[i]])
    if(!is.na(hy[[1]][1,1])){
        writeRaster(hy, paste0(path$hyperspectral, "hy_", alb_hy_names[i], ".tif" ))  
    }
}
# HERE HAPPENS SOME QGIS MAGIC #
# Visual observation of plots
# Avoid climate station, trees, roads etc.

# load corrected plot locations 
plots <- readOGR("~/ma/data/plots/plots_corrected.shp")
mapview(plots)

pois <- data.frame(name = plots@data$EPID, x = plots@coords[,1], y = plots@coords[,2])

for(j in seq(nrow(pois))){
  hy <- alb_hy$raster(extent_diameter(pois$x[j], pois$y[j], 10))
  writeRaster(hy, paste0(path$hyperspectral, "hy_10m_", alb_hy_names[j], ".tif" ))
}


