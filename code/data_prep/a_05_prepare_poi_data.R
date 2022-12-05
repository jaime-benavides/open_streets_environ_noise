# aim: prepare dataset on points of interest and open restaurants per census tract 

# First step to load packages etc.
rm(list=ls())

# declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

## load open restaurant data
open_restaurants_nyc <- readr::read_csv(paste0(land_use.data.folder, "Open_Restaurant_Applications.csv"))  
# get rid of AM/PM for time, which is not needed
open_restaurants_nyc$`Time of Submission` <-as.POSIXct(gsub(" AM", "",gsub(" PM", "", open_restaurants_nyc$`Time of Submission`)), format = "%m/%d/%Y %H:%M:%S")
# limit to open restaurants with submission date before the end of the study period
open_restaurants_nyc <- open_restaurants_nyc %>%
  dplyr::filter(`Time of Submission` < as.Date('09/23/2021', format = "%m/%d/%Y")) %>%
  dplyr::filter(`Approved for Sidewalk Seating` =="yes" | `Approved for Roadway Seating` == "yes")



coord_nas <- which(is.na(open_restaurants_nyc$Longitude)  | is.na(open_restaurants_nyc$Latitude)) 
# 10% of open restaurants don't have coordinates, for those transform address to coordinates in order to obtain more open restaurants
open_restaurants_nyc_nas <- tidygeocoder::geocode(open_restaurants_nyc[coord_nas,],
                                               address = 'Business Address')
saveRDS(open_restaurants_nyc_nas, paste0(generated.data.folder, "open_restaurants_nyc_nas.rds"))
open_restaurants_nyc_nas <- readRDS(paste0(generated.data.folder, "open_restaurants_nyc_nas.rds"))
# delete original lat lon 
open_restaurants_nyc_nas <- open_restaurants_nyc_nas[,-c(28,29)]
# rename coordinate columns
colnames(open_restaurants_nyc_nas)[c(34,35)] <- c("Latitude", "Longitude")
# add values from geocoded dataset to the open restaurant dataset containing all instances
open_restaurants_nyc <- open_restaurants_nyc %>% dplyr::rows_update(open_restaurants_nyc_nas[,c("globalid", "Latitude", "Longitude")], by = "globalid")

coord_nas <- which(is.na(open_restaurants_nyc$Longitude)  | is.na(open_restaurants_nyc$Latitude)) 

# build spatial open restaurant dataset 
open_restaurants_nyc_sf <- sf::st_as_sf(open_restaurants_nyc[-coord_nas,], coords = c("Longitude",
                                           "Latitude"  ), crs = 4326)  %>%
  sf::st_transform(2163)

# read POIs dataset 
poi_nyc_sf <- sf::read_sf(paste0(points_of_interest.data.folder, "geo_export_a41a111b-823e-4751-b748-0f3782bc90b7.shp"))  %>%
  sf::st_transform(2163)


# read census tracts dataset
census_tracts_ses <- readRDS(paste0(generated.data.folder, "census_tracts_ses.rds"))  %>%
  sf::st_transform(2163)


# estimate total number of open restaurants per census tract
open_restaurants_cens_tr <- sf::st_intersection(open_restaurants_nyc_sf, sf::st_difference(census_tracts_ses))
open_restaurants_cens_tr_df <- open_restaurants_cens_tr
sf::st_geometry(open_restaurants_cens_tr_df) <- NULL
open_restaurants_cns_trct <- open_restaurants_cens_tr_df %>%
  dplyr::group_by(GEOID) %>%
  dplyr::tally()  %>%
  dplyr::rename(open_restaurants = n)

# estimate total number of POIs per census tract
poi_nyc_sf_cens_tr <- sf::st_intersection(poi_nyc_sf, sf::st_difference(census_tracts_ses))
poi_nyc_sf_df <- poi_nyc_sf_cens_tr
sf::st_geometry(poi_nyc_sf_df) <- NULL
poi_nyc_cns_trct <- poi_nyc_sf_df %>%
  dplyr::group_by(GEOID) %>%
  dplyr::tally()  %>%
  dplyr::rename(poi_nyc = n)

# combine datasets
poi_nyc <- left_join0(open_restaurants_cns_trct, poi_nyc_cns_trct, by = 'GEOID')
# save
saveRDS(poi_nyc, paste0(generated.data.folder, "poi_nyc", ".rds"))
