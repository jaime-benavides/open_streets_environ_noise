# aim: street_sidewalk model from main analysis adding spatial term

# First step to load packages etc.
rm(list=ls())

# declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

# read data 

open_streets_prep <- readRDS(paste0(generated.data.folder, "open_streets_prep.rds"))
colnames(open_streets_prep)[1] <- "date"

noise_prep <- readRDS(paste0(generated.data.folder, "noise_prep.rds"))

census_tracts_ses <- readRDS(paste0(generated.data.folder, "census_tracts_ses.rds"))

# get centroids to obtain the coordinates for the spatial term
census_tracts_ses_cent <- sf::st_centroid(census_tracts_ses) %>%
  sf::st_transform(4326)
census_tracts_ses_cent <- data.frame(GEOID = census_tracts_ses_cent$GEOID, sf::st_coordinates(census_tracts_ses_cent))
colnames(census_tracts_ses_cent)[2:3] <- c("lon", "lat")
census_tracts_ses <- dplyr::left_join(census_tracts_ses, census_tracts_ses_cent, by = "GEOID")

census_tracts_ses_df <- census_tracts_ses
sf::st_geometry(census_tracts_ses_df) <- NULL
noise_prep <- noise_prep %>% dplyr::rename(night_noise = night, afternoon_noise = afternoon,
                                           evening_noise = evening, morning_noise = morning)


# add treated column to census tract (=1 for open streets) in the open streets data
cns_trct_os <- unique(open_streets_prep$GEOID)
noise_prep$treated <- ifelse(noise_prep$GEOID %in% cns_trct_os, 1, 0)
# add intervened column for dates within the period of open streets implemented (Summer 2021)
dates_summ_2021 <- as.Date(noise_prep$date) >= as.Date("2021-06-21") & as.Date(noise_prep$date) <= as.Date("2021-09-22")
dates_in_2021 <- which(dates_summ_2021)
dates_in_2019 <- which(as.Date(noise_prep$date) >= as.Date("2019-06-21") & as.Date(noise_prep$date) <= as.Date("2019-09-23"))

noise_prep$intervened <- ifelse(dates_summ_2021, 1, 0)
noise_prep_diff <- noise_prep[c(dates_in_2019, dates_in_2021),]

noise_prep_diff <- left_join0(noise_prep_diff, open_streets_prep[,c("GEOID", "date", "presence", "perc_area")],
                 by = c("GEOID", "date"))

# add ses/geom variables and add longitude and latitude
op_st_noise <- dplyr::left_join(noise_prep_diff, census_tracts_ses_df[,c("GEOID", "perc.black",
                                                      "perc.hisp", "perc.pov", "area_density_plan", "mean_height", "pop_dens", "lon", "lat")], 
                 by = "GEOID")

op_st_noise$GEOID <- as.factor(op_st_noise$GEOID)
op_st_noise$day <- 1 + as.numeric(as.Date(op_st_noise$date)) - as.numeric(as.Date("2019-06-21"))
op_st_noise$day <- op_st_noise$day - ifelse(as.Date(op_st_noise$date) > as.Date("2020-01-01"),(as.numeric(as.Date("2021-06-21"))-as.numeric(as.Date("2019-09-23"))),0)

scaled <- dplyr::ungroup(op_st_noise) %>% 
  dplyr::select(mean_height, area_density_plan, pop_dens, perc.black, perc.hisp, perc.pov, day, lon, lat) %>% 
  purrr::map_df(~ scale(.x, center = FALSE, scale = sd(.x, na.rm = TRUE)))

data_scale <- cbind(op_st_noise[, c("GEOID", "date", "residential", "street_sidewalk", "commercial", "vehicle", "night_noise", "evening_noise", "afternoon_noise", "morning_noise", "treated", "intervened", "presence", "perc_area")],
                  scaled[,c("mean_height", "area_density_plan", "pop_dens", "perc.black", "perc.hisp", "perc.pov", "day", "lon", "lat")])


# add temporal terms based on https://petolau.github.io/Analyzing-double-seasonal-time-series-with-GAM-in-R/
months <- ceiling(length(unique(data_scale$date))/31)
data_scale$day_week <- as.factor(as.POSIXlt(data_scale$date)$wday)
data_scale$month <- as.factor(as.yearmon(data_scale$date,format="%Y-%m-%d")) 

# leaving out census tracts with NA in perc.pov, perc.hisp and perc.black
data_scale <- data_scale[-which(is.na(data_scale$perc.black)),]


all_openstreets_all_cnstract_trad_street_sidewalk_interv_sp <- gamm4::gamm4(street_sidewalk ~ s(perc_area, k=5, fx=TRUE) + intervened + t2(lat,lon) + perc.pov + perc.black 
                                                                         + perc.hisp + pop_dens + area_density_plan + day_week + s(day, bs = "cr", fx = TRUE, k = months),
                                                                    random = ~(1|GEOID), family = negative.binomial(1), data = data_scale, 
                                                                    control = lme4::glmerControl(optCtrl=list(maxfun=2e4)))

saveRDS(all_openstreets_all_cnstract_trad_street_sidewalk_interv_sp, paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5_sp.rds"))

