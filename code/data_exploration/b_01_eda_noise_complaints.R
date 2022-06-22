# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))


noise_prep <- readRDS(paste0(generated.data.folder, "noise_prep.rds"))
census_tracts_ses <- readRDS(paste0(generated.data.folder, "census_tracts_ses.rds"))



# map of noise complaints in Summer 2019 and Summer 2021

noise_prep_2019 <- noise_prep[which(noise_prep$date < 2020),]
noise_prep_2019_sum <- noise_prep_2019 %>%
  dplyr::group_by(GEOID) %>%
  dplyr::summarise(vehicle_sum_2019 = sum(vehicle), street_sidewalk_sum_2019 = sum(street_sidewalk))


noise_prep_2021 <- noise_prep[which(noise_prep$date > 2020),]

noise_prep_2021_sum <- noise_prep_2021 %>%
  dplyr::group_by(GEOID) %>%
  dplyr::summarise(vehicle_sum_2021 = sum(vehicle), street_sidewalk_sum_2021 = sum(street_sidewalk))

census_tracts_ses <- dplyr::left_join(census_tracts_ses, noise_prep_2019_sum[,c("GEOID", "vehicle_sum_2019", "street_sidewalk_sum_2019")], by = "GEOID") %>%
  dplyr::left_join(noise_prep_2021_sum[,c("GEOID", "vehicle_sum_2021", "street_sidewalk_sum_2021")], by =c("GEOID")) 

census_tracts_ses_df <- census_tracts_ses 
sf::st_geometry(census_tracts_ses_df) <- NULL

summary_descrip <- census_tracts_ses_df %>%
  dplyr::summarize(med_vehicle_sum_2019 = median(vehicle_sum_2019, na.rm = T),
                   q_25_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2019 = median(street_sidewalk_sum_2019, na.rm = T),
                   q_25_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.75,  na.rm = T),
                   med_vehicle_sum_2021 = median(vehicle_sum_2021, na.rm = T),
                   q_25_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2021 = median(street_sidewalk_sum_2021, na.rm = T),
                   q_25_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.75,  na.rm = T))


census_tracts_ses_df$quart_perc_pov <- ntile(census_tracts_ses$perc.pov, 4)

# quartiles
q1_ind <- which(census_tracts_ses_df$quart_perc_pov == 1)
q2_ind <- which(census_tracts_ses_df$quart_perc_pov == 2)
q3_ind <- which(census_tracts_ses_df$quart_perc_pov == 3)
q4_ind <- which(census_tracts_ses_df$quart_perc_pov == 4)

# 2019
census_tracts_ses_df_q1_ind_desc <- census_tracts_ses_df[q1_ind,] %>%
  dplyr::summarize(med_vehicle_sum_2019 = median(vehicle_sum_2019, na.rm = T),
                   q_25_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2019 = median(street_sidewalk_sum_2019, na.rm = T),
                   q_25_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.75,  na.rm = T),
                   med_vehicle_sum_2021 = median(vehicle_sum_2021, na.rm = T),
                   q_25_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2021 = median(street_sidewalk_sum_2021, na.rm = T),
                   q_25_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.75,  na.rm = T))

census_tracts_ses_df_q2_ind_desc <- census_tracts_ses_df[q2_ind,] %>%
  dplyr::summarize(med_vehicle_sum_2019 = median(vehicle_sum_2019, na.rm = T),
                   q_25_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2019 = median(street_sidewalk_sum_2019, na.rm = T),
                   q_25_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.75,  na.rm = T),
                   med_vehicle_sum_2021 = median(vehicle_sum_2021, na.rm = T),
                   q_25_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2021 = median(street_sidewalk_sum_2021, na.rm = T),
                   q_25_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.75,  na.rm = T))

census_tracts_ses_df_q3_ind_desc <- census_tracts_ses_df[q3_ind,] %>%
  dplyr::summarize(med_vehicle_sum_2019 = median(vehicle_sum_2019, na.rm = T),
                   q_25_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2019 = median(street_sidewalk_sum_2019, na.rm = T),
                   q_25_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.75,  na.rm = T),
                   med_vehicle_sum_2021 = median(vehicle_sum_2021, na.rm = T),
                   q_25_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2021 = median(street_sidewalk_sum_2021, na.rm = T),
                   q_25_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.75,  na.rm = T))

census_tracts_ses_df_q4_ind_desc <- census_tracts_ses_df[q4_ind,] %>%
  dplyr::summarize(med_vehicle_sum_2019 = median(vehicle_sum_2019, na.rm = T),
                   q_25_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2019 = quantile(vehicle_sum_2019, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2019 = median(street_sidewalk_sum_2019, na.rm = T),
                   q_25_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2019 = quantile(street_sidewalk_sum_2019, 0.75,  na.rm = T),
                   med_vehicle_sum_2021 = median(vehicle_sum_2021, na.rm = T),
                   q_25_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.25,  na.rm = T),
                   q_75_vehicle_sum_2021 = quantile(vehicle_sum_2021, 0.75,  na.rm = T), 
                   med_street_sidewalk_sum_2021 = median(street_sidewalk_sum_2021, na.rm = T),
                   q_25_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.25,  na.rm = T),
                   q_75_street_sidewalk_sum_2021 = quantile(street_sidewalk_sum_2021, 0.75,  na.rm = T))

map_title <- ""
m_vehicle_sum_2019 <-  tm_shape(census_tracts_ses) + 
  tm_polygons("vehicle_sum_2019", palette = 'Oranges', style = "fixed",
              title = paste0("Vehicle - 2019"),
              breaks = c(round(c(seq(0, 10, 1), 121.315),1))) + 
  tm_borders(alpha = 0.4, col = "black") +
  tm_layout(title = map_title,
            title.size = 1.1,
            title.position = c("center", "top")) +
  tm_legend(legend.position = c("right", "bottom"),
            legend.title.size = 1,
            legend.text.size = 0.6)
tmap_save(m_vehicle_sum_2019, paste0(output.folder, "m_vehicle_sum_2019.png")) 

map_title <- ""
m_vehicle_sum_2021 <-  tm_shape(census_tracts_ses) + 
  tm_polygons("vehicle_sum_2021", palette = 'Oranges', style = "fixed",
              title = paste0("Vehicle - 2021"),
              breaks = c(round(c(seq(0, 10, 1), 264.4871),1))) + 
  tm_borders(alpha = 0.4, col = "black") +
  tm_layout(title = map_title,
            title.size = 1.1,
            title.position = c("center", "top")) +
  tm_legend(legend.position = c("right", "bottom"),
            legend.title.size = 1,
            legend.text.size = 0.6)
tmap_save(m_vehicle_sum_2021, paste0(output.folder, "m_vehicle_sum_2021.png")) 

map_title <- ""
m_street_sidewalk_sum_2019 <-  tm_shape(census_tracts_ses) + 
  tm_polygons("street_sidewalk_sum_2019", palette = 'Oranges', style = "fixed",
              title = paste0("street_sidewalk - 2019"),
              breaks = c(round(c(seq(0, 10, 1), 121.315),1))) + 
  tm_borders(alpha = 0.4, col = "black") +
  tm_layout(title = map_title,
            title.size = 1.1,
            title.position = c("center", "top")) +
  tm_legend(legend.position = c("right", "bottom"),
            legend.title.size = 1,
            legend.text.size = 0.6)
tmap_save(m_street_sidewalk_sum_2019, paste0(output.folder, "m_street_sidewalk_sum_2019.png")) 

map_title <- ""
m_street_sidewalk_sum_2021 <-  tm_shape(census_tracts_ses) + 
  tm_polygons("street_sidewalk_sum_2021", palette = 'Oranges', style = "fixed",
              title = paste0("street_sidewalk - 2021"),
              breaks = c(round(c(seq(0, 10, 1), 313.9330),1))) + 
  tm_borders(alpha = 0.4, col = "black") +
  tm_layout(title = map_title,
            title.size = 1.1,
            title.position = c("center", "top")) +
  tm_legend(legend.position = c("right", "bottom"),
            legend.title.size = 1,
            legend.text.size = 0.6)
tmap_save(m_street_sidewalk_sum_2021, paste0(output.folder, "m_street_sidewalk_sum_2021.png"))


