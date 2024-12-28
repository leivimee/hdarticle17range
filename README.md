hdarticle17range: Distribution and range calculation tool for Habitats
Directive Article 17 reporting
================

## Overview

Package ‘hdarticle17range’ implements several functions that simplify
distribution and range calculation of species and habitat types in
various member states and biogeographical regions.

Range of a species or habitat type is a crucial parameter in Article 17
reporing under Habitats Directive. While distribution is a
representation of the occurrences in the 10x10 km grid, range
calculation is more sophisticated. Range is obtained by generalizing the
distribution, by creating envelope(s) around the distribution grids
using a parameter named ‘gap distance’.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
#install.packages("devtools")
devtools::install_github("leivimee/hdarticle17range")
```

## Usage

Grid cells of a biogeographic regions in specific member state (MS) can
be obtained with a function names ‘ms_region_reference_grid()’. The
function takes two important arguments – ‘memberstate’ and
‘biogeoregion’. For example, to retrieve the reference grid for Estonia
in Boreal biogeographic region, one can call:

``` r
# load packages
require(sf)
```

    ## Loading required package: sf

    ## Warning: package 'sf' was built under R version 4.3.3

    ## Linking to GEOS 3.11.2, GDAL 3.8.2, PROJ 9.3.1; sf_use_s2() is TRUE

``` r
require(dplyr)
```

    ## Loading required package: dplyr

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
require(ggplot2)
```

    ## Loading required package: ggplot2

    ## Warning: package 'ggplot2' was built under R version 4.3.3

``` r
library(hdarticle17range)
```

``` r
# retrieve cells
eebor10km <- ms_region_reference_grid("EE", "BOR")
# plot
ggplot(data = eebor10km)+
  geom_sf()+
  theme_void()
```

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->
