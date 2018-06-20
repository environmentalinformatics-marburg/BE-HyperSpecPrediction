# Set path ---------------------------------------------------------------------
if(Sys.info()["sysname"] == "Windows"){
  path_data <- "C:/Users/tnauss/permanent/plygrnd/exploratorien/"
} else {
  path_data <- "/home/marvin/ma/data/"
}

path <- list(data = path_data,
             forest = paste0(path_data, "forest/"),
             releves = paste0(path_data, "releves/"),
             lui = paste0(path_data, "lui/"),
             plots = paste0(path_data, "plots/"),
             rdata = paste0(path_data, "rdata/"),
             temp = paste0(path_data, "temp/"),
             hyperspectral = paste0(path_data, "hyperspectral/"),
             lidar = paste0(path_data, "lidar/"))
rm(path_data)

# Set libraries ----------------------------------------------------------------
library(biodivTools) # devtools::install_github("environmentalinformatics-marburg/biodivTools")
library(doParallel)
library(grid)
library(gridExtra)
library(rgeos)
library(ggplot2)
library(mapview)
library(metTools)  # devtools::install_github("environmentalinformatics-marburg/metTools")
library(raster)
library(rgdal)
library(satellite)
library(satelliteTools)  # devtools::install_github("environmentalinformatics-marburg/satelliteTools")
library(sp)

# Other settings ---------------------------------------------------------------
rasterOptions(tmpdir = path$temp)


# initialise database ---------------------------------------------------------

# connect to server
library(rPointDB)
rs <- RemoteSensing$new("http://137.248.191.215:8081",
                        readChar("~/ma/connect_db.txt", file.info("~/ma/connect_db.txt")$size))

# access alb grassland plots --------------------------------------------------
rois <- rs$roi_group("be_alb_roi")
rois <- rois[substr(rois$name, 1, 3) == "AEG",]
# get list of the extents of all plots
re <- lapply(rois$polygon, extent)





