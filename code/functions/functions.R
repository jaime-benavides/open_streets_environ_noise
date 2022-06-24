# Supporting functions

# estimate area geometrical parameters
estimate_geom_param  <- function(reg_pos) { # reg_pos stands for region position (index)
  # set a region within the spatial_context to work on (named sp_context)
  sp_context <- spatial_context[reg_pos[1],] # multiapply:apply gives in this step the different grid cells to the function using the index at reg_pos
  # intersect NYC buildings with new sp_context
  buildings_context <- sf::st_intersection(buildings, sp_context)
  if (nrow(buildings_context) == 0) {buildings_context <- data.frame()}
  if(nrow(buildings_context) > 0) { # when there are buildings in the grid cell, estimate the following
    mean_height <- mean(buildings_context$height, na.rm = TRUE)
    # this is (planar) building density estimated by area of buildings / area in grid cell
    area_density_plan <- as.numeric(sum(sf::st_area(buildings_context)) / sf::st_area(sp_context))
    max_height <- max(buildings_context$height, na.rm = TRUE)
    if(nrow(buildings_context) > 1) {
      sd_height <- sd(buildings_context$height, na.rm = TRUE)
    } else{
      sd_height <- 0
    }
  } else {
    # if there are no buildings assign zero values to geometrical parameters
    mean_height <- 0
    area_density_plan <- 0
    sd_height <- 0
    max_height  <- 0
  }
  # build data structure for the output as: index, geometrical parameters
  reg_cum <- c(reg_pos[1], mean_height,  area_density_plan,  sd_height, max_height)
  return(reg_cum)
}

# this function build rectangular buffers on each side of the street segment with a given width 
two_buf <- function(line,width,minEx){
  Buf0 <- rgeos::gBuffer(line,width=minEx,capStyle="SQUARE")
  Buf1 <- rgeos::gBuffer(line,width=width,capStyle="FLAT")
  return(sp::disaggregate(rgeos::gDifference(Buf1,Buf0)))
}

# solution from https://stackoverflow.com/questions/35186694/r-left-outer-join-with-0-fill-instead-of-na-while-preserving-valid-nas-in-left
left_join0 <- function(x, y, fill = 0L, ...){
  z <- dplyr::left_join(x, y, ...)
  new_cols <- setdiff(names(z), names(x))
  z <- tidyr::replace_na(z, setNames(as.list(rep(fill, length(new_cols))), new_cols))
  z
}

# summarize frequentist results  (from Robbie)
summarise_mod_freq = function(mod.freq){
  
  rr.mean = exp(mod.freq$coefficients)
  rr.uncertainty = exp(confint.default(mod.freq))
  dat.results.freq = data.frame(rr_2p5=round(rr.uncertainty[,1],2),
                                rr_mean=round(rr.mean,2),
                                rr_97p5=round(rr.uncertainty[,2], 2))
  return(dat.results.freq)
}


# assign a receptor to its closest road given a set of roads and receptors
point_to_line <- function(lines = roads, points = receptors) {
  collector <- as.data.frame(setNames(replicate(length(points),numeric(0), simplify = F), c(1:length(points))))
  collector[1:length(lines), ] <- rep(NA, length(lines))
  point_near_line <- integer(length(points))
  min_dist <- numeric(length(points))
  point_near_line_2 <- integer(length(points))
  min_dist_2 <- numeric(length(points))
  for (r in seq_along(points)) {
  collector[, r] <- rgeos::gDistance(points[r,], lines, byid = TRUE)
  point_near_line[r] <- which(collector[, r] == min(collector[, r]))
  min_dist[r] <- round(collector[point_near_line[r], r], 3)
  if(length(collector[, r][collector[, r]!=min(collector[, r])]) > 0){
  point_near_line_2[r] <- which(collector[, r] == min( collector[, r][collector[, r]!=min(collector[, r])] ))
  min_dist_2[r] <- round(collector[point_near_line_2[r], r], 3)
  } else {
    point_near_line_2[r] <- NA
    min_dist_2[r] <- NA
  }
  }
  min_dist_road <- data.frame(point_near_line, min_dist, point_near_line_2, min_dist_2)
  return(min_dist_road)
}
