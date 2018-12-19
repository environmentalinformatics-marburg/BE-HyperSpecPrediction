# lidar indices
source("~/ma/BE-HyperSpecPrediction/src/00_set_environment.R")

# get lidar indices
lind <- read.table("~/ma/BE-HyperSpecPrediction/indices/lidar_indices.txt", sep = ";", header = TRUE)
lind <- as.character(lind$lidar_index)

pois$name <- as.character(pois$name)
plot_ext <- mapply(function(name, x, y) {return(extent_diameter(x=x, y=y, d=10))}, pois$name, pois$x, pois$y)

alb_lidar <- rs$pointdb("be_alb_lidar_06_classified")
lidar_indices <-alb_lidar$process(areas = plot_ext, functions = lind)

saveRDS(lidar_indices, "~/ma/data/finished_df/lidar_indices.RDS")


