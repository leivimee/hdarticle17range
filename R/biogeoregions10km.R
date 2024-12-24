#' EEA refecence grid (10 km) of biogeographic regions
#'
#' This dataset consists of 10 km grid cells intersecting each biogeographic region.
#'
#' @format A data frame of 259033 observations and the following 2 variables:
#' \describe{
#'   \item{region}{Region code, character}
#'   \item{CELLCODE}{10 km cell code, character}
#' }
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' library(sf)
#' data(eu10km)
#' data(biogeoregions10km)
#' bgcells <- unname(unlist(select(subset(biogeoregions10km, region=="BOR"),CELLCODE)))
#' ggplot(subset(eu10km, CELLCODE %in% bgcells))+
#'   geom_sf(fill=NA)+
#'   theme_void()
#' @source https://cdr.eionet.europa.eu/help/habitats_art17/Reporting2025
#' @docType data
#' @keywords datasets
#' @name biogeoregions10km
#' @usage data(biogeoregions10km)
#' @export
#' data(biogeoregions10km)
"biogeoregions10km"
