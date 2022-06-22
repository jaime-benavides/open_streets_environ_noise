# open_streets_environ_noise
Repository for reviewing the code of the project Unintended Impacts of Open Streets on noise complaints in NYC

note: please run init_directory_structure.R first to create folders. Also run this script before doing anything else, currently done via source(paste0(project.folder,'init_directory_structure.R'), to ensure that the folder locations are known in each script

Data preparation (data_prep) list:

a_01_prepare_area_geometrical_data.R

a_02_prepare_street_geometrical_data.R (divided in 5 parts to parallel the process)

a_02_prepare_street_geometrical_data_collect.R (collects data from previous step)

a_03_prepare_census_data.R

a_04_prepare_311_data.R

a_04_prepare_noise_data.R

a_05_prepare_poi_data.R

a_06_prepare_open_streets_trans_altern_data.R

a_06_prepare_open_streets_data.R

Data exploration (data_exploration) list:

b_01_eda_noise_complaints.R

b_02_eda_open_streets.R

Model running (models) list:

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

Data (data) list:

demography

NYC boroughs - nybb.shp -  https://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page

geometry

buildings

NYC building footprints - geo_export_f7a89c9b-6561-41c9-b3a5-8114624ae6ba.shp - https://data.cityofnewyork.us/Housing-Development/Building-Footprints/nqwf-w8eh

streets

NYC streets - lion.gdb - https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-lion.page
