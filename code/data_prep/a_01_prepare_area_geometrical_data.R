#### aim: estimate geometrical parameters related to buildings by area of 250 m x 250 m (e.g., building density)

#### first step to load packages etc.
rm(list=ls())
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

### load data and create grid
# read NYC boroughs and create NYC boundaries. This and other data sources are described in the readme file
boroughs <- sf::st_read(paste0(demography.data.folder, "nybb.shp")) %>%
  sf::st_transform(2163)

nyc_boundaries <- sf::st_union(boroughs)

buildings <- sf::read_sf(paste0(buildings.data.folder, "geo_export_f7a89c9b-6561-41c9-b3a5-8114624ae6ba.shp")) %>% # these buildings are later used in the function estimate_geom_param
  sf::st_transform(4326) %>% # this is an intermediate step that I found it was needed to make it work :)
  sf::st_transform(2163) %>% # transform to EPSG:2163 Projected coordinate system for United States (USA)
  dplyr::mutate(height = heightroof * 0.3048) # height from feet to meters

## create grid of 250 m x 250 m (named spatial_context) within the New York city polygon
grid <- sf::st_make_grid(nyc_boundaries, cellsize = c(250, 250), offset = sf::st_bbox(nyc_boundaries)[1:2], crs = sf::st_crs(nyc_boundaries), what = "polygons")

grid_sf <- data.frame(id = 1:length(grid))
grid_sf$geom <- sf::st_sfc(grid)
grid_sf  <- sf::st_as_sf(grid_sf)

spatial_context <- nyc_boundaries %>%
  sf::st_intersection(grid_sf) %>%
  sf::st_as_sf() %>%
  dplyr::mutate(reg_id = 1:nrow(.)) 

saveRDS(spatial_context, paste0(generated.data.folder, "spatial_grid_250m_nyc.rds"))

### get urban geometrical parameters for each region (250 m x 250 m) within the spatial_context
## I have divided this process in chunks of about 1000 grid cell runs because my laptop was freezing when doing all together. 
## I comment only the initial run (1 to 1000) because the resting code is equal. 
# 1 - 1000
# choose a subset of grid cells for the computation
regs <- spatial_context[1:1000,]
# transform to arrays in order to use multiApply R package (Apply Functions to Multiple Multidimensional Arrays)
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
# run the estimate_geom_param function that can be found at code/functions/functions.R using 4 cores (using 4 cores makes the process faster)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
# adapt results to dataframe
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

# add results to spatial object
# create a spatial object with the centroids of each grid cell
centroids <- sf::st_centroid(regs)
# add estimated geometrical parameters 
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
# save
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_1_1000.rds"))

# delete objects with names that are re-used later in the script
rm(regs, geom_param, neigh_regions_geom, centroids)

# 1001 - 2000 (same as before but different grid cells)
regs <- spatial_context[1001:2000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_1001_2000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)


# 2001 - 3000
regs <- spatial_context[2001:3000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_2001_3000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)


# 3001 - 4000
regs <- spatial_context[3001:4000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_3001_4000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)

# 4001 - 5000
regs <- spatial_context[4001:5000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_4001_5000.rds"))


# 5001 - 6000
regs <- spatial_context[5001:6000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_5001_6000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)

# 6001 - 7000
regs <- spatial_context[6001:7000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_6001_7000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)



# 7001 - 8000
regs <- spatial_context[7001:8000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_7001_8000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)



# 8001 - 9000
regs <- spatial_context[8001:9000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_8001_9000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)



# 9001 - 10000
regs <- spatial_context[9001:10000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_9001_10000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)

# 10001 - 11000
regs <- spatial_context[10001:11000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_10001_11000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)

# 11001 - 12000
regs <- spatial_context[11001:12000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_11001_12000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)

# 12001 - 13000
regs <- spatial_context[12001:13000,]
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_12001_13000.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)

# 13001 - 13904
regs <- spatial_context[13001:nrow(spatial_context),] 
regs_df <- as.data.frame(regs)
regs_ap <- as.array(unlist(regs_df[,c("reg_id")]))
dim(regs_ap) <- c(reg_pos = nrow(regs), col = 1)
geom_param <- multiApply::Apply(list(regs_ap), target_dims  = 'col',
                                fun = estimate_geom_param, ncores = 4)$output1
geom_param <- t(geom_param)
colnames(geom_param) <- c("reg_id", "mean_height",  "area_density_plan",  "sd_height", "max_height")
geom_param <- as.data.frame(geom_param)

centroids <- sf::st_centroid(regs)
neigh_regions_geom <- dplyr::left_join(centroids, geom_param, by = "reg_id")
saveRDS(neigh_regions_geom, paste0(generated.data.folder, "neigh_regions_building_stats_13001_13904.rds"))


rm(regs, geom_param, neigh_regions_geom, centroids)

## put together geometrical parameters over NYC at 250 m x 250 m resolution 
neigh_regions_geom_1_1000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_1_1000.rds"))
neigh_regions_geom_1001_2000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_1001_2000.rds"))
neigh_regions_geom_2001_3000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_2001_3000.rds"))
neigh_regions_geom_3001_4000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_3001_4000.rds"))
neigh_regions_geom_4001_5000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_4001_5000.rds"))
neigh_regions_geom_5001_6000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_5001_6000.rds"))
neigh_regions_geom_6001_7000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_6001_7000.rds"))
neigh_regions_geom_7001_8000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_7001_8000.rds"))
neigh_regions_geom_8001_9000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_8001_9000.rds"))
neigh_regions_geom_9001_10000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_9001_10000.rds"))
neigh_regions_geom_10001_11000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_10001_11000.rds"))
neigh_regions_geom_11001_12000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_11001_12000.rds"))
neigh_regions_geom_12001_13000 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_12001_13000.rds"))
neigh_regions_geom_13001_13904 <- readRDS(paste0(generated.data.folder, "neigh_regions_building_stats_13001_13904.rds"))

neigh_regions_geom <- rbind(neigh_regions_geom_1_1000, neigh_regions_geom_1001_2000, neigh_regions_geom_2001_3000, 
                            neigh_regions_geom_3001_4000, neigh_regions_geom_4001_5000, neigh_regions_geom_5001_6000,
                            neigh_regions_geom_6001_7000, neigh_regions_geom_7001_8000, neigh_regions_geom_8001_9000, 
                            neigh_regions_geom_9001_10000, neigh_regions_geom_10001_11000, neigh_regions_geom_11001_12000, 
                            neigh_regions_geom_12001_13000, neigh_regions_geom_13001_13904)

saveRDS(neigh_regions_geom, paste0(generated.data.folder, "nyc_neigh_regions.rds"))