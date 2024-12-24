#' Simplified country borders for Estonia
#'
#' Simplified country borders basing on administrative units available at geoportaal.maamet.ee.
#'
#' @format A simple feature collection of 204 features and 3 variables:
#' \describe{
#'   \item{Id}{Id}
#'   \item{ORIG_FID}{Original FID}
#'   \item{pind_km2}{Area in sq km2}
#' }
#'
#' @source Haldus- ja asustusjaotus: Maa-amet 20.11.2024. https://geoportaal.maaamet.ee/est/ruumiandmed/haldus-ja-asustusjaotus-p119.html
#' @examples
#' library(ggplot2)
#' data(eesti)
#' ggplot(eesti)+
#'   geom_sf(fill=NA)+
#'   theme_void()
#' @source https://cdr.eionet.europa.eu/help/habitats_art17/Reporting2025
#' @docType data
#' @keywords datasets
#' @name eesti
#' @usage data(eesti)
NULL
