# Set path ---------------------------------------------------------------------
if(Sys.info()["sysname"] == "Windows"){
  filepath_base <- "C:/Users/tnauss/permanent/plygrnd/exploratorien/"
} else {
  filepath_base <- "/media/permanent/active/exploratorien/"
}

path_data <- paste0(filepath_base, "data/")
path_forest <- paste0(path_data, "forest/")
path_lui <- paste0(path_data, "lui/")
path_plots <- paste0(path_data, "plots/")
path_releves <- paste0(path_data, "releves/")
path_re <- paste0(path_data, "rapideye/")
path_rdata <- paste0(path_data, "rdata/")
path_met_a <- paste0(path_data, "met_a/")
path_met_m <- paste0(path_data, "met_m/")
path_temp <- paste0(path_data, "temp/")
path_output <- paste0(path_data, "output/")


# Set libraries ----------------------------------------------------------------
library(biodivTools) # devtools::install_github("environmentalinformatics-marburg/biodivTools")
library(doParallel)
library(grid)
library(gridExtra)
library(gpm)
library(lavaan)
library(rgeos)
library(ggplot2)
library(mapview)
library(metTools)  # devtools::install_github("environmentalinformatics-marburg/metTools")
library(raster)
library(rgdal)
library(satellite)
library(satelliteTools)  # devtools::install_github("environmentalinformatics-marburg/satelliteTools")
library(semPlot)
library(sp)

# Other settings ---------------------------------------------------------------
rasterOptions(tmpdir = path_temp)

saga_cmd <- "C:/OSGeo4W64/apps/saga/saga_cmd.exe "
# initOTB("C:/OSGeo4W64/bin/")
initOTB("C:/OSGeo4W64/OTB-5.8.0-win64/OTB-5.8.0-win64/bin/")


