# Set path ---------------------------------------------------------------------
source("D:/Ludwig/be/envimaR/R/getEnvi.R")
p <- getEnvi(root_folder = "D:/Ludwig/be/data/")
s <- getEnvi(root_folder = "D:/Ludwig/be/BE-HyperSpecPrediction/")



# Set libraries ----------------------------------------------------------------
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
library(sp)

# Other settings ---------------------------------------------------------------


# initialise database ---------------------------------------------------------

# connect to server
library(rPointDB)
rs <- RemoteSensing$new("http://137.248.191.215:8081",
                        readChar(paste0(p$util$here, "connect_db.txt"), file.info(paste0(p$util$here, "connect_db.txt"))$size))

