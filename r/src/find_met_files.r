#' find_met_files searches for meteorological data files
#' @author Ben Fasoli
#'
#' Searches for available meteorological files matching the given strftime
#' compatible file naming convention
#'
#' @param t_start time of simulation start
#' @param met_file_format strftime compatible file naming convention to identify
#'   meteorological data files necessary for the timing of the simulation
#'   indicated by \code{t_start} and \code{n_hours}
#' @param n_hours number of hours to run each simulation; negative indicates
#'   backward in time
#' @param met_loc directory to find meteorological data
#'
#' @import dplyr
#' @export

find_met_files <- function(t_start, met_file_format, n_hours, met_loc) {
  require(dplyr)

  request <-  c(t_start %>% as.POSIXct(tz='UTC')) %>%
    c(. + n_hours * 3600) %>%
    range() %>%
    (function(x) seq(x[1], x[2], by = 'hour')) %>%
    strftime(tz = 'UTC', format = met_file_format)

  available <- lapply(request, function(x)
    dir(met_loc, pattern = x, full.names = T))
  available <- do.call(c, available)

  return(available)
}