# open_streets_environ_noise
Repository for reviewing the code of the project Unintended Impacts of Open Streets on noise complaints in NYC

note: please run init_directory_structure.R first to create folders. Also run this script before doing anything else, currently done via source(paste0(project.folder,'init_directory_structure.R'), to ensure that the folder locations are known in each script

## Code and data generated (file name - short description)

### Data preparation (data_prep) list:

a_01_prepare_area_geometrical_data.R - estimate geometrical parameters by area of 250 m x 250 m

- nyc_neigh_regions.rds - geometrical parameters (e.g. building density) at 250 m x 250 m resolution 

a_02_prepare_street_geometrical_data.R (time consuming: divided in 5 scripts to run in parallel, the first one is documented) - geometrical parameters (e.g. street width) at each street segment

- lion_streets_simp.rds - simplified version of the lion street segment dataset

a_02_prepare_street_geometrical_data_collect.R (collects data from previous step) 

- streets_nyc_geom_street.rds - geometrical parameters at each street segment

a_03_prepare_census_data.R - obtain sociodemographic information and put it together with geometrical parameters at census tract level 

- census_tracts_ses.rds - socio-demographic and geometrical parameter data at census tract level

a_04_prepare_311_data.R - filter noise complaints from 311 starting 2019 and save to r object

- nyc_311_noise_calls_2019_present.rds - noise complaints from 311 starting 2019

a_04_prepare_noise_data.R - clean noise complaint dataset and prepare for the analysis

- noise_prep.rds - noise complaint dataset 

a_05_prepare_poi_data.R - prepare dataset on points of interest and open restaurants per census tract

- open_restaurants_nyc_nas.rds - open restaurant dataset after geocoding (i.e. obtaining coordinates from addresses)

- poi_nyc.rds - at each census tract, number of POIs and open restaurant ready for analysis

a_06_prepare_open_streets_trans_altern_data.R - prepare open streets transportation alternatives data

- open_streets_imp_intermediate.rds - open streets by transportation alternatives after geocoding addresses to coordinates

- open_streets_ta_point.rds - open streets by transportation alternatives dataset after cleaning and converting to spatial object, ready for analysis

a_06_prepare_open_streets_data.R - prepare open streets dataset for main analysis putting together both NYC DOT and Transportation Alternatives data

- cns_trct_open_streets.rds - presence (ever) of open streets given NYC DOT dataset or Transportation Alternatives dataset 

- op_st_presence_df.rds - daily presence of open streets in each census tract

- op_st_perc_area_df.rds - daily proportion of area covered by open streets in each census tract

- open_streets_prep.rds - open street dataset ready for analysis including temporal variables

### Data exploration (data_exploration) list including tables/figures:

b_01_eda_noise_complaints.R - exploratory data analysis of noise complaints

- Table 1, Figure 1a, Figure 1c, Table 2

b_02_eda_open_streets.R - exploratory data analysis of open streets

- Figure 2, Table 2, Figure 1b, Figure 1d

### Model running (models) list including tables/figures:

c_01_model_street_sidewalk_main_s5.R - street_sidewalk main analysis (this script is better documented than those below in the code lines that are shared, which are most of them)

c_02_model_vehicle_main_s5.R - vehicle main analysis

c_03_model_street_sidewalk_s4.R - street_sidewalk model from main analysis with 4 knots in area covered by open streets

c_04_model_vehicle_s4.R - vehicle model from main analysis with 4 knots in area covered by open streets

c_05_model_street_sidewalk_s3.R - street_sidewalk model from main analysis with 3 knots in area covered by open streets

c_06_model_vehicle_s3.R - vehicle model from main analysis with 3 knots in area covered by open streets

c_07_model_street_sidewalk_trans_altern.R - street_sidewalk model from main analysis using open streets from transportation alternatives instead of NYC DOT 

c_08_model_vehicle_trans_altern.R - vehicle model from main analysis using open streets from transportation alternatives instead of NYC DOT 

c_09_model_street_sidewalk_open_rest.R - street_sidewalk model from main analysis adding open restaurants as covariate

c_10_model_vehicle_open_rest.R - vehicle model from main analysis adding open restaurants as covariate

c_11_model_street_sidewalk_poi.R - street_sidewalk model from main analysis adding POIs as covariate

c_12_model_vehicle_poi.R - vehicle model from main analysis adding POIs as covariate

c_13_model_street_sidewalk_spatial.R - street_sidewalk model from main analysis adding spatial term

c_14_model_vehicle_spatial.R - vehicle model from main analysis adding spatial term

c_15_analysis_model_res.R - collects and summarizes results 

- Figure 3, Figure 4, Figure S1, Figure S2, Figure S3

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













