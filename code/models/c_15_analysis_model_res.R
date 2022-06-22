# aim: collects and summarizes results

# First step to load packages etc.
rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'init_directory_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

# load data used to run models


# read model results data

all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5.rds"))

all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_poi <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5_poi.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5_poi <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5_poi.rds"))

all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_op_rest <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5_op_rest.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5_op_rest <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5_op_rest.rds"))

all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_sp <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s5_sp.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s5_sp <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s5_sp.rds"))


all_openstreets_all_cnstract_trad_street_sidewalk_interv_s4 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_perc_area_s4.rds"))
all_openstreets_all_cnstract_trad_vehicle_interv_s4 <- readRDS(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_perc_area_s4.rds"))

AIC(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$mer, all_openstreets_all_cnstract_trad_street_sidewalk_interv_s4$mer)
AIC(all_openstreets_all_cnstract_trad_vehicle_interv_s5$mer, all_openstreets_all_cnstract_trad_vehicle_interv_s4$mer)

implem_all_cnstract_trad_street_sidewalk_interv_s5 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_perc_area_s5.rds"))
implem_all_cnstract_trad_vehicle_interv_s5 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_perc_area_s5.rds"))


implem_all_cnstract_trad_street_sidewalk_interv_s4 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_perc_area_s4.rds"))
implem_all_cnstract_trad_vehicle_interv_s4 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_perc_area_s4.rds"))

AIC(implem_all_cnstract_trad_street_sidewalk_interv_s5$mer, implem_all_cnstract_trad_street_sidewalk_interv_s4$mer)
AIC(implem_all_cnstract_trad_vehicle_interv_s5$mer, implem_all_cnstract_trad_vehicle_interv_s4$mer)

plot(summary(implem_all_cnstract_trad_street_sidewalk_interv_s5$mer)$residuals, ylab = "Residuals", pch = 20)

# start plotting
png(paste0(output.folder, "res_fitted_plot_all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5.png"), 900, 460)
par(mfrow = c(2, 2))           # display plots in 2 rows and 2 columns
plot(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$mer, pch = 20, col = "black", lty = "dotted"); par(mfrow = c(1, 1))
dev.off()

png(paste0(output.folder, "normal_qq_plot_all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5.png"), 900, 460)
qqnorm(resid(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$mer))
qqline(resid(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$mer))
dev.off()

png(paste0(output.folder, "res_fitted_plot_all_openstreets_all_cnstract_trad_vehicle_interv_s5.png"), 900, 460)
par(mfrow = c(2, 2))           # display plots in 2 rows and 2 columns
plot(all_openstreets_all_cnstract_trad_vehicle_interv_s5$mer, pch = 20, col = "black", lty = "dotted"); par(mfrow = c(1, 1))
dev.off()

png(paste0(output.folder, "normal_qq_plot_all_openstreets_all_cnstract_trad_vehicle_interv_s5.png"), 900, 460)
qqnorm(resid(all_openstreets_all_cnstract_trad_vehicle_interv_s5$mer))
qqline(resid(all_openstreets_all_cnstract_trad_vehicle_interv_s5$mer))
dev.off()


png(paste0(output.folder, "res_fitted_plot_implem_all_cnstract_trad_street_sidewalk_interv_s5.png"), 900, 460)
par(mfrow = c(2, 2))           # display plots in 2 rows and 2 columns
plot(implem_all_cnstract_trad_street_sidewalk_interv_s5$mer, pch = 20, col = "black", lty = "dotted"); par(mfrow = c(1, 1))
dev.off()

png(paste0(output.folder, "normal_qq_plot_implem_all_cnstract_trad_street_sidewalk_interv_s5.png"), 900, 460)
qqnorm(resid(implem_all_cnstract_trad_street_sidewalk_interv_s5$mer))
qqline(resid(implem_all_cnstract_trad_street_sidewalk_interv_s5$mer))
dev.off()

png(paste0(output.folder, "res_fitted_plot_implem_all_cnstract_trad_vehicle_interv_s5.png"), 900, 460)
par(mfrow = c(2, 2))           # display plots in 2 rows and 2 columns
plot(implem_all_cnstract_trad_vehicle_interv_s5$mer, pch = 20, col = "black", lty = "dotted"); par(mfrow = c(1, 1))
dev.off()

png(paste0(output.folder, "normal_qq_plot_implem_all_cnstract_trad_vehicle_interv_s5.png"), 900, 460)
qqnorm(resid(implem_all_cnstract_trad_vehicle_interv_s5$mer))
qqline(resid(implem_all_cnstract_trad_vehicle_interv_s5$mer))
dev.off()
# Anova(implem_all_cnstract_trad_street_sidewalk_interv_s5$mer, test = "Chi")
# models with 4 degrees of freedom produce a lower AIC

# implem_all_cnstract_trad_street_sidewalk_interv_s3 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_perc_area_s3.rds"))
# implem_all_cnstract_trad_vehicle_interv_s3 <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_perc_area_s3.rds"))


# poi's
# implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc <- readRDS(paste0(output.folder, "implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc.rds"))
# implem_activeos_cnstract_trad_vehicle_interv_poi_nyc <- readRDS(paste0(output.folder, "implem_activeos_cnstract_trad_vehicle_interv_poi_nyc.rds"))
# 
# 
# implem_all_cnstract_trad_street_sidewalk_interv_rest_activ <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_rest_activ.rds"))
# implem_all_cnstract_trad_vehicle_interv_rest_activ <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_rest_activ.rds"))
# 
# implem_all_cnstract_trad_street_sidewalk_interv_safegraph <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_safegraph.rds"))
# implem_all_cnstract_trad_vehicle_interv_safegraph <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_safegraph.rds"))
# 
# implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc.rds"))
# implem_all_cnstract_trad_vehicle_interv_poi_nyc <- readRDS(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_poi_nyc.rds"))

# create a table with estimate / std.error 

# os <- "all_openstreets"
# cns_tct <- "all_cnstract"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence"
# estimate <- round(all_openstreets_all_cnstract_trad_vehicle$summary$p.coeff["presence"],3)   
# st.err <- round(all_openstreets_all_cnstract_trad_vehicle$summary$se["presence"],3)
# exp_estim <- all_openstreets_all_cnstract_trad_vehicle$exp_coeff["presence",]
# 
# all_openstreets_all_cnstract_trad_vehicle_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "all_openstreets"
# cns_tct <- "all_cnstract"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence"
# estimate <- round(all_openstreets_all_cnstract_trad_street_sidewalk$summary$p.coeff["presence"],3)   
# st.err <- round(all_openstreets_all_cnstract_trad_street_sidewalk$summary$se["presence"],3)
# exp_estim <- all_openstreets_all_cnstract_trad_street_sidewalk$exp_coeff["presence",]
# 
# all_openstreets_all_cnstract_trad_street_sidewalk_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)

png(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5_res.png"), 900, 460)
plot(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam, ylim=c(-2,2), pages = 1)
dev.off()

png(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_s5_res.png"), 900, 460)
plot(implem_all_cnstract_trad_street_sidewalk_interv_s5$gam, ylim=c(-2,2), pages = 1)
dev.off()

png(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_s5_res.png"), 900, 460)
plot(all_openstreets_all_cnstract_trad_vehicle_interv_s5$gam, ylim=c(-2,2), pages = 1)
dev.off()

png(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_s5_res.png"), 900, 460)
plot(implem_all_cnstract_trad_vehicle_interv_s5$gam, ylim=c(-2,2), pages = 1)
dev.off()

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

# sensitivity analysis
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
# adding poi
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

# adding open restaurants
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

# adding spatial term
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

gratia::draw(implem_all_cnstract_trad_street_sidewalk_interv_s5$gam,
             select = "s(perc_area)", fun = exp, 
             ci_col = "blue") &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  lims(y = c(0, 20)) & 
  theme_bw()

gratia::draw(implem_all_cnstract_trad_vehicle_interv_s5$gam,
             select = "s(perc_area)", fun = exp, 
             ci_col = "orange") &  geom_hline(yintercept=1, linetype="dashed", color = "grey", size = 1.5) & 
  lims(y = c(0, 20)) & 
  theme_bw()


test <- gratia::compare_smooths(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam, 
                all_openstreets_all_cnstract_trad_vehicle_interv_s5$gam, 
                smooths = "s(perc_area)")
gratia::draw(test, fun = exp, guides = "auto")


plot(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam, ylim=c(-2,2), pages = 1)
str(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam)
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam$smooth $UZ
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam$fitted.values
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam$model$perc_area
all_openstreets_all_cnstract_trad_street_sidewalk_interv_s5$gam$smooth
# 
# # save by hand
# 
# png(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_s4_res.png"), 900, 460)
# plot(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s4$model, ylim=c(-2,2), pages = 1)
# dev.off()
# 
# png(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_s4_res.png"), 900, 460)
# plot(all_openstreets_all_cnstract_trad_vehicle_interv_s4$model, ylim=c(-2,2), pages = 1)
# dev.off()
# 
# png(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_s4_res.png"), 900, 460)
# plot(implem_all_cnstract_trad_street_sidewalk_interv_s4$model, ylim=c(-2,2), pages = 1)
# dev.off()
# 
# png(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_s4_res.png"), 900, 460)
# plot(implem_all_cnstract_trad_vehicle_interv_s4$model, ylim=c(-2,2), pages = 1)
# dev.off()
# 
# png(paste0(output.folder, "all_openstreets_all_cnstract_trad_street_sidewalk_interv_s3_res.png"), 900, 460)
# plot(all_openstreets_all_cnstract_trad_street_sidewalk_interv_s3$model, ylim=c(-2,2), pages = 1)
# dev.off()
# 
# png(paste0(output.folder, "all_openstreets_all_cnstract_trad_vehicle_interv_s3_res.png"), 900, 460)
# plot(all_openstreets_all_cnstract_trad_vehicle_interv_s3$model, ylim=c(-2,2), pages = 1)
# dev.off()
# 
# png(paste0(output.folder, "implem_all_cnstract_trad_street_sidewalk_interv_s3_res.png"), 900, 460)
# plot(implem_all_cnstract_trad_street_sidewalk_interv_s3$model, ylim=c(-2,2), pages = 1)
# dev.off()
# 
# png(paste0(output.folder, "implem_all_cnstract_trad_vehicle_interv_s3_res.png"), 900, 460)
# plot(implem_all_cnstract_trad_vehicle_interv_s3$model, ylim=c(-2,2), pages = 1)
# dev.off()


os <- "all_openstreets"
cns_tct <- "all_cnstract"
noise_comp <- "street_sidewalk"
method <- "traditional"
variable <- "presence_when_interv"
estimate <- round(all_openstreets_all_cnstract_trad_street_sidewalk_interv_lin$summary$p.coeff["perc_area"],3)   
st.err <- round(all_openstreets_all_cnstract_trad_street_sidewalk_interv_lin$summary$se["perc_area"],3)
exp_estim <- all_openstreets_all_cnstract_trad_street_sidewalk_interv_lin$exp_coeff["perc_area",]

all_openstreets_all_cnstract_trad_street_sidewalk_interv_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)

os <- "all_openstreets"
cns_tct <- "all_cnstract"
noise_comp <- "vehicle"
method <- "traditional"
variable <- "presence_when_interv"
estimate <- round(all_openstreets_all_cnstract_trad_vehicle_interv_lin$summary$p.coeff["perc_area"],3)   
st.err <- round(all_openstreets_all_cnstract_trad_vehicle_interv_lin$summary$se["perc_area"],3)
exp_estim <- all_openstreets_all_cnstract_trad_vehicle_interv_lin$exp_coeff["perc_area",]

all_openstreets_all_cnstract_trad_vehicle_interv_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)


# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence"
# estimate <- round(implem_all_cnstract_trad_vehicle$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_vehicle$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_vehicle$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_vehicle_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence"
# estimate <- round(implem_all_cnstract_trad_street_sidewalk$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_street_sidewalk$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_street_sidewalk$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_street_sidewalk_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)

os <- "implem"
cns_tct <- "all_cnstract"
noise_comp <- "street_sidewalk"
method <- "traditional"
variable <- "presence_when_interv"
estimate <- round(implem_all_cnstract_trad_street_sidewalk_interv$summary$p.coeff["presence"],3)   
st.err <- round(implem_all_cnstract_trad_street_sidewalk_interv$summary$se["presence"],3)
exp_estim <- implem_all_cnstract_trad_street_sidewalk_interv$exp_coeff["presence",]

implem_all_cnstract_trad_street_sidewalk_interv_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)

os <- "implem"
cns_tct <- "all_cnstract"
noise_comp <- "vehicle"
method <- "traditional"
variable <- "presence_when_interv"
estimate <- round(implem_all_cnstract_trad_vehicle_interv$summary$p.coeff["presence"],3)   
st.err <- round(implem_all_cnstract_trad_vehicle_interv$summary$se["presence"],3)
exp_estim <- implem_all_cnstract_trad_vehicle_interv$exp_coeff["presence",]

implem_all_cnstract_trad_vehicle_interv_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)


# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence_when_interv_rest_activ"
# estimate <- round(implem_all_cnstract_trad_street_sidewalk_interv_rest_activ$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_street_sidewalk_interv_rest_activ$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_street_sidewalk_interv_rest_activ$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_street_sidewalk_interv_rest_activ_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence_when_interv_rest_activ"
# estimate <- round(implem_all_cnstract_trad_vehicle_interv_rest_activ$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_vehicle_interv_rest_activ$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_vehicle_interv_rest_activ$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_vehicle_interv_rest_activ_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence_when_interv_safegraph"
# estimate <- round(implem_all_cnstract_trad_street_sidewalk_interv_safegraph$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_street_sidewalk_interv_safegraph$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_street_sidewalk_interv_safegraph$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_street_sidewalk_interv_safegraph_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence_when_interv_safegraph"
# estimate <- round(implem_all_cnstract_trad_vehicle_interv_safegraph$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_vehicle_interv_safegraph$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_vehicle_interv_safegraph$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_vehicle_interv_safegraph_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence_when_interv_poi_nyc"
# estimate <- round(implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "all_cnstract"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence_when_interv_poi_nyc"
# estimate <- round(implem_all_cnstract_trad_vehicle_interv_poi_nyc$summary$p.coeff["presence"],3)   
# st.err <- round(implem_all_cnstract_trad_vehicle_interv_poi_nyc$summary$se["presence"],3)
# exp_estim <- implem_all_cnstract_trad_vehicle_interv_poi_nyc$exp_coeff["presence",]
# 
# implem_all_cnstract_trad_vehicle_interv_poi_nyc_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence_when_interv_poi_nyc"
# estimate <- round(implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc$summary$p.coeff["presence"],3)   
# st.err <- round(implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc$summary$se["presence"],3)
# exp_estim <- implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc$exp_coeff["presence",]
# 
# implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence_when_interv_poi_nyc"
# estimate <- round(implem_activeos_cnstract_trad_vehicle_interv_poi_nyc$summary$p.coeff["presence"],3)   
# st.err <- round(implem_activeos_cnstract_trad_vehicle_interv_poi_nyc$summary$se["presence"],3)
# exp_estim <- implem_activeos_cnstract_trad_vehicle_interv_poi_nyc$exp_coeff["presence",]
# 
# implem_activeos_cnstract_trad_vehicle_interv_poi_nyc_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence"
# estimate <- round(implem_activeos_cnstract_trad_vehicle$summary$p.coeff["presence"],3)
# st.err <- round(implem_activeos_cnstract_trad_vehicle$summary$se["presence"],3)
# exp_estim <- implem_activeos_cnstract_trad_vehicle$exp_coeff["presence",]
# 
# implem_activeos_cnstract_trad_vehicle_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence"
# estimate <- round(implem_activeos_cnstract_trad_street_sidewalk$summary$p.coeff["presence"],3)
# st.err <- round(implem_activeos_cnstract_trad_street_sidewalk$summary$se["presence"],3)
# exp_estim <- implem_activeos_cnstract_trad_street_sidewalk$exp_coeff["presence",]
# 
# implem_activeos_cnstract_trad_street_sidewalk_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "presence_when_interv"
# estimate <- round(implem_activeos_cnstract_trad_street_sidewalk_interv$summary$p.coeff["presence"],3)
# st.err <- round(implem_activeos_cnstract_trad_street_sidewalk_interv$summary$se["presence"],3)
# exp_estim <- implem_activeos_cnstract_trad_street_sidewalk_interv$exp_coeff["presence",]
# 
# implem_activeos_cnstract_trad_street_sidewalk_interv_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "street_sidewalk"
# method <- "traditional"
# variable <- "intervened"
# estimate <- round(implem_activeos_cnstract_trad_street_sidewalk_interv$summary$p.coeff["intervened"],3)
# st.err <- round(implem_activeos_cnstract_trad_street_sidewalk_interv$summary$se["intervened"],3)
# exp_estim <- implem_activeos_cnstract_trad_street_sidewalk_interv$exp_coeff["intervened",]
# 
# implem_activeos_cnstract_trad_street_sidewalk_interv_var_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "presence_when_interv"
# estimate <- round(implem_activeos_cnstract_trad_vehicle_interv$summary$p.coeff["presence"],3)
# st.err <- round(implem_activeos_cnstract_trad_vehicle_interv$summary$se["presence"],3)
# exp_estim <- implem_activeos_cnstract_trad_vehicle_interv$exp_coeff["presence",]
# 
# implem_activeos_cnstract_trad_vehicle_interv_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "vehicle"
# method <- "traditional"
# variable <- "intervened"
# estimate <- round(implem_activeos_cnstract_trad_vehicle_interv$summary$p.coeff["intervened"],3)
# st.err <- round(implem_activeos_cnstract_trad_vehicle_interv$summary$se["intervened"],3)
# exp_estim <- implem_activeos_cnstract_trad_vehicle_interv$exp_coeff["intervened",]
# 
# implem_activeos_cnstract_trad_vehicle_interv_var_res <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "vehicle"
# method <- "diff_in_diff"
# variable <- "intercept"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$p.coeff["(Intercept)"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$se["(Intercept)"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_vehicle$exp_coeff["(Intercept)",]
# 
# implem_activeos_cnstract_diff_in_diff_vehicle_res_interc <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# 
# variable <- "treated"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$p.coeff["treated"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$se["treated"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_vehicle$exp_coeff["treated",]
# 
# implem_activeos_cnstract_diff_in_diff_vehicle_res_tr <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# variable <- "intervened"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$p.coeff["intervened"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$se["intervened"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_vehicle$exp_coeff["intervened",]
# 
# implem_activeos_cnstract_diff_in_diff_vehicle_res_int <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# variable <- "treated:intervened"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$p.coeff["treated:intervened"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_vehicle$summary$se["treated:intervened"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_vehicle$exp_coeff["treated:intervened",]
# 
# implem_activeos_cnstract_diff_in_diff_vehicle_res_treat_int <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# 
# os <- "implem"
# cns_tct <- "activeos"
# noise_comp <- "street_sidewalk"
# method <- "diff_in_diff"
# variable <- "intercept"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$p.coeff["(Intercept)"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$se["(Intercept)"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_street_sidewalk$exp_coeff["(Intercept)",]
# 
# implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_interc <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# 
# variable <- "treated"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$p.coeff["treated"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$se["treated"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_street_sidewalk$exp_coeff["treated",]
# 
# implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_tr <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# variable <- "intervened"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$p.coeff["intervened"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$se["intervened"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_street_sidewalk$exp_coeff["intervened",]
# 
# implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_int <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)
# 
# variable <- "treated:intervened"
# estimate <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$p.coeff["treated:intervened"],3)
# st.err <- round(implem_activeos_cnstract_diff_in_diff_street_sidewalk$summary$se["treated:intervened"],3)
# exp_estim <- implem_activeos_cnstract_diff_in_diff_street_sidewalk$exp_coeff["treated:intervened",]
# 
# implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_treat_int <- cbind(os, cns_tct, noise_comp, method, variable, estimate, st.err, exp_estim)

# sum_res <- rbind(
#   # implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc_res,
#   # implem_activeos_cnstract_trad_vehicle_interv_poi_nyc_res,
#   # implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_treat_int, implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_interc, implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_int, implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_tr,
#   # implem_activeos_cnstract_diff_in_diff_vehicle_res_treat_int, implem_activeos_cnstract_diff_in_diff_vehicle_res_interc, implem_activeos_cnstract_diff_in_diff_vehicle_res_int, implem_activeos_cnstract_diff_in_diff_vehicle_res_tr,
#   # implem_activeos_cnstract_trad_vehicle_interv_res,
#   # implem_activeos_cnstract_trad_street_sidewalk_interv_res,
#   # implem_activeos_cnstract_trad_street_sidewalk_res,
#   # implem_activeos_cnstract_trad_vehicle_res,
#       implem_all_cnstract_trad_vehicle_interv_res, 
#       implem_all_cnstract_trad_street_sidewalk_interv_res, 
#       # implem_all_cnstract_trad_street_sidewalk_res, 
#       # implem_all_cnstract_trad_vehicle_res, 
#       all_openstreets_all_cnstract_trad_vehicle_interv_res, 
#      all_openstreets_all_cnstract_trad_street_sidewalk_interv_res#,
#      #  all_openstreets_all_cnstract_trad_street_sidewalk_res, 
#      #  all_openstreets_all_cnstract_trad_vehicle_res, 
#      # implem_all_cnstract_trad_street_sidewalk_interv_rest_activ_res, 
#      # implem_all_cnstract_trad_vehicle_interv_rest_activ_res,
#      # implem_all_cnstract_trad_street_sidewalk_interv_safegraph_res,
#      # implem_all_cnstract_trad_vehicle_interv_safegraph_res,
#      # implem_all_cnstract_trad_vehicle_interv_poi_nyc_res,
#      # implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc_res
#       )
# colnames(sum_res)[c(1, 2, 3)] <- c("open streets", "census tracts", "noise type")
# 
# png(paste0(output.folder, "model_results_summary_table_all.png"), 900, 460)
# grid.table(sum_res, rows = NULL)
# dev.off()

## summarizing results by grouping experiments
# a: same dataset & different methods
# b: same method and different datasets

# b0 all census tracts, active Open Streets, including intervened (1 for 2021) vs. not including it


# sum_res <- rbind(
#   implem_all_cnstract_trad_vehicle_interv_res, 
#   implem_all_cnstract_trad_vehicle_res, 
#   implem_all_cnstract_trad_street_sidewalk_interv_res, 
#   implem_all_cnstract_trad_street_sidewalk_res 
# )
# colnames(sum_res)[c(1, 2, 3)] <- c("open streets", "census tracts", "noise type")
# 
# png(paste0(output.folder, "model_results_summary_table_b0_all_trcs_active_os_interv.png"), 800, 230)
# grid.table(sum_res, rows = NULL)
# dev.off()
# 
# 
vehicle_estim <- implem_all_cnstract_trad_vehicle_interv$exp_coeff
street_sidewalk_estim <- implem_all_cnstract_trad_street_sidewalk_interv$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65)

png(paste0(output.folder, "association_b0_all_trcs_active_os_interv.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("presence", "perc.pov", "perc.black", "perc.hisp",
                         "pop_dens", "area_density_plan", "intervened", "presence1", "perc.pov1", "perc.black1", "perc.hisp1",
                         "pop_dens1", "area_density_plan1", "intervened1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("presence", "intervened", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5,
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18))
fig_models_coeff
dev.off()
# 
# 
# vehicle_estim <- implem_all_cnstract_trad_vehicle$exp_coeff
# street_sidewalk_estim <- implem_all_cnstract_trad_street_sidewalk$exp_coeff
# 
# vehicle_estim$variable <- rownames(vehicle_estim)
# street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
# street_sidewalk_estim$noise_compl <- "street_sidewalk"
# vehicle_estim$noise_compl <- "vehicle"
# 
# estim <- rbind(vehicle_estim, street_sidewalk_estim)
# estim_presence <- estim
# pd <- position_dodge(width = 0.65) 
# 
# png(paste0(output.folder, "association_b0_all_trcs_active_os_non_interv.png"), 720, 390)
# fig_models_coeff <- estim %>%
#   filter(variable %in% c("presence", "perc.pov", "perc.black", "perc.hisp", 
#                          "pop_dens", "area_density_plan", "presence1", "perc.pov1", "perc.black1", "perc.hisp1", 
#                          "pop_dens1", "area_density_plan1")) %>%
#   dplyr::mutate(variable = factor(variable, levels = rev(c("presence", "intervened", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
#   ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
#   geom_hline(yintercept = 1, linetype = 2) +
#   geom_errorbar(aes(ymin = rr_2p5, 
#                     ymax = rr_97p5,
#                     color = noise_compl), width = 0.20, position = pd) +
#   geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
#   coord_flip()  +
#   #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
#   theme_minimal(base_size = 20) +
#   ylab("Estimate") +
#   xlab("") +
#   scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
#   theme(
#     axis.ticks.y=element_blank(),
#     axis.text.x = element_text(size = 16),
#     axis.title.x = element_text(vjust = -0.1),
#     axis.text.y = element_text(size = 16),
#     axis.title = element_text(size = 17),
#     #legend.position = "bottom",
#     #legend.title = element_blank(),
#     legend.text = element_text(size = 18)) 
# fig_models_coeff
# dev.off()

# b1 all census tracts, active open streets, vs. all open streets (Open Streets Program)

sum_res <- rbind(
  #implem_all_cnstract_trad_vehicle_interv_res, 
  all_openstreets_all_cnstract_trad_vehicle_interv_res, 
  #implem_all_cnstract_trad_street_sidewalk_interv_res, 
  all_openstreets_all_cnstract_trad_street_sidewalk_interv_res
)
colnames(sum_res)[c(1, 2, 3)] <- c("open streets", "census tracts", "noise type")
sum_res$variable <- "perc_area"
png(paste0(output.folder, "model_results_summary_table_b1_all_trcs_all_os_interv_rev01.png"), 800, 230)
grid.table(sum_res, rows = NULL)
dev.off()


vehicle_estim <- all_openstreets_all_cnstract_trad_vehicle_interv_lin$exp_coeff
street_sidewalk_estim <- all_openstreets_all_cnstract_trad_street_sidewalk_interv_lin$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65) 

png(paste0(output.folder, "association_b1_all_trcs_all_os_interv_rev.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("perc_area", "perc.pov", "perc.black", "perc.hisp", 
                         "pop_dens", "area_density_plan", "intervened", "perc_area1", "perc.pov1", "perc.black1", "perc.hisp1", 
                         "pop_dens1", "area_density_plan1", "intervened1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("perc_area", "intervened", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5, 
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18)) 
fig_models_coeff
dev.off()

# b2 all census tracts vs census tracts with active open streets, active open streets, intervened, poi nyc vs. non
implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc_res$POI <- "NYC POI's"
implem_all_cnstract_trad_vehicle_interv_poi_nyc_res$POI <- "NYC POI's"
implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc_res$POI <- "NYC POI's"
implem_activeos_cnstract_trad_vehicle_interv_poi_nyc_res$POI <- "NYC POI's"
implem_all_cnstract_trad_vehicle_interv_res$POI <- "none" 
implem_activeos_cnstract_trad_vehicle_interv_res$POI <- "none" 
implem_all_cnstract_trad_street_sidewalk_interv_res$POI <- "none" 
implem_activeos_cnstract_trad_street_sidewalk_interv_res$POI <- "none" 
sum_res <- rbind(
  implem_all_cnstract_trad_vehicle_interv_res, 
  implem_all_cnstract_trad_vehicle_interv_poi_nyc_res,
  implem_activeos_cnstract_trad_vehicle_interv_res, 
  implem_activeos_cnstract_trad_vehicle_interv_poi_nyc_res,
  implem_all_cnstract_trad_street_sidewalk_interv_res, 
  implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc_res,
  implem_activeos_cnstract_trad_street_sidewalk_interv_res,
  implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc_res
)
colnames(sum_res)[c(1, 2, 3)] <- c("open streets", "census tracts", "noise type")
sum_res$variable <- "presence"
sum_res <- sum_res[,c(1,2,3,4,11,5,6,7,8,9,10)]
png(paste0(output.folder, "model_results_summary_table_b2_all_trcs_vs_active_trcts_active_os_interv_poi_nyc.png"), 800, 230)
grid.table(sum_res, rows = NULL)
dev.off()


vehicle_estim <- implem_activeos_cnstract_trad_vehicle_interv$exp_coeff
street_sidewalk_estim <- implem_activeos_cnstract_trad_street_sidewalk_interv$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65) 

png(paste0(output.folder, "association_b2_active_trcts_active_os_interv.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("presence", "perc.pov", "perc.black", "perc.hisp", 
                         "pop_dens", "area_density_plan", "intervened", "presence1", "perc.pov1", "perc.black1", "perc.hisp1", 
                         "pop_dens1", "area_density_plan1", "intervened1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("presence", "intervened", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5, 
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18)) 
fig_models_coeff
dev.off()


vehicle_estim <- implem_activeos_cnstract_trad_vehicle_interv_poi_nyc$exp_coeff
street_sidewalk_estim <- implem_activeos_cnstract_trad_street_sidewalk_interv_poi_nyc$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65) 

png(paste0(output.folder, "association_b2_active_trcts_active_os_interv_poi_nyc.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("presence", "perc.pov", "perc.black", "perc.hisp", 
                         "pop_dens", "area_density_plan", "intervened", "poi_nyc", "presence1", "perc.pov1", "perc.black1", "perc.hisp1", 
                         "pop_dens1", "area_density_plan1", "intervened1", "poi_nyc1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("presence", "intervened", "poi_nyc", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5, 
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 4.5), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18)) 
fig_models_coeff
dev.off()


# b3 all census tracts, active open streets, intervened, adding poi/open restaurants

implem_all_cnstract_trad_vehicle_interv_res$POI <- "none"
implem_all_cnstract_trad_vehicle_interv_rest_activ_res$POI <- "Open Restaurants"
implem_all_cnstract_trad_vehicle_interv_safegraph_res$POI <- "Safegraph POI's"
implem_all_cnstract_trad_vehicle_interv_poi_nyc_res$POI <- "NYC POI's"
implem_all_cnstract_trad_street_sidewalk_interv_res$POI <- "none"
implem_all_cnstract_trad_street_sidewalk_interv_rest_activ_res$POI <- "Open Restaurants"
implem_all_cnstract_trad_street_sidewalk_interv_safegraph_res$POI <- "Safegraph POI's"
implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc_res$POI <- "NYC POI's"

sum_res <- rbind(
  implem_all_cnstract_trad_vehicle_interv_res, 
  implem_all_cnstract_trad_vehicle_interv_rest_activ_res,
  implem_all_cnstract_trad_vehicle_interv_safegraph_res,
  implem_all_cnstract_trad_vehicle_interv_poi_nyc_res,
  implem_all_cnstract_trad_street_sidewalk_interv_res, 
  implem_all_cnstract_trad_street_sidewalk_interv_rest_activ_res,
  implem_all_cnstract_trad_street_sidewalk_interv_safegraph_res,
  implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc_res
)
colnames(sum_res)[c(1, 2, 3)] <- c("open streets", "census tracts", "noise type")
sum_res$variable <- "presence"
sum_res <- sum_res[c(1,2,3,4,11,5,6,7,8,9,10)]
png(paste0(output.folder, "model_results_summary_table_b3_all_trcs_active_os_interv_pois.png"), 800, 230)
grid.table(sum_res, rows = NULL)
dev.off()


vehicle_estim <- implem_all_cnstract_trad_vehicle_interv_rest_activ$exp_coeff
street_sidewalk_estim <- implem_all_cnstract_trad_street_sidewalk_interv_rest_activ$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65) 

png(paste0(output.folder, "association_b3_all_trcts_active_os_interv_poi_open_rest.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("presence", "perc.pov", "perc.black", "perc.hisp", 
                         "pop_dens", "area_density_plan", "intervened", "open_restaurants", "presence1", "perc.pov1", "perc.black1", "perc.hisp1", 
                         "pop_dens1", "area_density_plan1", "intervened1", "open_restaurants1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("presence", "intervened", "open_restaurants", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5, 
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18)) 
fig_models_coeff
dev.off()


vehicle_estim <- implem_all_cnstract_trad_vehicle_interv_safegraph$exp_coeff
street_sidewalk_estim <- implem_all_cnstract_trad_street_sidewalk_interv_safegraph$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65) 

png(paste0(output.folder, "association_b3_all_trcts_active_os_interv_poi_safegraph.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("presence", "perc.pov", "perc.black", "perc.hisp", 
                         "pop_dens", "area_density_plan", "intervened", "poi_safegraph", "presence1", "perc.pov1", "perc.black1", "perc.hisp1", 
                         "pop_dens1", "area_density_plan1", "intervened1", "poi_safegraph1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("presence", "intervened", "poi_safegraph", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5, 
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18)) 
fig_models_coeff
dev.off()

vehicle_estim <- implem_all_cnstract_trad_vehicle_interv_poi_nyc$exp_coeff
street_sidewalk_estim <- implem_all_cnstract_trad_street_sidewalk_interv_poi_nyc$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65) 

png(paste0(output.folder, "association_b3_all_trcts_active_os_interv_poi_nyc.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("presence", "perc.pov", "perc.black", "perc.hisp", 
                         "pop_dens", "area_density_plan", "intervened", "poi_nyc", "presence1", "perc.pov1", "perc.black1", "perc.hisp1", 
                         "pop_dens1", "area_density_plan1", "intervened1", "poi_nyc1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("presence", "intervened", "poi_nyc", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5, 
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18)) 
fig_models_coeff
dev.off()

# a1 active open streets census tracts, active open streets, intervened, traditional vs. diff-in-diff
implem_activeos_cnstract_trad_vehicle_interv_res$variable <- "presence"
implem_activeos_cnstract_trad_street_sidewalk_interv_res$variable <- "presence"
sum_res <- rbind(
  implem_activeos_cnstract_trad_vehicle_interv_res, 
  implem_activeos_cnstract_trad_vehicle_interv_var_res,
  implem_activeos_cnstract_diff_in_diff_vehicle_res_interc,
  implem_activeos_cnstract_diff_in_diff_vehicle_res_tr,
  implem_activeos_cnstract_diff_in_diff_vehicle_res_int, 
  implem_activeos_cnstract_diff_in_diff_vehicle_res_treat_int,
  implem_activeos_cnstract_trad_street_sidewalk_interv_res,
  implem_activeos_cnstract_trad_street_sidewalk_interv_var_res,
  implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_interc,
  implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_tr,
  implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_int, 
  implem_activeos_cnstract_diff_in_diff_street_sidewalk_res_treat_int
)
colnames(sum_res)[c(1, 2, 3)] <- c("open streets", "census tracts", "noise type")

png(paste0(output.folder, "model_results_summary_table_a1_active_tracts_active_os_interv_diff_in_diff.png"), 800, 350)
grid.table(sum_res, rows = NULL)
dev.off()


vehicle_estim <- implem_activeos_cnstract_diff_in_diff_vehicle$exp_coeff
street_sidewalk_estim <- implem_activeos_cnstract_diff_in_diff_street_sidewalk$exp_coeff

vehicle_estim$variable <- rownames(vehicle_estim)
street_sidewalk_estim$variable <- rownames(street_sidewalk_estim)
street_sidewalk_estim$noise_compl <- "street_sidewalk"
vehicle_estim$noise_compl <- "vehicle"

estim <- rbind(vehicle_estim, street_sidewalk_estim)
estim_presence <- estim
pd <- position_dodge(width = 0.65) 

png(paste0(output.folder, "association_a1_active_tracts_active_os_interv_diff_in_diff.png"), 720, 390)
fig_models_coeff <- estim %>%
  filter(variable %in% c("perc.pov", "perc.black", "perc.hisp", 
                         "pop_dens", "area_density_plan", "(Intercept)", "treated", "intervened", "treated:intervened",  "perc.pov1", "perc.black1", "perc.hisp1", 
                         "pop_dens1", "area_density_plan1", "(Intercept)1", "treated1", "intervened1", "treated:intervened1")) %>%
  dplyr::mutate(variable = factor(variable, levels = rev(c("(Intercept)", "treated", "intervened", "treated:intervened", "pop_dens", "area_density_plan", "perc.pov", "perc.hisp", "perc.black")))) %>%
  ggplot(aes(x = variable, y = rr_mean, ymin = rr_2p5, ymax = rr_97p5)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_errorbar(aes(ymin = rr_2p5, 
                    ymax = rr_97p5,
                    color = noise_compl), width = 0.20, position = pd) +
  geom_pointrange(aes(color = noise_compl), size = 0.3, position = pd) +
  coord_flip()  +
  #scale_y_continuous(trans=log2_trans(), limits = c(0.84, 1.11), breaks = seq(.85, 1.10, by = 0.05)) +
  theme_minimal(base_size = 20) +
  ylab("Estimate") +
  xlab("") +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 2, by = 0.5)) +
  theme(
    axis.ticks.y=element_blank(),
    axis.text.x = element_text(size = 16),
    axis.title.x = element_text(vjust = -0.1),
    axis.text.y = element_text(size = 16),
    axis.title = element_text(size = 17),
    #legend.position = "bottom",
    #legend.title = element_blank(),
    legend.text = element_text(size = 18)) 
fig_models_coeff
dev.off()

