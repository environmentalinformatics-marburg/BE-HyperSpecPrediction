# crop the 50m plots to 10m plots based on the corrected plot locations
source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")

# Schorfheide
#----------------------

# estanblish database connection
db_hy <- rs$rasterdb("be_sch_hyperspectral")

# load corrected plot locations 
plots <- readOGR(paste0(p$plots$here, "sch_10m_center.shp"))

pois <- data.frame(name = as.character(plots@data$EPID), x = plots@coords[,1], y = plots@coords[,2],
                   stringsAsFactors = FALSE)


for(j in seq(nrow(pois))){
  hy <- db_hy$raster(extent_diameter(pois$x[j], pois$y[j], 10))
  writeRaster(hy, paste0(p$hyperspectral$heide_10$here, "hy_10m_", pois$name[j], ".tif" ))
}



# Hainich
#-------------------------
# estanblish database connection
db_hy <- rs$rasterdb("be_hai_hyperspectral")

# load corrected plot locations 
plots <- readOGR(paste0(p$plots$here, "hai_10m_center.shp"))

pois <- data.frame(name = as.character(plots@data$EPID), x = plots@coords[,1], y = plots@coords[,2],
                   stringsAsFactors = FALSE)


for(j in seq(nrow(pois))){
  hy <- db_hy$raster(extent_diameter(pois$x[j], pois$y[j], 10))
  writeRaster(hy, paste0(p$hyperspectral$hainich_10$here, "hy_10m_", pois$name[j], ".tif" ))
}


# Alb
#-------------------------
# estanblish database connection
db_hy <- rs$rasterdb("be_alb_hyperspectral")

# load corrected plot locations 
plots <- readOGR(paste0(p$plots$here, "alb_10m_center.shp"))

pois <- data.frame(name = as.character(plots@data$EPID), x = plots@coords[,1], y = plots@coords[,2],
                   stringsAsFactors = FALSE)


for(j in seq(nrow(pois))){
  hy <- db_hy$raster(extent_diameter(pois$x[j], pois$y[j], 10))
  writeRaster(hy, paste0(p$hyperspectral$alb_10$here, "hy_10m_", pois$name[j], ".tif" ))
}
