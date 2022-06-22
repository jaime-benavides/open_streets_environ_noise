# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

streets_nyc_geom_1_to_200 <- readRDS(paste0(generated.data.folder, "streets_nyc_geom_1_to_200.rds"))
streets_nyc_geom_1_to_200_df <- streets_nyc_geom_1_to_200
sf::st_geometry(streets_nyc_geom_1_to_200_df) <- NULL
ind_1 <- which(!is.na(streets_nyc_geom_1_to_200_df$street_width))

streets_nyc_geom_201_to_400 <- readRDS(paste0(generated.data.folder, "streets_nyc_geom_201_to_400.rds"))
streets_nyc_geom_201_to_400_df <- streets_nyc_geom_201_to_400
sf::st_geometry(streets_nyc_geom_201_to_400_df) <- NULL
ind_2 <- which(!is.na(streets_nyc_geom_201_to_400_df$street_width))

streets_nyc_geom_401_to_600 <- readRDS(paste0(generated.data.folder, "streets_nyc_geom_401_to_600.rds"))
streets_nyc_geom_401_to_600_df <- streets_nyc_geom_401_to_600
sf::st_geometry(streets_nyc_geom_401_to_600_df) <- NULL
ind_3 <- which(!is.na(streets_nyc_geom_401_to_600_df$street_width))

streets_nyc_geom_601_to_800 <- readRDS(paste0(generated.data.folder, "streets_nyc_geom_601_to_800.rds"))
streets_nyc_geom_601_to_800_df <- streets_nyc_geom_601_to_800
sf::st_geometry(streets_nyc_geom_601_to_800_df) <- NULL
which(streets_nyc_geom_601_to_800_df$street_width > 200)
ind_4 <- which(!is.na(streets_nyc_geom_601_to_800_df$street_width))

streets_nyc_geom_801_to_1018 <- readRDS(paste0(generated.data.folder, "streets_nyc_geom_801_to_1018.rds"))
streets_nyc_geom_801_to_1018_df <- streets_nyc_geom_801_to_1018
sf::st_geometry(streets_nyc_geom_801_to_1018_df) <- NULL
ind_5 <- which(!is.na(streets_nyc_geom_801_to_1018_df$street_width))

streets_nyc_geom_street <- streets_nyc_geom_1_to_200_df
streets_nyc_geom_street[ind_2,c("street_width", "building_height", "b_height_to_s_width")] <- streets_nyc_geom_201_to_400_df[ind_2,c("street_width", "building_height", "b_height_to_s_width")]
streets_nyc_geom_street[ind_3,c("street_width", "building_height", "b_height_to_s_width")] <- streets_nyc_geom_401_to_600_df[ind_3,c("street_width", "building_height", "b_height_to_s_width")]
streets_nyc_geom_street[ind_4,c("street_width", "building_height", "b_height_to_s_width")] <- streets_nyc_geom_601_to_800_df[ind_4,c("street_width", "building_height", "b_height_to_s_width")]
streets_nyc_geom_street[ind_5,c("street_width", "building_height", "b_height_to_s_width")] <- streets_nyc_geom_801_to_1018_df[ind_5,c("street_width", "building_height", "b_height_to_s_width")]

streets_nyc_geom_street[which(streets_nyc_geom_street$b_height_to_s_width > 20),c("street_width", "building_height", "b_height_to_s_width")] <- NA


saveRDS(streets_nyc_geom_street, paste0(generated.data.folder, "streets_nyc_geom_street.rds"))
