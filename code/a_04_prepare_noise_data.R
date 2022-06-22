

# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

# census tracts
census_tracts_ses <- readRDS(paste0(generated.data.folder, "census_tracts_ses.rds")) %>%
  sf::st_transform(2163)
# noise 311
nyc_311_noise_calls_2019_present <- readRDS(paste0(generated.data.folder, "nyc_311_noise_calls_2019_present.rds"))

na <- which(is.na(nyc_311_noise_calls_2019_present$longitude)  |  
              is.na(nyc_311_noise_calls_2019_present$latitude))
nyc_311_noise_calls_2019_present <- nyc_311_noise_calls_2019_present[-na,]

nyc_311_noise_calls_2019_present <- nyc_311_noise_calls_2019_present %>%
  dplyr::filter(complaint_type %in% c("Noise - Street/Sidewalk", 
                                      "Noise - Commercial",
                                      "Noise - Vehicle", 
                                      "Noise - Residential"))
# rename noise complaint types
nyc_311_noise_calls_2019_present$complaint_type <- 
  tolower(gsub("/", "_", gsub("Noise - ", "", nyc_311_noise_calls_2019_present$complaint_type)))

nyc_311_noise_calls_2019_present$date <- format(nyc_311_noise_calls_2019_present[,"created_date"][[1]], "%Y-%m-%d")
nyc_311_noise_calls_2019_present$time_day <- as.numeric(format(nyc_311_noise_calls_2019_present[,"created_date"][[1]], "%H"))

day_week_n <- format(nyc_311_noise_calls_2019_present[,"created_date"][[1]], "%w")
day_week <- character()
day_week[day_week_n %in% c(0)] <- "sunday"
day_week[day_week_n %in% c(1)] <- "monday"
day_week[day_week_n %in% c(2)] <- "tuesday"
day_week[day_week_n %in% c(3)] <- "wednesday"
day_week[day_week_n %in% c(4)] <- "thursday"
day_week[day_week_n %in% c(5)] <- "friday"
day_week[day_week_n %in% c(6)] <- "saturday"
nyc_311_noise_calls_2019_present$day_week <- day_week
# assign time of day category
# 6 - 12 morning
# 12 - 18 afternoon
# 18 - 22 evening
# 22 to 6 night
morning <- which(nyc_311_noise_calls_2019_present$time_day >= 6 & nyc_311_noise_calls_2019_present$time_day < 12)
afternoon <- which(nyc_311_noise_calls_2019_present$time_day >= 12 & nyc_311_noise_calls_2019_present$time_day < 18)
evening <- which(nyc_311_noise_calls_2019_present$time_day >= 18 & nyc_311_noise_calls_2019_present$time_day < 22)
night <- which(nyc_311_noise_calls_2019_present$time_day >= 22  |  nyc_311_noise_calls_2019_present$time_day < 6)
nyc_311_noise_calls_2019_present$timeday <- NA
nyc_311_noise_calls_2019_present$timeday[morning] <- "morning"
nyc_311_noise_calls_2019_present$timeday[afternoon] <- "afternoon"
nyc_311_noise_calls_2019_present$timeday[evening] <- "evening"
nyc_311_noise_calls_2019_present$timeday[night] <- "night"

noise_sf <- sf::st_as_sf(nyc_311_noise_calls_2019_present, coords = c("longitude", "latitude"), 
                         crs = 4326) %>%
  sf::st_transform(2163)
noise_sf <- sf::st_intersection(noise_sf, sf::st_difference(census_tracts_ses["GEOID"]))

noise_df <- noise_sf
sf::st_geometry(noise_df) <- NULL

noise_timeday_df <- noise_df[,c("GEOID", "date", "timeday")] %>%
  dplyr::group_by(GEOID, date, timeday) %>%
  dplyr::tally()  

noise_dayweek_df <- noise_df[,c("GEOID", "date", "day_week")] %>%
  dplyr::group_by(GEOID, date, day_week) %>%
  dplyr::tally()  

noise_type_df <- noise_df[,c("GEOID", "date","complaint_type")] %>%
  dplyr::group_by(GEOID, date, complaint_type) %>%
  dplyr::tally()  
noise_df_complaint <- noise_type_df %>% tidyr::pivot_wider(names_from = complaint_type, values_from = n, values_fill = 0)  
noise_df_timeday <- noise_timeday_df %>% tidyr::pivot_wider(names_from = timeday, values_from = n, values_fill = 0) 
noise_df_dayweek <- noise_dayweek_df %>% tidyr::pivot_wider(names_from = day_week, values_from = n, values_fill = 0) 


noise_df_def <- dplyr::left_join(noise_df_complaint, noise_df_timeday, noise_df_dayweek, by = 
                   c("GEOID", "date")) 


# add days with zero noise complaints 

# build a dataframe with zeros per noise complaints

dates = as.character(c(seq(ISOdatetime(year = "2019",
                                       month = "06", day = "21", hour = "00", min = 0,
                                       sec = 0, tz = "UTC"),
                           ISOdatetime(year = "2019",
                                       month = "09", day = "23", hour = "23", min = 0,
                                       sec = 0, tz = "UTC"), by = "day"),seq(ISOdatetime(year = "2021",
                                     month = "06", day = "21", hour = "00", min = 0,
                                     sec = 0, tz = "UTC"),
                         ISOdatetime(year = "2021",
                                     month = "09", day = "22", hour = "23", min = 0,
                                     sec = 0, tz = "UTC"), by = "day")))

# combine zeros dataframe with already prepared noise complaints dataset 
geoids <- unique(census_tracts_ses$GEOID)


noise_compl_all <- data.frame(GEOID = rep(geoids, each=length(dates)), 
                              date=rep(dates, length(geoids)), 
                              residential = 0, street_sidewalk = 0, commercial = 0, vehicle = 0, night = 0, evening = 0, afternoon = 0, morning = 0)


setDT(noise_df_def)
setDT(noise_compl_all)
noise_compl_all[noise_df_def, on=c("GEOID", "date"), residential:=i.residential]
noise_compl_all[noise_df_def, on=c("GEOID", "date"), street_sidewalk:= i.street_sidewalk]
noise_compl_all[noise_df_def, on=c("GEOID", "date"), commercial:= i.commercial]
noise_compl_all[noise_df_def, on=c("GEOID", "date"), vehicle:= i.vehicle]
noise_compl_all[noise_df_def, on=c("GEOID", "date"), night:= i.night]
noise_compl_all[noise_df_def, on=c("GEOID", "date"), evening:= i.evening]
noise_compl_all[noise_df_def, on=c("GEOID", "date"), afternoon:= i.afternoon]
noise_compl_all[noise_df_def, on=c("GEOID", "date"), morning:= i.morning]

saveRDS(noise_compl_all, paste0(generated.data.folder, "noise_prep.rds"))
