% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ms_region_reference_grid.R
\name{ms_region_reference_grid}
\alias{ms_region_reference_grid}
\title{Calculate relevant reference grid of a biogeographical region of a member state}
\usage{
ms_region_reference_grid(
  memberstate = "EE",
  biogeoregion = "BOR",
  countryborders = NULL
)
}
\arguments{
\item{memberstate}{Two-letter code of a member state.}

\item{biogeoregion}{Three or four-letter code of biogeographical region.}

\item{countryborders}{Polygon geometry of member state.}
}
\value{
Returns an sf object containing grid cells of a member state in
specific biogeographic region.
}
\description{
`ms_region_reference_grid` is a function that returns grid cells of a
specific biogeoregion of a member state.
}
\details{
By default this function returns intersecting cells of a member state
reference grid and biogeographical region. Member state area can be specified
in input to fine-tune the result or exclude irrelevant cells.
}
\examples{
# library(sf)
# load country borders
data(eesti)
# get MS biogeoregion cells
bor_cells_ee <- ms_region_reference_grid("EE", "BOR", eesti)
# plot cells
library(ggplot2)
ggplot(bor_cells_ee)+geom_sf(fill=NA)+theme_void()

}
\references{
DG Environment. 2023. Reporting under Article 17 of the Habitats
Directive: Guidelines on concepts and definitions – Article 17 of Directive
92/43/EEC, Reporting period 2019-2024. Brussels. Pp 104
}
