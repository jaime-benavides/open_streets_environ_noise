# aim: estimate geometrical stats by street segment parameters 
# this script is documented (the other scripts that run the same code for different street segments 2_out_5...to 5_out_5 are not documented because code is same)

# First step to load packages etc.
rm(list=ls())
# declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

# read NYC boroughs and create NYC boundaries
boroughs <- sf::st_read(paste0(demography.data.folder, "nybb.shp")) %>%
  sf::st_transform(2163)

nyc_boundaries <- sf::st_union(boroughs)

# read/transform buildings
buildings <- sf::read_sf(paste0(buildings.data.folder, "geo_export_f7a89c9b-6561-41c9-b3a5-8114624ae6ba.shp")) %>%
  sf::st_transform(4326) %>% 
  sf::st_transform(2163) %>%
  dplyr::mutate(height = heightroof * 0.3048)

# read/transform lion streets ###--- vdo_comment: what exactly are lion streets? if theyre a specific part of NYC, would describe that ---###
lion_streets <- sf::st_read(paste0(streets.data.folder, "streets/nyclion_21a/lion/lion.gdb"), layer = "lion")%>%
  sf::st_transform(2163)
# this is a previous step needed before simplifying (i.e. transform curves to straight segments)
lion_streets <- sf::st_cast(lion_streets, "MULTILINESTRING") 
# Returns a "simplified" version of the given geometry using the Douglas-Peucker algorithm
lion_streets_simp = sf::st_simplify(lion_streets, dTolerance = 100)
# assign ids
lion_streets_simp$street_id <- 1:nrow(lion_streets_simp)
# save this processed dataset for re-use
lion_streets_simp <- saveRDS(lion_streets_simp, paste0(generated.data.folder, "lion_streets_simp.rds"))

# create grid of 1km m x 1km (named spatial_context) within the New York city polygon
grid <- sf::st_make_grid(nyc_boundaries, cellsize = c(1000, 1000), offset = sf::st_bbox(nyc_boundaries)[1:2], crs = sf::st_crs(nyc_boundaries), what = "polygons")

grid_sf <- data.frame(id = 1:length(grid))
grid_sf$geom <- sf::st_sfc(grid)
grid_sf  <- sf::st_as_sf(grid_sf)

spatial_context <- nyc_boundaries %>%
  sf::st_intersection(grid_sf) %>%
  sf::st_as_sf() %>%
  dplyr::mutate(reg_id = 1:nrow(.))

saveRDS(spatial_context, paste0(generated.data.folder, "spatial_grid_1km_nyc.rds"))


# read spatial grid of 1 km x 1 km that it is used to divide the process of running the geometrical parameters calculation in the entire city
spatial_context <- readRDS(paste0(generated.data.folder, "spatial_grid_1km_nyc.rds"))

# get urban geometrical parameters for each street segment within the spatial_context

for(c in 1:200){
  print(paste0("working on spatial context ", c))
  # obtain the spatial context (grid cell of 1 km x 1 km to work at)
  sp_context <- spatial_context[c,] # 
  # extend the boundaries of the spatial context to allow buildings close to the boundaries of the spatial context to be included in the calculation
  sp_context_ext <- sf::st_buffer(sp_context, dist = 200)
  # intersect NYC buildings to extended sp_context
  sel = sf::st_intersects(x = buildings, y = sp_context_ext)
  sel_logical = lengths(sel) > 0
  buildings_context = buildings[sel_logical, ]
  # intersect street segments with spatial context (non extended)
  sel_st = sf::st_intersects(x = lion_streets_simp, y = sp_context)
  sel_st_logical = lengths(sel_st) > 0
  streets_context = lion_streets_simp[sel_st_logical, ]
  ids <- streets_context$street_id
  for (i in seq_along(1:nrow(streets_context))) { # for each street segment in the spatial context
    print(paste0("working on road ", i))
    if(as.numeric(sf::st_length(streets_context[i,])) > 0) { # if street segment is longer than 0 m
      # get road spatial object as sp, the format compatible with the two_buf function
      road <- methods::as(streets_context[i,], "Spatial") 
      # get the buffers at both sides of the road segment / two_buf function can be found at code/functions/functions.R
      buffers <- two_buf(line = road, width = 100, minEx = 0.0001)
      if(length(buffers) == 2){ # check if buffers are available
        # work on one side of the street segment
        buffer_1 <- buffers[1,]
        # get buildings at one side of the street segment within the buffer 1
        buildings_1 <- buildings_context[sf::st_as_sf(buffer_1),]
        if(nrow(buildings_1) > 0){ # if there are some buildings
          # get minimum distance street segment to buildings within buffer 1
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
        # calculate street width and street mean building height only if there are buildings at both sides of the street segment ###--- vdo comment: what if there are are places without buildings on both sides? ---###
        if (dist_1 != 0 && dist_2 != 0) {
          lion_streets_simp[ids[i], "street_width"] <- dist_1 + dist_2 # street width is estimated as the sum of distance to buildings on each side of the street segment
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
# save data
saveRDS(lion_streets_simp, paste0(generated.data.folder, "streets_nyc_geom_1_to_200.rds"))
