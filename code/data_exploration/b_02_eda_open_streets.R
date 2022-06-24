# exploratory data analysis of open streets

# First step to load packages etc.
rm(list=ls())

# declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

## read open streets
# read open streets prepared dataset with daily values
open_streets_prep <- readRDS(paste0(generated.data.folder, "open_streets_prep.rds"))
colnames(open_streets_prep)[1] <- "date"
# read open streets by NYC DOT
open_streets_nyc_dot <- sf::read_sf(paste0(streets.data.folder, "OpenStreets2021_11_22.shp"))%>%
  sf::st_transform(sf::st_crs(2163))
# read census tracts
census_tracts_ses <- readRDS(paste0(generated.data.folder, "census_tracts_ses.rds"))

# create map of open streets by NYC DOT 
# manuscript Figure 2
map_title <- ""
map_open_streets <-  tm_shape(census_tracts_ses) + 
  tm_borders(alpha = 0.1, col = "black") +
  tm_shape(open_streets_nyc_dot) + 
  tm_lines(col="black", scale=2, legend.lwd.show = FALSE) 
tmap_save(map_open_streets, paste0(output.folder, "map_open_streets.png")) 

# estimate the average area covered by open streets in each census tract in the post-intervention period
open_streets_prep_summ <- open_streets_prep %>%
  dplyr::filter(date > "2021-08-31") %>%
  dplyr::group_by(GEOID) %>%
  dplyr::summarise(open_streets_perc_area = mean(perc_area, na.rm = T))

# filter open streets from September 2021
open_streets_prep_sept_21 <- open_streets_prep %>%
  dplyr::filter(date > "2021-08-31") %>%
  dplyr::group_by(GEOID)

# add average of percentage of census tract area covered by open streets to each census tract
census_tracts_ses <- dplyr::left_join(census_tracts_ses, open_streets_prep_summ, by = "GEOID")
census_tracts_ses_df <- census_tracts_ses
sf::st_geometry(census_tracts_ses_df) <- NULL


# get quartiles of poverty rate
census_tracts_ses_df$quart_perc_pov <- ntile(census_tracts_ses_df$perc.pov, 4)
# add quartiles of poverty rate to the summary of open streets dataset
open_streets_prep_summ_cns <- dplyr::left_join(open_streets_prep_summ, census_tracts_ses_df[,c("GEOID", "perc.pov", "quart_perc_pov")], by = "GEOID")

# quartiles indexes
q1_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 1)
q2_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 2)
q3_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 3)
q4_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 4)

# manuscript Table 2
# distribution of presence of open streets in a census tract for NYC and poverty rate quartiles
open_streets_prep_summ_cns %>% dplyr::count(quart_perc_pov)
census_tracts_ses_df %>% dplyr::count(quart_perc_pov)

## distribution of percentage area covered by Open Streets in a census tract for NYC and poverty rate quartiles
# all census tracts
open_streets_prep_summ_cns_desc <- open_streets_prep_summ_cns %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

# q1 poverty rate census tracts
open_streets_prep_summ_cns_q1_ind_desc <- open_streets_prep_summ_cns[q1_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

# q2 poverty rate census tracts
open_streets_prep_summ_cns_q2_ind_desc <- open_streets_prep_summ_cns[q2_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

# q3 poverty rate census tracts
open_streets_prep_summ_cns_q3_ind_desc <- open_streets_prep_summ_cns[q3_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

# q4 poverty rate census tracts
open_streets_prep_summ_cns_q4_ind_desc <- open_streets_prep_summ_cns[q4_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

# manuscript Figure 1b
# create map of poverty rate
map_title <- ""
map_perc_pov <-  tm_shape(census_tracts_ses) + 
  tm_polygons("perc.pov", palette = 'Reds', style = "fixed",
              title = paste0("Poverty"),
              breaks = c(round(seq(0, 1, 1/10),1))) + 
  tm_borders(alpha = 0.4, col = "black") +
  tm_layout(title = map_title,
            title.size = 1.1,
            title.position = c("center", "top")) +
  tm_legend(legend.position = c("right", "bottom"),
            legend.title.size = 1,
            legend.text.size = 0.6)
tmap_save(map_perc_pov, paste0(output.folder, "map_perc_pov.png")) 

# manuscript Figure 1d
# create map of building density 
map_title <- ""
map_build_dens <-  tm_shape(census_tracts_ses) + 
  tm_polygons("area_density_plan", palette = 'Greys', style = "fixed",
              title = paste0("Building density"),
              breaks = c(round(seq(0, 0.6, 1/10),1))) + 
  tm_borders(alpha = 0.4, col = "black") +
  tm_layout(title = map_title,
            title.size = 1.1,
            title.position = c("center", "top")) +
  tm_legend(legend.position = c("right", "bottom"),
            legend.title.size = 1,
            legend.text.size = 0.6)
tmap_save(map_build_dens, paste0(output.folder, "map_build_dens.png")) 