# aim: prepare open streets transportation alternatives data
# author: Jaime Benavides
# date: 11/15/21

# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

# load data

# census tracts 
census_tracts_ses <- readRDS(paste0(generated.data.folder, 
                                    "census_tracts_ses.rds"))
census_tracts_ses_df <- census_tracts_ses
sf::st_geometry(census_tracts_ses_df) <- NULL

# buildings

buildings <- sf::read_sf(paste0(buildings.data.folder, "geo_export_f7a89c9b-6561-41c9-b3a5-8114624ae6ba.shp"))%>%
  sf::st_transform(2163) %>%
  dplyr::mutate(height = heightroof * 0.3048)

# # implemented open streets according to Transportation Alternatives
# # using the column Nearby.Address as location to geo-reference
 open_streets_imp <- read.xlsx(
   paste0(streets.data.folder, "open_streets_implemented_TA.xlsx"),
   3,
   startRow = 2,
   colNames = TRUE,
   rowNames = FALSE)
 open_streets_imp <- tidygeocoder::geocode(open_streets_imp,
   address = Nearby.Address)
#saveRDS(open_streets_imp, paste0(generated.data.folder, "open_streets_imp_intermediate.rds"))
open_streets_imp <- readRDS(paste0(generated.data.folder, "open_streets_imp_intermediate.rds"))
# # 18 out of 261 Open Streets addresses, visual check
# # add manually the lat long of non geocoded
open_streets_imp$Nearby.Address[which(is.na(open_streets_imp$lat))]
# # 18 missing locations
# # left as na's because not sufficient data to geo-reference
lat <- c(NA, NA, 40.693762184363095, 40.73457276063981, 40.739012, 40.73054525867177, 40.68274438736161,
          40.68397694348586, 40.606833, 40.722866, 40.711914,
          NA, 40.749840, 40.604203979349215, 40.78103461206553, 40.697101, 40.57261667935275, NA)
 long <- c(NA, NA, -73.82645610209973, -73.93571811468445, -73.904573, -73.84561607790721, -73.86228547790911,
           -73.78717004907331, -73.747434, -73.863935, -73.854947,
           NA, -73.827805, -73.74365078215327, -73.91762622024196, -73.861679, -74.11530833743547, NA)
 nas <- which(is.na(open_streets_imp$lat))
 open_streets_imp$lat[nas] <- lat
 open_streets_imp$long[nas] <- long

 nas <- which(is.na(open_streets_imp$lat))

 open_streets_imp <- open_streets_imp[-nas,]

# visual check: correct erroneous geolocations, checked visually 5% of locations

 nearby <- c("33 E 20th St, New York, NY 10003", "29 Spring St, New York, NY 10012", "2 St Marks Pl, New York, NY 10003", "81 St Marks Pl, New York, NY 10003", "113 University Pl, New York, NY 10003")
open_streets_imp[which(open_streets_imp$Nearby.Address == nearby[1]), c("lat", "long")] <- as.list(c(40.739059, -73.989405))
open_streets_imp[which(open_streets_imp$Nearby.Address == nearby[2]), c("lat", "long")] <- as.list(c(40.721416, -73.994967))
open_streets_imp[which(open_streets_imp$Nearby.Address == nearby[3]), c("lat", "long")] <- as.list(c(40.729076, -73.988804))
open_streets_imp[which(open_streets_imp$Nearby.Address == nearby[4]), c("lat", "long")] <- as.list(c(40.727210, -73.984383))
open_streets_imp[which(open_streets_imp$Nearby.Address == nearby[5]), c("lat", "long")] <- as.list(c(40.732564, -73.993965))

# set census tracts per open street

 open_streets_imp_sf <- sf::st_as_sf(open_streets_imp, coords = c("long", "lat"),
                                     crs = sf::st_crs(4326)) %>%
   sf::st_transform(sf::st_crs(2163))

saveRDS(open_streets_imp_sf, paste0(generated.data.folder, "open_streets_ta_point.rds"))
