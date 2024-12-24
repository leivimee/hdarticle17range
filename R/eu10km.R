#' EEA reference grids (10 km) of member states
#'
#' A simple feature collection containing 10 km EEA reference grid cells covering all member states
#'
#' @format A simple feature collection with 150446 observations and 1 field:
#' \describe{
#'   \item{CELLCODE}{10 km cell code, character}
#' }
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' library(sf)
#' data(eu10km)
#' data(ms10kmcells)
#' mscells <- unname(unlist(select(subset(ms10kmcells, ms=="EE"),CELLCODE)))
#' ggplot(subset(eu10km, CELLCODE %in% mscells))+
#'   geom_sf(fill=NA)+
#'   theme_void()
#' @source https://sdi.eea.europa.eu/catalogue/srv/api/records/3c362237-daa4-45e2-8c16-aaadfb1a003b
#' @docType data
#' @keywords datasets
#' @name eu10km
#' @usage data(eu10km)
#' @export
#' data(eu10km)
"eu10km"
