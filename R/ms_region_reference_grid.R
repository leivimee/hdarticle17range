#' Calculate relevant reference grid of a biogeographical region of a member state
#'
#' @description
#' `ms_region_reference_grid` is a function that returns grid cells of a
#' specific biogeoregion of a member state.
#'
#' @details
#' By default this function returns intersecting cells of a member state
#' reference grid and biogeographical region. Member state area can be specified
#' in input to fine-tune the result or exclude irrelevant cells.
#'
#' @param memberstate Two-letter code of a member state.
#' @param biogeoregion Three or four-letter code of biogeographical region.
#' @param countryborders Polygon geometry of member state.
#'
#' @returns Returns an sf object containing grid cells of a member state in
#' specific biogeographic region.
#'
#' @examples
#' # library(sf)
#' # load country borders
#' data(eesti)
#' # get MS biogeoregion cells
#' bor_cells_ee <- ms_region_reference_grid("EE", "BOR", eesti)
#' # plot cells
#' library(ggplot2)
#' ggplot(bor_cells_ee)+geom_sf(fill=NA)+theme_void()
#'
#' @references DG Environment. 2023. Reporting under Article 17 of the Habitats
#' Directive: Guidelines on concepts and definitions – Article 17 of Directive
#' 92/43/EEC, Reporting period 2019-2024. Brussels. Pp 104
#'
#' @importFrom dplyr %>%
#'
#' @export
ms_region_reference_grid <- function(memberstate="EE", biogeoregion="BOR", countryborders=NULL) {

  if(!requireNamespace("sf", quietly = TRUE)) {
    stop("ms_region_reference_grid() requires the suggested package `sf`.\n",
         "Use install.packages(\"sf\") to install and then retry.")
  }

  CELLCODE <- NULL

  mscells <- hdarticle17range::ms10kmcells[hdarticle17range::ms10kmcells$ms==memberstate, "CELLCODE"]
  #ms_grid <- hdarticle17range::eu10km %>% dplyr::filter(`CELLCODE` %in% mscells)
  bgcells <- hdarticle17range::biogeoregions10km[hdarticle17range::biogeoregions10km$region==biogeoregion, "CELLCODE"]
  #msbgcells <- unique(c(mscells,bgcells))
  msbgcells <- mscells[mscells %in% bgcells]
  region_sf <- hdarticle17range::eu10km %>% dplyr::filter(`CELLCODE` %in% msbgcells)

  if(!is.null(countryborders)) {

    if(F %in% sf::st_is_valid(countryborders)) {
      warning("Invalid geometries in specified MS border!")
    }

    if(!sf::st_crs(countryborders)==sf::st_crs(hdarticle17range::eu10km)) {
      message("Transforming MS borders to CRS of EEA reference grid.\n")
      countryborders<-countryborders %>% sf::st_transform(crs=sf::st_crs(hdarticle17range::eu10km))
    }

    region_ms_isc <- sf::st_intersects(region_sf, countryborders)
    region_ms <- region_sf %>% dplyr::slice(which(lengths(region_ms_isc)>0))

  } else {

    region_ms <- region_sf

  }

  #cell_in_region<-ms_grid %>% sf::st_intersects(region_ms)
  #ms_region_cells<-ms_grid %>% dplyr::slice(which(lengths(cell_in_region)>0))

  # ms_region_cells %>% ggplot()+ geom_sf(fill=NA)+ theme_void()
  return(region_ms)
}
