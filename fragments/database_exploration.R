library(rPointDB)

# connect to server
rs <- RemoteSensing$new("XXX") # remote server

# access lidar data; same data in lidar and pointdb?
alb_pointdb <- rs$pointdb("be_alb_lidar_06_classified")
alb_lidar <- rs$lidar("be_alb_lidar_06_classified")

# access alb grassland plots 
rois <- rs$roi_group("be_alb_roi")
rois <- rois[substr(rois$name, 1, 3) == "AEG",]

# get the area of the plots
rois_extent <- lapply(rois$polygon, extent)

# get the lidar data from one plot as a data.frame
roi1_pointdb <- alb_pointdb$query(rois_extent[[1]])

# get mean vegetation height from lidar data
chm <- alb_pointdb$process(areas = rois_extent, functions = "chm_height_mean")

# get hyperspectral data
alb_hy <- rs$rasterdb("be_alb_hyperspectral")
roi1_hy <- alb_hy$raster(rois_extent[[1]])

writeRaster(roi1_hy, "~/ma/data/hyperspectral/aeg01.tif")

