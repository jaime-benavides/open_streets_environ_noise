

# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

# noise complaints data from 311 
# data downloaded from https://nycopendata.socrata.com/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9
nyc_311_calls <- readr::read_csv(paste0(noise_path, "311_Service_Requests_from_2010_to_Present.csv"))
nyc_311_noise_calls <- nyc_311_calls %>% 
  dplyr::filter(stringr::str_detect(`Complaint Type`, 'Noise'))
colnames(nyc_311_noise_calls) <- tolower(gsub(" ", "_", colnames(nyc_311_noise_calls)))
nyc_311_noise_calls_2019_present <- nyc_311_noise_calls %>%
  dplyr::mutate(created_date = lubridate::mdy_hms(created_date))

nyc_311_noise_calls_2019_present <- nyc_311_noise_calls_2019_present[which(nyc_311_noise_calls_2019_present$created_date > as.Date("2019-01-01")),]
nyc_311_noise_calls_2019_present <- nyc_311_noise_calls_2019_present[,c("unique_key", "created_date", "complaint_type", "descriptor", "incident_address", "borough", "latitude" , "longitude")]
saveRDS(nyc_311_noise_calls_2019_present, paste0(noise_path, "nyc_311_noise_calls_2019_present.rds"))
