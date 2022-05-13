
<!-- README.md is generated from README.Rmd. Please edit that file -->

# carbonr <img src='man/figures/carbonr_icon.png' align="right" height="139"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/IDEMSInternational/carbonr/workflows/R-CMD-check/badge.svg)](https://github.com/IDEMSInternational/carbonr/actions)
[![Codecov test
coverage](https://codecov.io/gh/IDEMSInternational/carbonr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/IDEMSInternational/carbonr?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![CRAN
status](https://www.r-pkg.org/badges/version/carbonr)](https://CRAN.R-project.org/package=carbonr)
[![license](https://img.shields.io/badge/license-LGPL%20(%3E=%203)-lightgrey.svg)](https://www.gnu.org/licenses/lgpl-3.0.en.html)
<!-- badges: end -->

## Overview

carbonr is a package in R to conveniently calculate carbon-equivalent
emissions:

-   `airplane_emissions()`
-   `ferry_emissions()`
-   `hotel_emissions()`
-   `office_emissions()`
-   `rail_emissions()`
-   `raw_fuels()`
-   `vehicle_emissions()`

These all return carbon-equivalent emissions in tonnes. The emissions
values in the calculations are from the UK Government report (2021).

## Installation

You can install the development version of carbonr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("IDEMSInternational/carbonr")
```

## Usage

``` r
library(carbonr)

# To calculate emissions for a flight between Vancouver and Toronto
airport_finder(name = "Vancouver")
#> # A tibble: 3 x 4
#>   Name                                  City      Country IATA 
#>   <chr>                                 <chr>     <chr>   <chr>
#> 1 Vancouver International Airport       Vancouver Canada  "YVR"
#> 2 Vancouver Harbour Water Aerodrome     Vancouver Canada  "CXH"
#> 3 Vancouver International Seaplane Base Vancouver Canada  "\\N"
airport_finder(name = "Toronto")
#> # A tibble: 2 x 4
#>   Name                                     City    Country IATA 
#>   <chr>                                    <chr>   <chr>   <chr>
#> 1 Billy Bishop Toronto City Centre Airport Toronto Canada  YTZ  
#> 2 Toronto/Oshawa Executive Airport         Oshawa  Canada  YOO
airplane_emissions("YVR", "YYZ")
#> [1] 0.9911252

# To calculate emissions for a round trip ferry from Melbourne to New York
seaport_finder(country = "Australia", city = "Melbourne")
#>     country                       city country_code port_code latitude
#> 1 Australia Point Henry Pier/Melbourne           AU       PHP   -38.07
#> 2 Australia             Port Melbourne           AU       POR   -37.50
#>   longitude
#> 1    144.26
#> 2    144.56
seaport_finder(country = "US", city = "New York")
#>         country              city country_code port_code latitude longitude
#> 1 United States Brooklyn/New York           US       BOY    40.44    -73.56
ferry_emissions("POR", "BOY", round_trip = TRUE)
#> [1] 4.422754

# To calculate emissions for a train journey from Bristol Temple Meads to Edinburgh Waverley, via Birmingham New Street.
rail_finder(station = "Bristol")
#> # A tibble: 2 x 7
#>   station_code station              region    county district latitude longitude
#>   <chr>        <chr>                <chr>     <chr>  <chr>       <dbl>     <dbl>
#> 1 BPW          Bristol Parkway      South We~ South~ South G~     51.5     -2.54
#> 2 BRI          Bristol Temple Meads South We~ Brist~ Bristol~     51.4     -2.58
rail_finder(station = "Edinburgh")
#> # A tibble: 2 x 7
#>   station_code station        region   county        district latitude longitude
#>   <chr>        <chr>          <chr>    <chr>         <chr>       <dbl>     <dbl>
#> 1 EDB          Edinburgh      Scotland Edinburgh Ci~ Edinbur~     56.0     -3.19
#> 2 EDP          Edinburgh Park Scotland Edinburgh Ci~ Edinbur~     55.9     -3.31
rail_finder(station = "Birmingham")
#> # A tibble: 5 x 7
#>   station_code station                 region county district latitude longitude
#>   <chr>        <chr>                   <chr>  <chr>  <chr>       <dbl>     <dbl>
#> 1 BBS          Birmingham Bordesley    West ~ West ~ Birming~     52.5     -1.88
#> 2 BHI          Birmingham Internation~ West ~ West ~ Solihull     52.5     -1.73
#> 3 BHM          Birmingham New Street   West ~ West ~ Birming~     52.5     -1.90
#> 4 BMO          Birmingham Moor Street  West ~ West ~ Birming~     52.5     -1.89
#> 5 BSW          Birmingham Snow Hill    West ~ West ~ Birming~     52.5     -1.90
rail_emissions(from = "Bristol Temple Meads", to = "Edinburgh", via = "Birmingham New Street")
#> [1] 0.02303694

# To calculate vehicle emissions for a 100 mile bus journey
vehicle_emissions(distance = 100, units = "miles", vehicle = "bus")
#> [1] 0.02356298

# Additional emissions can be calculated as well. For example, office emissions
office_emissions(specify = TRUE, electricity_kwh = 2455.2, water_m3 = 85, heat_kwh = 8764)
#> [1] 2.60238

# Alternatively, more advance emissions can be given with the `raw_fuels()` function.
```

### Other online calculators:

-   <https://carbonfund.org/calculation-methods/>
-   <https://www.carbonfootprint.com/calculatorfaqs.html>

### Sources:

\[1\] UK government 2021 report. See
<https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/990675/2021-ghg-conversion-factors-methodology.pdf>
<https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021>
Note emissions for flights in the code uses values from direct effects
only. Radiative forcing = TRUE will give indirect and direct effects.
(multiplys by 1.891). See “business travel - air” sheet of gov.uk excel
sheet linked above.

\[2\] Radiative forcing as 1.891 is from www.carbonfund.org
