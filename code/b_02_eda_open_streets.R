# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

open_streets_prep <- readRDS(paste0(generated.data.folder, "open_streets_prep_rev01.rds"))
colnames(open_streets_prep)[1] <- "date"

open_streets_nyc_dot <- sf::read_sf(paste0(streets.data.folder, "OpenStreets2021_11_22.shp"))%>%
  sf::st_transform(sf::st_crs(2163))

census_tracts_ses <- readRDS(paste0(generated.data.folder, "census_tracts_ses.rds"))

# create map of open streets in NYC

map_title <- ""
map_open_streets <-  tm_shape(census_tracts_ses) + 
  tm_borders(alpha = 0.1, col = "black") +
  tm_shape(open_streets_nyc_dot) + 
  tm_lines(col="black", scale=2, legend.lwd.show = FALSE) 
tmap_save(map_open_streets, paste0(output.folder, "map_open_streets.png")) 

# summarize september 2021
open_streets_prep_summ <- open_streets_prep %>%
  dplyr::filter(date > "2021-08-31") %>%
  dplyr::group_by(GEOID) %>%
  dplyr::summarise(open_streets_perc_area = mean(perc_area, na.rm = T))

open_streets_prep_sept_21 <- open_streets_prep %>%
  dplyr::filter(date > "2021-08-31") %>%
  dplyr::group_by(GEOID)


census_tracts_ses <- dplyr::left_join(census_tracts_ses, open_streets_prep_summ, by = "GEOID")

census_tracts_ses$perc.white_non_hisp <- 1 - census_tracts_ses$perc.black - census_tracts_ses$perc.hisp

census_tracts_ses_df <- census_tracts_ses
sf::st_geometry(census_tracts_ses_df) <- NULL


# plot distributions
census_tracts_ses_df$quart_perc_pov <- ntile(census_tracts_ses_df$perc.pov, 4)
open_streets_prep_summ_cns <- dplyr::left_join(open_streets_prep_summ, census_tracts_ses_df[,c("GEOID", "perc.pov", "quart_perc_pov")], by = "GEOID")

# open_streets_prep_summ_cns$quart_perc_pov <- ntile(open_streets_prep_summ_cns$perc.pov, 4)

# quartiles
q1_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 1)
q2_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 2)
q3_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 3)
q4_ind <- which(open_streets_prep_summ_cns$quart_perc_pov == 4)

# distribution of percentage area covered by Open Streets in a census tract for NYC and poverty quartiles

open_streets_prep_summ_cns %>% dplyr::count(quart_perc_pov)
census_tracts_ses_df %>% dplyr::count(quart_perc_pov)

open_streets_prep_summ_cns_desc <- open_streets_prep_summ_cns %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

open_streets_prep_summ_cns_q1_ind_desc <- open_streets_prep_summ_cns[q1_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

open_streets_prep_summ_cns_q2_ind_desc <- open_streets_prep_summ_cns[q2_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

open_streets_prep_summ_cns_q3_ind_desc <- open_streets_prep_summ_cns[q3_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))

open_streets_prep_summ_cns_q4_ind_desc <- open_streets_prep_summ_cns[q4_ind,] %>%
  dplyr::summarize(med_open_streets_perc_area = median(open_streets_perc_area, na.rm = T),
                   q_25_open_streets_perc_area = quantile(open_streets_perc_area, 0.25,  na.rm = T),
                   q_75_open_streets_perc_area = quantile(open_streets_perc_area, 0.75,  na.rm = T))


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


