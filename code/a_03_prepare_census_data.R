

# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))


neigh_regions_geom <- readRDS(paste0(generated.data.folder, "nyc_neigh_regions.rds"))
neigh_regions_geom_df <- neigh_regions_geom
sf::st_geometry(neigh_regions_geom_df) <- NULL
spatial_grid <- readRDS(paste0(generated.data.folder, "spatial_grid_250m_nyc.rds"))

neigh_regions_grid <- dplyr::left_join(spatial_grid, neigh_regions_geom_df, by = "reg_id")

# Getting data from the 2015-2019 5-year ACS
# a census api key is required to use get_acs
# B01003_001 total population
# B02001_003 black alone
# B03003_003 hispanic or latino
# B17001_002 income in the past 12 mo below poverty level
acs.dt <- tidycensus::get_acs(geography = "tract", state = "NY", variables = c("B01003_001", "B02001_003", "B03003_003", "B17001_002"), 
                  geometry = TRUE, year = 2019)

acs.wide <- spread(acs.dt[,1:4], variable, estimate)  
names(acs.wide)[3:6] <- c("popn", "black", "hisp", "pov") 

acs.wide$perc.black <- acs.wide$black/acs.wide$popn    
acs.wide$perc.hisp  <- acs.wide$hisp/acs.wide$popn    
acs.wide$perc.pov   <- acs.wide$pov/acs.wide$popn    

# Using FIPS code '36' for state 'NY'
#bronx 005; kings 047; manhattan 061; queens 081; stat isl 085; 
acs.nyc <- acs.wide[which(substr(acs.wide$GEOID, 1, 5) %in% c("36005", "36047", "36061", "36081", "36085")),]

acs.nyc$boro_code <- ifelse(substr(acs.nyc$GEOID, 3, 5) == "005", 2, NA)
acs.nyc$boro_code <- ifelse(substr(acs.nyc$GEOID, 3, 5) == "047", 3, acs.nyc$boro_code)
acs.nyc$boro_code <- ifelse(substr(acs.nyc$GEOID, 3, 5) == "061", 1, acs.nyc$boro_code)
acs.nyc$boro_code <- ifelse(substr(acs.nyc$GEOID, 3, 5) == "081", 4, acs.nyc$boro_code)
acs.nyc$boro_code <- ifelse(substr(acs.nyc$GEOID, 3, 5) == "085", 5, acs.nyc$boro_code)

acs.nyc$boro_ct201 <- as.factor(paste0(acs.nyc$boro_code, substr(acs.nyc$GEOID, 6, nchar(acs.nyc$GEOID))))

acs.nyc$perc.black <- ifelse(acs.nyc$boro_ct201 == "1014300", NA, acs.nyc$perc.black)
acs.nyc$perc.hisp  <- ifelse(acs.nyc$boro_ct201 == "1014300", NA, acs.nyc$perc.hisp)
acs.nyc$perc.pov   <- ifelse(acs.nyc$boro_ct201 == "1014300", NA, acs.nyc$perc.pov)

census_tracts_ses <- acs.nyc %>%
  sf::st_transform(2163)

# area (km2)
census_tracts_ses$area_km2 <- as.numeric(sf::st_area(census_tracts_ses)) / (1000*1000)

# building density
target <- census_tracts_ses[,"GEOID"]
source <- neigh_regions_grid[,c("reg_id", "area_density_plan", "mean_height")]

# areal interpolation of geometrical parameters
build_dens_cns_tct <- areal::aw_interpolate(target, tid = GEOID, source = source, sid = reg_id,
                                            weight = "sum", output = "tibble", intensive = "area_density_plan")
mean_height_cns_tct <- areal::aw_interpolate(target, tid = GEOID, source = source, sid = reg_id,
                                             weight = "sum", output = "tibble", intensive = "mean_height")
cns_trt_geom <- dplyr::left_join(build_dens_cns_tct, mean_height_cns_tct, by = "GEOID")

# put together
census_tracts_ses <- dplyr::left_join(census_tracts_ses, cns_trt_geom, by = "GEOID") 

# estimate population density in inhabitants / km2
census_tracts_ses$pop_dens <- census_tracts_ses$popn/census_tracts_ses$area_km2

saveRDS(census_tracts_ses, paste0(generated.data.folder, "census_tracts_ses.rds"))





