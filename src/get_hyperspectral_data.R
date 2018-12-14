source("D:/Ludwig/be/BE-HyperSpecPrediction/src/set_environment.R", echo = FALSE)

# download 50x50m hyperspectral data for the available plots in every BE
# after this script, define the centers for the corrected plot locations in QGIS
# (without the climate station in the 10x10m plot)

# # # Hainich--------------------
#--------------------------------

db_hy <- rs$rasterdb("be_hai_hyperspectral")

rois <- rs$roi_group("be_hai_roi")
rois <- rois[substr(rois$name, 1, 3) == "HEG",]

# fix order
rois <- rois[order(rois$name),]


# get list of the extents of all plots
re <- lapply(rois$polygon, extent)

# get the 50 m plot data
for(i in seq(length(re))){
  hy <- db_hy$raster(re[[i]])
  if(!is.na(hy[[1]][1,1])){
    writeRaster(hy, paste0(p$hyperspectral$hainich_50$here, "hy_", names(re)[i], ".tif" )) 
  }
}


# # # Schorfheide --------------------
#-------------------------------------

db_hy <- rs$rasterdb("be_sch_hyperspectral")

rois <- rs$roi_group("be_sch_roi")
rois <- rois[substr(rois$name, 1, 3) == "SEG",]

# fix order
rois <- rois[order(rois$name),]


# get list of the extents of all plots
re <- lapply(rois$polygon, extent)

# get the 50 m plot data
for(i in seq(length(re))){
  hy <- db_hy$raster(re[[i]])
  if(!is.na(hy[[1]][1,1])){
    writeRaster(hy, paste0(p$hyperspectral$heide_50$here, "hy_", names(re)[i], ".tif" )) 
  }
}


# # # Alb --------------------
#-------------------------------------

db_hy <- rs$rasterdb("be_alb_hyperspectral")

rois <- rs$roi_group("be_alb_roi")
rois <- rois[substr(rois$name, 1, 3) == "AEG",]

# fix order
rois <- rois[order(rois$name),]


# get list of the extents of all plots
re <- lapply(rois$polygon, extent)

# get the 50 m plot data
for(i in seq(length(re))){
  hy <- db_hy$raster(re[[i]])
  if(!is.na(hy[[1]][1,1])){
    writeRaster(hy, paste0(p$hyperspectral$alb_50$here, "hy_", names(re)[i], ".tif" )) 
  }
}



