#' Calculate distribution and range from input features
#'
#' @description
#' `features_to_range` function implements the range calculation
#' procedure described in guidelines of Article 17 reporting under
#' habitats directive.
#'
#' @details
#' This is a function that calculates distribution and range maps from input
#' features and reference grid. Outputs a list with elements 'distribution' and
#' 'range'. Both consist of list containing an sfc object, with geometry of
#' distribution/range, vector of cell codes and area in sq km-s.
#'
#' @param features Input geometries of habitat area (polygons) or
#' species occurence (points, polygons).
#' @param reference_grid Reference grid geometry as sf object of relevant member
#' state and biogeographical region. Can be prepared with function
#' 'ms_region_reference_grid'.
#' @param gap_distance Gap distance parameter in meters. If not specified,
#' default 40 km.
#' @param graphics Produce graphic output?
#'
#' @returns Outputs a list with elements named 'distribution' and 'range'.
#' Both consist of list containing an sfc object, with geometry of
#' distribution/range, vector of cell codes and area in sq km-s.
#'
#'#' @examples
#' library(sf)
#' library(ggplot2)
#' # load country borders
#' data(eesti)
#' # get MS biogeoregion cells
#' bor_cells_ee <- ms_region_reference_grid("EE", "BOR", eesti)
#' set.seed(69)
#' exa_spe_occ <- st_as_sf(st_sample(eesti, 20))
#' exa_spe_range <- features_to_range(exa_spe_occ, bor_cells_ee)
#' ggplot(data = exa_spe_range$range$range)+
#'   geom_sf()+
#'   geom_sf(data=eesti, fill=NA)+
#'   geom_sf(data=exa_spe_occ)+
#'   theme_void()
#'
#' @references DG Environment. 2023. Reporting under Article 17
#' of the Habitats Directive: Guidelines on concepts and definitions
#' – Article 17 of Directive 92/43/EEC, Reporting period 2019-2024.
#' Brussels. Pp 104
#'
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#'
#' @export
features_to_range <- function(features, reference_grid, gap_distance=40e3, graphics=F) {

  if(!requireNamespace("sf", quietly = TRUE)) {
    stop("ms_region_reference_grid() requires the suggested package `sf`.\n",
         "Use install.packages(\"sf\") to install and then retry.")
  }

  if(!"sf" %in% class(features)) {
    stop("Input features not an sf object!")
  }

  if(!"sf" %in% class(reference_grid)) {
    stop("Input reference grid not an sf object!")
  }

  if(!"CELLCODE" %in% names(reference_grid)) {
    stop("Input reference grid does not have CELLCODE field!")
  }

  if(!sf::st_crs(features)==sf::st_crs(reference_grid)) {
    stop("Input reference grid CRS and input feature CRS does not match!")
  }

  cell1<-x<-y<-x1<-y1<-x2<-y2<-ID<-distance<-CELLCODE<-NULL


  #utils::globalVariables(".")

  elupruudud<-reference_grid %>% sf::st_intersects(features)
  etrsruudud1<-reference_grid %>%
    dplyr::slice(which(lengths(elupruudud)>0)) %>%
    sf::st_drop_geometry() %>%
    dplyr::select(`CELLCODE`) %>%
    unlist() %>% unname()

  elupleviksf<-reference_grid %>% dplyr::filter(CELLCODE %in% etrsruudud1)

  eluplevikc<-elupleviksf %>%
    sf::st_centroid()
    #ggplot()+geom_sf()+geom_sf(data=elupleviksf, fill=NA)+theme_void()
  eluplevikcxy<-eluplevikc %>%
    dplyr::mutate(
      x=sf::st_coordinates(eluplevikc)[,1],
      y=sf::st_coordinates(eluplevikc)[,2]
    ) %>%
    dplyr::select(x,y) %>%
    sf::st_drop_geometry()

  eluplevikcd<-eluplevikcxy %>% stats::dist()

  #nrow(eluplevikcd)
  #ncol(eluplevikcd)

  # construct lines

  cdist_long <- tibble::tibble(
      cell1=1:nrow(eluplevikcd)
      ) %>%
    cbind( as.matrix(eluplevikcd) ) %>%
    tidyr::pivot_longer(2:(nrow(eluplevikcd)+1),names_to="cell2", values_to = "distance")

  cdist_in_range<-cdist_long %>%
    dplyr::filter(distance<gap_distance) %>%
    dplyr::filter(distance>0) %>%
    dplyr::mutate(cell1=as.character(cell1)) %>%
    dplyr::left_join(
      eluplevikcxy %>%
        dplyr::mutate(cell1=as.character(1:nrow(eluplevikcxy))) %>%
        dplyr::rename(`x1`=`x`, `y1`=`y`),
      by="cell1"
    ) %>%
    dplyr::left_join(
      eluplevikcxy %>%
        dplyr::mutate(cell2=as.character(1:nrow(eluplevikcxy))) %>%
        dplyr::rename(`x2`=`x`, `y2`=`y`),
      by="cell2"
    )

  clines_in_range<-cdist_in_range %>%
    dplyr::select(`cell1`, `x1`, `y1`) %>%
    dplyr::rename(`ID`=`cell1`, `x`=`x1`, `y`=`y1`) %>%
    dplyr::bind_rows(
      cdist_in_range %>%
        dplyr::select(`cell1`, `x2`, `y2`) %>%
        dplyr::rename(`ID`=`cell1`, `x`=`x2`, `y`=`y2`)
    ) %>%
    sf::st_as_sf( coords = c("x", "y"), crs=3035) %>%
    dplyr::group_by(`ID`) %>%
    dplyr::summarize() %>%
    sf::st_cast("MULTILINESTRING")

  clines_in_range<-cdist_in_range %>%
    dplyr::mutate(ID=1:nrow(cdist_in_range)) %>%
    dplyr::select(`ID`, `x1`, `y1`) %>%
    dplyr::rename(`x`=`x1`, `y`=`y1`) %>%
    dplyr::bind_rows(
      cdist_in_range %>%
        dplyr::mutate(ID=1:nrow(cdist_in_range)) %>%
        dplyr::select(`ID`, `x2`, `y2`) %>%
        dplyr::rename(`x`=`x2`, `y`=`y2`)
    ) %>%
    sf::st_as_sf( coords = c("x", "y"), crs=3035) %>%
    dplyr::group_by(`ID`) %>%
    dplyr::summarize() %>%
    sf::st_cast("MULTILINESTRING") %>%
    sf::st_transform(crs=sf::st_crs(reference_grid))


  #elupleviksf %>%
  #  st_centroid() %>%
  #  ggplot()+geom_sf()+geom_sf(data=elupleviksf, fill=NA)+geom_sf(data=clines_in_range)+theme_void()


  # lines
  cells_in_range1<-reference_grid %>% sf::st_intersects(clines_in_range)
  range_cells1<-reference_grid %>% dplyr::slice(which(lengths(cells_in_range1)>0)) %>% sf::st_drop_geometry() %>% dplyr::select(`CELLCODE`) %>% unlist() %>% unname()

  # add points -> isolated cells
  range_cells2<-elupleviksf %>% sf::st_drop_geometry() %>% dplyr::select(`CELLCODE`) %>% unlist() %>% unname()

  range_cells<-unique(c(range_cells1, range_cells2))

  cells_in_range<-reference_grid %>% dplyr::filter(`CELLCODE` %in% range_cells)

  ranges<-cells_in_range %>% sf::st_union()

  if(graphics==T) {

    elupleviksf %>%
      sf::st_centroid() %>%
      ggplot2::ggplot()+
      ggplot2::geom_sf(data=ranges, fill="brown1")+
      ggplot2::geom_sf()+
        #geom_sf(data=elupleviksf, fill=NA)+
        #geom_sf(data=clines_in_range)+
      ggplot2::theme_void()
  }


  distobject<-list(
    dist=elupleviksf %>% sf::st_as_sfc(),
    area=units::set_units(sf::st_area(sf::st_union(elupleviksf)), "km^2"),
    cells=etrsruudud1
  )

  rangeobject<-list(
    range=ranges %>% sf::st_cast("POLYGON"),
    area=units::set_units(sf::st_area(ranges), "km^2"),
    cells=range_cells
  )

  result<-list(
    dist=distobject,
    range=rangeobject
  )

  return(result)

}
