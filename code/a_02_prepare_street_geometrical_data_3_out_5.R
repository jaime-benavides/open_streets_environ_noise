# aim: estimate geometrical stats by street segment parameters following method from https://gmd.copernicus.org/articles/12/2811/2019/
# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))


buildings <- sf::read_sf(paste0(buildings.data.folder, "geo_export_f7a89c9b-6561-41c9-b3a5-8114624ae6ba.shp")) %>%
  sf::st_transform(4326) %>% # intermediate step needed to make it work :)
  sf::st_transform(2163) %>%
  dplyr::mutate(height = heightroof * 0.3048)

lion_streets_simp <- readRDS(paste0(generated.data.folder, "lion_streets_simp.rds"))

spatial_context <- readRDS(paste0(generated.data.folder, "spatial_grid_1km_nyc.rds"))

# get urban geometrical parameters for each region (250 m x 250 m) within the spatial_context

for(c in 401:600){
  print(paste0("working on spatial context ", c))
  sp_context <- spatial_context[c,] # 
  sp_context_ext <- sf::st_buffer(sp_context, dist = 200)
  # intersect NYC buildings to new sp_context
  buildings_context <- sf::st_intersection(buildings, sp_context_ext)
  sel = sf::st_intersects(x = buildings, y = sp_context_ext)
  sel_logical = lengths(sel) > 0
  buildings_context = buildings[sel_logical, ]
  sel_st = sf::st_intersects(x = lion_streets_simp, y = sp_context)
  sel_st_logical = lengths(sel_st) > 0
  streets_context = lion_streets_simp[sel_st_logical, ]
  ids <- streets_context$street_id
  for (i in seq_along(1:nrow(streets_context))) {
    print(paste0("working on road ", i))
    # get road spatial object as sp, the format compatible with the two_buf function
    if(as.numeric(sf::st_length(streets_context[i,])) > 0) {
      road <- methods::as(streets_context[i,], "Spatial")
      # get the buffers at both sides of the road segment
      buffers <- two_buf(line = road, width = 100, minEx = 0.0001)
      if(length(buffers) == 2){
        buffer_1 <- buffers[1,]
        # get building at one side of the street segment within the buffer 1
        buildings_1 <- buildings_context[sf::st_as_sf(buffer_1),]
        if(nrow(buildings_1) > 0){
          # get minimum distance road to buildings within buffer 1
          dist_1 <- rgeos::gDistance(methods::as(buildings_1, "Spatial"), road)
        } else{
          dist_1 <- 0
        }
        buffer_2 <- buffers[2,]
        # get building at the other side of the street segment within the buffer 2
        buildings_2 <- buildings_context[sf::st_as_sf(buffer_2),]
        if(nrow(buildings_2) > 0){
          # get minimum distance road to buildings within buffer 1
          dist_2 <- rgeos::gDistance(methods::as(buildings_2, "Spatial"), road)
        } else{
          dist_2 <- 0
        }
        # calculate street width and street mean building height only if there are buildings at both sides of the street segment
        if (dist_1 != 0 && dist_2 != 0) {
          lion_streets_simp[ids[i], "street_width"] <- dist_1 + dist_2
          lion_streets_simp[ids[i], "building_height"] <- mean(c(buildings_1$height,buildings_2$height), na.rm = TRUE)
        } else {
          lion_streets_simp[ids[i], "street_width"] <- 0
          lion_streets_simp[ids[i], "building_height"] <- 0
          lion_streets_simp[ids[i], "b_height_to_s_width"] <- 0
        }
        
        # estimate aspect ratio (building height / street width) only if there is a street width
        if (as.numeric(lion_streets_simp[ids[i], "street_width"])[1] > 0) {
          lion_streets_simp[ids[i], "b_height_to_s_width"] <- as.numeric(lion_streets_simp[ids[i], "building_height"])[1] / as.numeric(lion_streets_simp[ids[i], "street_width"])[1]
        } else {
          lion_streets_simp[ids[i], "b_height_to_s_width"] <- 0
        }
      } 
    } 
  }
}
saveRDS(lion_streets_simp, paste0(generated.data.folder, "streets_nyc_geom_401_to_600.rds"))