# aim: prepare open streets dataset for main analysis
# author: Jaime Benavides
# date: 11/15/21

# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

# load data
lion_streets_simp <- readRDS(paste0(generated.data.folder, "lion_streets_simp.rds"))
streets_nyc_geom_street <- readRDS(paste0(generated.data.folder, "streets_nyc_geom_street.rds"))
streets_nyc_geom_street <- dplyr::left_join(lion_streets_simp, 
                                      streets_nyc_geom_street[,c("street_id", "street_width", "building_height", "b_height_to_s_width")], by = "street_id")
streets_nyc_geom_street_df <- streets_nyc_geom_street
sf::st_geometry(streets_nyc_geom_street_df) <- NULL
# census tracts 
census_tracts_ses <- readRDS(paste0(generated.data.folder, 
                                    "census_tracts_ses.rds"))
census_tracts_ses_df <- census_tracts_ses
sf::st_geometry(census_tracts_ses_df) <- NULL

# buildings

buildings <- sf::read_sf(paste0(buildings.data.folder, "geo_export_f7a89c9b-6561-41c9-b3a5-8114624ae6ba.shp")) %>%
  sf::st_transform(4326) %>% # intermediate step needed to make it work :)
  sf::st_transform(2163) %>%
  dplyr::mutate(height = heightroof * 0.3048)



# NYC street width <= 100 feet  https://www.baruch.cuny.edu/nycdata/infrastructure/the_grid.html
# open streets


open_streets_nyc_dot <- sf::read_sf(paste0(streets.data.folder, "OpenStreets2021_11_22.shp"))%>%
  sf::st_transform(sf::st_crs(2163))

nearest <- sf::st_nearest_feature(open_streets_nyc_dot, streets_nyc_geom_street)
open_streets_nyc_dot_df <- open_streets_nyc_dot
sf::st_geometry(open_streets_nyc_dot_df) <- NULL
open_streets_nyc_dot_df$street_width <- streets_nyc_geom_street_df[nearest, "street_width"]


open_streets_nyc_dot_areas <- sf::st_buffer(open_streets_nyc_dot, dist = open_streets_nyc_dot_df$street_width/2, endCapStyle = "FLAT")

open_streets_imp_sf <- readRDS(paste0(generated.data.folder, "open_streets_ta_point.rds"))
open_streets_imp_df <- open_streets_imp_sf
sf::st_geometry(open_streets_imp_df) <- NULL
op_st_active <- which(open_streets_imp_sf$'Active.vs.Non-Operational' == "Active")
# correct only na after visual inspection and distance measured in google maps
open_streets_imp_df$`Length.of.&#10;Open&#10;Street.(ft)`[op_st_active[106]] <- 885.827
length_active_open_street <- open_streets_imp_df$`Length.of.&#10;Open&#10;Street.(ft)`[op_st_active] * 0.3048
radius <- length_active_open_street / 2


# active open streets areas assign to census tracts
open_streets_active_areas <- sf::st_buffer(open_streets_imp_sf[op_st_active,], dist = radius)


inter <- sf::st_intersects(census_tracts_ses, open_streets_active_areas)

sel_logical = lengths(inter) > 0
census_tracts_ses$op_st_active <- as.integer(sel_logical & census_tracts_ses$pop_dens > 100)
open_streets_df <- open_streets_imp_sf
sf::st_geometry(open_streets_df) <- NULL


# presence of open streets areas assign to census tracts

inter <- sf::st_intersects(census_tracts_ses, open_streets_nyc_dot_areas)

sel_logical = lengths(inter) > 0
census_tracts_ses$op_st_presence <- as.integer(sel_logical)
open_streets_nyc_dot_areas_df <- open_streets_nyc_dot_areas
sf::st_geometry(open_streets_nyc_dot_areas_df) <- NULL


dates = as.character(seq(ISOdatetime(year = "2021",
                       month = "06", day = "21", hour = "00", min = 0,
                       sec = 0, tz = "UTC"),
           ISOdatetime(year = "2021",
                       month = "09", day = "22", hour = "23", min = 0,
                       sec = 0, tz = "UTC"), by = "day"))

# census tract with open streets
present_op_st <- which(census_tracts_ses$op_st_presence > 0)
# initiate data frames containing dates x census tracts with open street presence
# this data frames aggregate all open streets at each census tract
op_st_presence_df <- data.frame(dates=dates)
op_st_perc_area_df <- data.frame(dates=dates)
for(p in 1:length(present_op_st)){
dt_open_st <- integer()
# geo id of the census tract of interest
geo_id <- census_tracts_ses_df[which(census_tracts_ses$op_st_presence > 0), "GEOID"][p]
open_street_pres <- integer()
op_st_perc_area_coll <- numeric()
# what are the intersecting open streets?
open_street_cns_trct <- sf::st_intersection(open_streets_nyc_dot_areas,
                                            census_tracts_ses[census_tracts_ses$GEOID==geo_id,])

# estimate % of street area in census tract occupied by open streets
cns_tct_area <- as.numeric(sf::st_area(census_tracts_ses[census_tracts_ses$GEOID==geo_id,]))

buildings_cns_trct <- sf::st_intersection(buildings, 
                                          census_tracts_ses[census_tracts_ses$GEOID==geo_id,])
bld_area <- as.numeric(sum(sf::st_area(buildings_cns_trct)))
open_and_street_area <- cns_tct_area - bld_area
open_street_cns_trct_df <- open_street_cns_trct
sf::st_geometry(open_street_cns_trct_df) <- NULL
  for(dt in 1:length(dates)){
  date_open <- as.Date(dates[dt], format = "%Y-%m-%d")
  in_per <- which(open_street_cns_trct_df$apprStartD < date_open
        & open_street_cns_trct_df$apprEndDat > date_open)
  if(any(in_per)){
    # is day of the week of analysis within the active open street week days
    weekday_anal <- weekdays(as.Date(date_open))
    # day of the week that open streets are active
    days <- open_street_cns_trct_df[in_per, "apprDaysWe"]
    day_week  <- dplyr::pull(days, apprDaysWe) 
    if(is.na(day_week)){day_week <- "unknown"}
    coll <- character()
    for(d in 1:length(day_week)){ # for each open street
      if(weekday_anal == "Monday" & grepl("mon", day_week[d], fixed = TRUE)){
      coll <- append(coll, "yes")
      } else if(weekday_anal == "Tuesday" & grepl("tue", day_week[d], fixed = TRUE)) {
      coll <- append(coll, "yes")
      } else if(weekday_anal == "Wednesday" & grepl("wed", day_week[d], fixed = TRUE)) {
      coll <- append(coll, "yes")
      } else if(weekday_anal == "Thursday" & grepl("thu", day_week[d], fixed = TRUE)) {
      coll <- append(coll, "yes")
      } else if(weekday_anal == "Friday" & grepl("fri", day_week[d], fixed = TRUE)) {
      coll <- append(coll, "yes")
      } else if(weekday_anal == "Saturday" & grepl("sat", day_week[d], fixed = TRUE)) {
      coll <- append(coll, "yes")
      } else if(weekday_anal == "Sunday" & grepl("sun", day_week[d], fixed = TRUE)) {
      coll <- append(coll, "yes")
      } else {
        coll <- append(coll, "no")
        }
    } # for each open street checking day of the week
    if(any(coll=="yes")){
    open_street_pres <- append(open_street_pres, 1)
    area_loc <- as.numeric(sum(sf::st_area(open_street_cns_trct[in_per[which(coll == "yes")],])))
    op_st_perc_area <- area_loc / (open_and_street_area) * 100
    op_st_perc_area_coll <- c(op_st_perc_area_coll, op_st_perc_area)
    } else {
    open_street_pres <- append(open_street_pres, 0)
    op_st_perc_area_coll <- c(op_st_perc_area_coll, 0)
    }
  } else {
    open_street_pres <- append(open_street_pres, 0)
    op_st_perc_area_coll <- c(op_st_perc_area_coll, 0)
  }
  } # for each date 
# estimate percentage of open street per census tract
op_st_presence_df[,(p+1)] <- open_street_pres
op_st_perc_area_df[,(p+1)] <- op_st_perc_area_coll
} # for census tracts
colnames(op_st_presence_df)[2:(length(present_op_st)+1)] <- as.character(present_op_st)
colnames(op_st_perc_area_df)[2:(length(present_op_st)+1)] <- as.character(present_op_st)


saveRDS(census_tracts_ses[,c("GEOID", "op_st_active", "op_st_presence")], paste0(generated.data.folder, 
                                                                                 "cns_trct_open_streets.rds"))




# save intermediate datasets
saveRDS(op_st_presence_df, paste0(generated.data.folder, "op_st_presence_df_rev01.rds"))
saveRDS(op_st_perc_area_df, paste0(generated.data.folder, "op_st_perc_area_df.rds"))

# starting analysis from here again to reshape data and add temporal variables

op_st_presence_df <- readRDS(paste0(generated.data.folder, "op_st_presence_df_rev01.rds"))
op_st_perc_area_df <- readRDS(paste0(generated.data.folder, "op_st_perc_area_df.rds"))

# organize data as follows: date / geoid / present / length / percentage
geo_ids <- census_tracts_ses_df[which(census_tracts_ses$op_st_presence > 0), "GEOID"]
colnames(op_st_presence_df)[2:ncol(op_st_presence_df)] <- geo_ids
colnames(op_st_perc_area_df)[2:ncol(op_st_perc_area_df)] <- geo_ids


op_st_presence_df_l <- reshape2::melt(op_st_presence_df, 
                                  id.vars = c("dates"),
                                  variable.name = "GEOID",
                                  value.name = "presence")

open_streets_prep <- op_st_presence_df_l

op_st_perc_area_df_l <- reshape2::melt(op_st_perc_area_df, 
                                      id.vars = c("dates"),
                                      variable.name = "GEOID",
                                      value.name = "perc_area")

head(open_streets_prep)

open_streets_prep <- left_join0(open_streets_prep, op_st_perc_area_df_l, by = c("dates", "GEOID"))

# weekday / weekend
dts <- as.Date(open_streets_prep$dates)
day_type <- character()
day_type[format(dts, "%w") %in% c(1, 2, 3, 4, 5)] <- "weekday"
day_type[format(dts, "%w") %in% c(0, 6)] <- "weekend"

open_streets_prep$day_type <- day_type

# day of the week
dts <- as.Date(open_streets_prep$dates)
day_week <- character()
day_week[format(dts, "%w") %in% c(0)] <- "sunday"
day_week[format(dts, "%w") %in% c(1)] <- "monday"
day_week[format(dts, "%w") %in% c(2)] <- "tuesday"
day_week[format(dts, "%w") %in% c(3)] <- "wednesday"
day_week[format(dts, "%w") %in% c(4)] <- "thursday"
day_week[format(dts, "%w") %in% c(5)] <- "friday"
day_week[format(dts, "%w") %in% c(6)] <- "saturday"


open_streets_prep$day_week <- day_week


saveRDS(open_streets_prep, paste0(generated.data.folder, "open_streets_prep_rev01.rds"))
