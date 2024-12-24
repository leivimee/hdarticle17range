#' EEA reference grids (10 km) of member states
#'
#' This dataset holds the corresponding 10 km grid cell codes of each member state.
#'
#' @format A data frame with 165990 observations and 2 fields:
#' \describe{
#'   \item{ms}{Two-digit member state code, character}
#'   \item{CELLCODE}{10 km cell code, character}
#' }
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
#' @name ms10kmcells
#' @usage data(ms10kmcells)
#' @export
#' data(ms10kmcells)
"ms10kmcells"
