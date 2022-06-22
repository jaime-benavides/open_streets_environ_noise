# open_streets_environ_noise
Repository for reviewing the code of the project Unintended Impacts of Open Streets on noise complaints in NYC

note: please run init_directory_structure.R first to create folders. Also run this script before doing anything else, currently done via source(paste0(project.folder,'init_directory_structure.R'), to ensure that the folder locations are known in each script

## Code and data generated (file name - short description)

### Data preparation (data_prep) list:

a_01_prepare_area_geometrical_data.R

- nyc_neigh_regions.rds - geometrical parameters at 250 m x 250 m resolution 

a_02_prepare_street_geometrical_data.R (divided in 5 parts to parallel the process)

a_02_prepare_street_geometrical_data_collect.R (collects data from previous step)

- streets_nyc_geom_street.rds - geometrical parameters at each street segment

a_03_prepare_census_data.R

- census_tracts_ses.rds - socio-demographic data at census tract level

a_04_prepare_311_data.R

- nyc_311_noise_calls_2019_present.rds

a_04_prepare_noise_data.R

- noise_prep.rds

a_05_prepare_poi_data.R

- open_restaurants_nyc_nas.rds

- poi_nyc.rds

a_06_prepare_open_streets_trans_altern_data.R

- cns_trct_open_streets.rds 

- open_streets_ta_point.rds

- open_streets_imp_intermediate.rds 

a_06_prepare_open_streets_data.R

- lion_streets_simp.rds

- open_streets_prep_rev01.rds 

- op_st_perc_area_df.rds 

- op_st_presence_df_rev01.rds 

### Data exploration (data_exploration) list:

b_01_eda_noise_complaints.R

b_02_eda_open_streets.R

### Model running (models) list:

c_01_model_street_sidewalk_main_s5.R

c_02_model_vehicle_main_s5.R

c_03_model_street_sidewalk_s4.R

c_04_model_vehicle_s4.R

c_05_model_street_sidewalk_s3.R

c_06_model_vehicle_s3.R

c_07_model_street_sidewalk_trans_altern.R

c_08_model_vehicle_trans_altern.R

c_09_model_street_sidewalk_open_rest.R

c_10_model_vehicle_open_rest.R

c_11_model_street_sidewalk_poi.R

c_12_model_vehicle_poi.R

c_13_model_street_sidewalk_spatial.R

c_14_model_vehicle_spatial.R

c_15_analysis_model_res.R

## Data (data) list:

### Raw (description - file name - link to source)

#### demography

NYC boroughs - nybb.shp -  https://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page

#### noise

311 calls - 311_Service_Requests_from_2010_to_Present.csv - https://nycopendata.socrata.com/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9

#### points of interest

Points of interest - geo_export_a41a111b-823e-4751-b748-0f3782bc90b7.shp - https://data.cityofnewyork.us/City-Government/Points-Of-Interest/rxuy-2muj

Facilities - facilities_complete_2021-05-07.shp - https://capitalplanning.nyc.gov/map/facilities#10/40.7128/-74.0807

#### mobility

safegraph - NYC_CensusTracts_share.RData - https://docs.safegraph.com/docs/weekly-patterns

#### geometry

##### buildings

NYC building footprints - geo_export_f7a89c9b-6561-41c9-b3a5-8114624ae6ba.shp - https://data.cityofnewyork.us/Housing-Development/Building-Footprints/nqwf-w8eh

##### streets

NYC streets - lion.gdb - https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-lion.page

Open Streets (NYC DOT) - OpenStreets2021_11_22.shp - NYC DOT Personal communication 

Open Streets (Transportation Alternatives) - open_streets_implemented_TA.xlsx - https://www.transalt.org/open-streets-forever-nyc#methodology

##### land use

Open Restaurants - Open_Restaurant_Applications.csv - https://data.cityofnewyork.us/Transportation/Open-Restaurant-Applications/pitm-atqc













