
<!-- README.md is generated from README.Rmd. Please edit that file -->

# carbonr

<!-- badges: start -->
[![R-CMD-check](https://github.com/IDEMSInternational/carbonr/workflows/R-CMD-check/badge.svg)](https://github.com/IDEMSInternational/carbonr/actions)
[![Codecov test coverage](https://codecov.io/gh/IDEMSInternational/carbonr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/IDEMSInternational/carbonr?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![CRAN
status](https://www.r-pkg.org/badges/version/carbonr)](https://CRAN.R-project.org/package=carbonr)
[![license](https://img.shields.io/badge/license-LGPL%20(%3E=%203)-lightgrey.svg)](https://www.gnu.org/licenses/lgpl-3.0.en.html)
<!-- badges: end -->

An R package to conveniently calculate carbon-equivalent emissions.

## Installation

You can install the development version of carbonr from
[GitHub](https://github.com/) with:

```` r
# install.packages("devtools")
devtools::install_github("IDEMSInternational/carbonr")```

## Example
```r
library(carbonr)
# Want to calculate emissions for a flight between Vancouver and Toronto

airport_finder(name = "Vancouver")
#> # A tibble: 3 x 3
#>   Name                                  City      IATA 
#>   <chr>                                 <chr>     <chr>
#> 1 Vancouver International Airport       Vancouver "YVR"
#> 2 Vancouver Harbour Water Aerodrome     Vancouver "CXH"
#> 3 Vancouver International Seaplane Base Vancouver "\\N"
airport_finder(name = "Toronto")
#> # A tibble: 2 x 3
#>   Name                                     City    IATA 
#>   <chr>                                    <chr>   <chr>
#> 1 Billy Bishop Toronto City Centre Airport Toronto YTZ  
#> 2 Toronto/Oshawa Executive Airport         Oshawa  YOO
airplane_emissions("YVR","YYZ")
#> Warning in data("airports", envir = environment()): data set 'airports' not
#> found
#> [1] 0.505254
````

## Emissions calculated

The emissions that are calculated (with their respective sources given
in square brackets):

  - Train journeys\[1\]
  - Ferry/boat journeys\[1\]
  - Vehicles\[1\]
  - Flights\[1, 2\]
  - Secondary Emissions\[3\]
  - Hotel stays\[1\]

Sources for the emission values

\[1\] UK government 2021 report. See
<https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/990675/2021-ghg-conversion-factors-methodology.pdf>
<https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021>
Note emissions for flights in the code uses values from direct effects
only. Radiative forcing = TRUE will give indirect and direct effects.
(multiples by 1.891). See “business travel - air” sheet of gov.uk excel
sheet linked above.

\[2\] Radiative forcing as 1.891 is from www.carbonfund.org

\[3\] Secondary sources calculated using
<https://www.carbonfootprint.com/calculatorfaqs.html>

## Next Steps:

  - checkmate package for errors
  - Link up with Shiny app calculator?
  - Create simple vignette
  - Add in short haul/medium haul for flights - Under “Employee Travel”
    <https://carbonfund.org/calculation-methods/> “Short flights are
    calculated to be under 300 miles one-way with emissions of 0.217kg
    CO2e per passenger mile Medium flights are calculated to be 300-2300
    miles one-way, average 1500 miles, with emissions of 0.134 kg CO2e
    per passenger mile Long flights are calculated to be \> 2300 miles,
    average 3,000 miles one-way with emissions of 0.167kg CO2e per
    passenger mile”

## Checking values alongside other calculators:

<https://carbonfund.org/calculation-methods/>
<https://www.carbonfootprint.com/calculatorfaqs.html>
