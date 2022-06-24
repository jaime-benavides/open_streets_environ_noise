# aim: collects and summarizes results

# First step to load packages etc.
rm(list=ls())

# declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

## read model results data
# main analysis
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5.rds"))
# main analysis with 4 knots
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s4 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s4.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s4 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s4.rds"))
# main analysis with 3 knots
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s3 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s3.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s3 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s3.rds"))
# comparing AIC 5 vs. 4 knots
AIC(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$mer, all_openstreets_all_cnstract_trad_street_sidewalk_interv_s4$mer)
AIC(all_openstreets_all_cnstract_trad_vehicle_interv_s5$mer, all_openstreets_all_cnstract_trad_vehicle_interv_s4$mer)
# comparing AIC 5 vs. 3 knots
AIC(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$mer, all_openstreets_all_cnstract_trad_street_sidewalk_interv_s3$mer)
AIC(all_openstreets_all_cnstract_trad_vehicle_interv_s5$mer, all_openstreets_all_cnstract_trad_vehicle_interv_s3$mer)
# sensitivity analysis: adding POIs
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_poi <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5_poi.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5_poi <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5_poi.rds"))
# sensitivity analysis: adding open restaurants
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_op_rest <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5_op_rest.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5_op_rest <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5_op_rest.rds"))
# sensitivity analysis: adding spatial term
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_sp <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5_sp.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5_sp <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5_sp.rds"))
# sensitivity analysis: using transportation alternatives open streets
implem_all_cnstract_trad_street_sidewalk_interv_s5 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_perc_area_s5.rds"))
implem_all_cnstract_trad_vehicle_interv_s5 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_perc_area_s5.rds"))

# create plots 
mynamestheme <- theme(
  plot.title = element_text(family = "Helvetica", hjust = 0.5, size = (18)),
  axis.title = element_text(family = "Helvetica", size = (15)),
  axis.text = element_text(family = "Helvetica", size = (12))
)
# configure plots
# general config
sm <- "s(perc_area)"
x_name <- "Open Streets area (%)"
y_name <- "Noise complaints ratio"

# manuscript Figure 3
## main analysis
# Street/Sidewalk / main analysis
name_plot <- "Street/Sidewalk"
mod <- all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam
ci_col <- "blue"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# Vehicle / main analysis
name_plot <- "Vehicle"
mod <- all_openstreets_all_cnstract_trad_vehicle_interv_s5$gam
ci_col <- "orange"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_s5_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

## sensitivity analysis
# manuscript Figure 4
# active open streets by transportation alternatives
# street-sidewalk
name_plot <- "Street/Sidewalk"
mod <- implem_all_cnstract_trad_street_sidewalk_interv_s5$gam
ci_col <- "blue"
png(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_s5_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# vehicle
name_plot <- "Vehicle"
mod <- implem_all_cnstract_trad_vehicle_interv_s5$gam
ci_col <- "orange"
png(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_s5_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# manuscript Figure S1
## adding POIs
# Street/Sidewalk 
name_plot <- "Street/Sidewalk"
mod <- all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_poi$gam
ci_col <- "blue"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_poi_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# vehicle
name_plot <- "Vehicle"
mod <- all_openstreets_all_cnstract_trad_vehicle_interv_s5_poi$gam
ci_col <- "orange"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_s5_poi_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# manuscript Figure S2
## adding open restaurants
# Street/Sidewalk 
name_plot <- "Street/Sidewalk"
mod <- all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_op_rest$gam
ci_col <- "blue"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_op_rest_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# vehicle
name_plot <- "Vehicle"
mod <- all_openstreets_all_cnstract_trad_vehicle_interv_s5_op_rest$gam
ci_col <- "orange"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_s5_op_rest_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# manuscript Figure S3
## adding spatial term
# Street/Sidewalk 
name_plot <- "Street/Sidewalk"
mod <- all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_sp$gam
ci_col <- "blue"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_sp_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()

# vehicle
name_plot <- "Vehicle"
mod <- all_openstreets_all_cnstract_trad_vehicle_interv_s5_sp$gam
ci_col <- "orange"
png(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_s5_sp_res.png"), 900, 460)
gratia::draw(mod,
             select = sm, fun = exp, 
             ci_col = ci_col) &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 20)) & 
  scale_x_continuous(expand = c(0, 0)) & 
  ggtitle(name_plot) & 
  xlab(x_name) & 
  ylab(y_name) & 
  theme_bw() &
  mynamestheme
dev.off()
