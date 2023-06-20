
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
emissions. The emissions values in the calculations are from the [UK
Government report
(2022)](https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2022)
whereever available. For more specific functions related to operating
theatre waste, alternative sources are used given in the References
section.

## Installation

You can install the development version of carbonr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("IDEMSInternational/carbonr")
```

## Aims of carbonR

In 2021, work began on the carbonr package in R with the aim of
addressing the following challenges and improving the estimation of
carbon-equivalent emissions. This came after a review of current
approaches to estimate carbon-equivalent emissions.

**Reproducibility:** The carbonr package seeks to provide a reliable and
reproducible approach to calculating emissions levels, ensuring that the
results can be saved, edited, and redistributed easily.

**Open Source:** R is an open-source language, which means that the
carbonr package benefits from the collaborative nature of the R
community. This allows for open discussions and contributions on
platforms like GitHub, capturing different perspectives and enhancing
the functionality of the package.

**Transparency and Flexibility:** The carbonr package aims for
transparency to provide the ability to amend emissions values and tailor
them to specific environments and contexts. This allows for greater
flexibility and customisation in estimating emissions.

**Cost-effective:** The carbonr package being open source eliminates the
need for users to incur additional costs. This makes it a cost-effective
solution for estimating carbon-equivalent emissions.

**Accessibility:** The carbonr package aims to make the estimation of
carbon-equivalent emissions more accessible by offering a user-friendly
front-end interface using Shiny. This ensures that the tools are easier
to use, even for individuals with limited programming experience.

**Expansion and Collaboration:** Although currently a small stand-alone
package used within IDEMS International, the vision for carbonr is to
expand and become more comprehensive. The creators invite contributions
from the community to extend the package’s functionality, build
additional features, and transform it into a more robust tool for
estimating carbon-equivalent emissions.

By addressing these challenges and incorporating these improvements, the
carbonr package aims to provide a reliable, accessible, and customisable
solution for estimating and offsetting carbon-equivalent emissions.

## Functions in CarbonR

carbonr is a package in R to conveniently calculate carbon-equivalent
emissions. Currently, emission estimates relate to travel, materials,
day-to-day, and clinically based.

- `airplane_emissions()`
- `ferry_emissions()`
- `rail_emissions()`
- `land_emissions()`
- `vehicle_emissions()`
- `hotel_emissions()`
- `building_emissions()`
- `office_emissions()`
- `household_emissions()`
- `construction_emissions()`
- `electrical_emissions()`
- `material_emissions()`
- `metal_emissions()`
- `paper_emissions()`
- `plastic_emissions()`
- `raw_fuels()`
- `anaesthetic_emissions()`
- `clinical_emissions()`
- `clinical_theatre_data()`

These all return carbon-equivalent emissions in tonnes.

A shiny app is also available by `shiny_emissions()` to calculate
carbon-equivalent emissions with a GUI.

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
#> [1] 0.7169341

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
#>   station_code station              region     county    distr~1 latit~2 longi~3
#>   <chr>        <chr>                <chr>      <chr>     <chr>     <dbl>   <dbl>
#> 1 BPW          Bristol Parkway      South West South Gl~ South ~    51.5   -2.54
#> 2 BRI          Bristol Temple Meads South West Bristol ~ Bristo~    51.4   -2.58
#> # ... with abbreviated variable names 1: district, 2: latitude, 3: longitude
rail_finder(station = "Edinburgh")
#> # A tibble: 2 x 7
#>   station_code station        region   county            distr~1 latit~2 longi~3
#>   <chr>        <chr>          <chr>    <chr>             <chr>     <dbl>   <dbl>
#> 1 EDB          Edinburgh      Scotland Edinburgh City Of Edinbu~    56.0   -3.19
#> 2 EDP          Edinburgh Park Scotland Edinburgh City Of Edinbu~    55.9   -3.31
#> # ... with abbreviated variable names 1: district, 2: latitude, 3: longitude
rail_finder(station = "Birmingham")
#> # A tibble: 5 x 7
#>   station_code station                  region    county distr~1 latit~2 longi~3
#>   <chr>        <chr>                    <chr>     <chr>  <chr>     <dbl>   <dbl>
#> 1 BBS          Birmingham Bordesley     West Mid~ West ~ Birmin~    52.5   -1.88
#> 2 BHI          Birmingham International West Mid~ West ~ Solihu~    52.5   -1.73
#> 3 BHM          Birmingham New Street    West Mid~ West ~ Birmin~    52.5   -1.90
#> 4 BMO          Birmingham Moor Street   West Mid~ West ~ Birmin~    52.5   -1.89
#> 5 BSW          Birmingham Snow Hill     West Mid~ West ~ Birmin~    52.5   -1.90
#> # ... with abbreviated variable names 1: district, 2: latitude, 3: longitude
rail_emissions(from = "Bristol Temple Meads", to = "Edinburgh", via = "Birmingham New Street")
#> [1] 0.02303694

# To calculate vehicle emissions for a 100 mile bus journey
land_emissions(distance = 100, units = "miles", vehicle = "Bus")
#> [1] 0.013646
```

``` r
# We can use a data frame to read through the data easier
multiple_ind <- tibble::tribble(~ID, ~station_from, ~station_to, ~airport_from, ~airport_to, ~airport_via,
                        "Clint", "Bristol Temple Meads", "Paddington", "LHR", "KIS", "NBO",
                        "Zara", "Bristol Temple Meads", "Paddington", "LHR", "LAX", "ORL")
multiple_ind %>%
  dplyr::rowwise() %>%
  dplyr::mutate(plane_emissions = airplane_emissions(airport_from,
                                              airport_to,
                                              airport_via)) %>%
  dplyr::mutate(train_emissions = rail_emissions(station_from,
                                          station_to)) %>%
  dplyr::mutate(total_emissions = plane_emissions + train_emissions) %>%
  knitr::kable()
```

| ID    | station_from         | station_to | airport_from | airport_to | airport_via | plane_emissions | train_emissions | total_emissions |
|:------|:---------------------|:-----------|:-------------|:-----------|:------------|----------------:|----------------:|----------------:|
| Clint | Bristol Temple Meads | Paddington | LHR          | KIS        | NBO         |        1.526127 |       0.0074019 |        1.533529 |
| Zara  | Bristol Temple Meads | Paddington | LHR          | LAX        | ORL         |        2.253014 |       0.0074019 |        2.260416 |

``` r
# Additional emissions can be calculated as well. For example, office emissions
office_emissions(specify = TRUE, electricity_kWh = 2455.2, water_supply = 85, heat_kWh = 8764)
#> [1] 0.002805666

# Alternatively, more advance emissions can be given with the `raw_fuels()` function.
```

## Shiny App

An interactive calculator using Shiny can be accessed by the
`shiny_emissions()` function. This calculator uses the functions in the
`carbonr` package:

``` r
shiny_emissions()
```

## References

### Other online calculators:

- <https://carbonfund.org/calculation-methods/>
- <https://www.carbonfootprint.com/calculatorfaqs.html>

### Sources:

\[1\] UK government 2022 report. See
<https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/990675/2022-ghg-conversion-factors-methodology.pdf>
<https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2022>

Note emissions for flights in the code uses values from direct effects
only. Radiative forcing = TRUE will give indirect and direct effects.
(multiplys by 1.891). See “business travel - air” sheet of gov.uk excel
sheet linked above.

\[2\] Radiative forcing as 1.891 is from www.carbonfund.org

\[3\] For Clinically-based emissions, we expanded beyond the 2022
Government Report since there were not estimates available.

anaesthetic emissions from:
<https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8415729>;
<https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7421303/>;
<https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9413181/>;
<https://journals.lww.com/anesthesia-analgesia/Fulltext/2012/05000/Life_Cycle_Greenhouse_Gas_Emissions_of_Anesthetic.25.aspx>

clinical_wet_waste: p32 of
<https://www.dcceew.gov.au/climate-change/publications/national-greenhouse-accounts-factors-2022>
