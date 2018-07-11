function(rois, type = c("point", "polygon"), projection = crs("+init=epsg:32632")){
  
  if("point" %in% type){
    rois_points <- data.frame(EPID = rois_grass$name,
                              x = unlist(lapply(rois_grass$center, "[[", 1)),
                              y = unlist(lapply(rois_grass$center, "[[", 2)))
    
    coordinates(rois_points) <- ~ x + y
    projection(rois_points) <- projection
  }
  if("polygon" %in% type){
    poly_df <- rois$polygon
    
    poly_sp <- lapply(seq(length(poly_df)), function(p){
      r_polygon <- Polygon(poly_df[[p]])
      r_polygons <- Polygons(list(r_polygon), p)
      r_sp_polygons <- SpatialPolygons(list(r_polygons), proj4string = crs("+init=epsg:32632"))
      return(r_sp_polygons)
    })
    rownames(rois_grass) <- seq(length())
    r_spdf <- SpatialPolygonsDataFrame(do.call(rbind, r_polygons), data = rois_grass)
    
    
  }
  
  
}