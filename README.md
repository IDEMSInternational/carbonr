
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
section. Carbon credit prices are additionally available in the
`carbon_credit_price` function using the [World Bank
data](https://carbonpricingdashboard.worldbank.org/). The jurisdiction
and year available for that jurisdiction can be found in the
`check_CPI()` function.

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

We give some small examples in using the functions in `carbonr()`

``` r
library(carbonr)
```

To calculate emissions for a flight between Vancouver and Toronto, we
first want to find the name of the airports. We do this using the
`airport_finder()` function:

``` r
airport_finder(name = "Vancouver")
```

| Name                                  | City      | Country | IATA |
|:--------------------------------------|:----------|:--------|:-----|
| Vancouver International Airport       | Vancouver | Canada  | YVR  |
| Vancouver Harbour Water Aerodrome     | Vancouver | Canada  | CXH  |
| Vancouver International Seaplane Base | Vancouver | Canada  |      |

``` r
airport_finder(name = "Toronto")
```

| Name                                     | City    | Country | IATA |
|:-----------------------------------------|:--------|:--------|:-----|
| Billy Bishop Toronto City Centre Airport | Toronto | Canada  | YTZ  |
| Toronto/Oshawa Executive Airport         | Oshawa  | Canada  | YOO  |

Now we can find the overall emission value using the appropriate IATA
code. These distances are calculated using the Haversine formula:

``` r
airplane_emissions("YVR", "YYZ")
#> [1] 0.7169341
```

A similar approach can be performed for ferry emissions. For example, to
calculate emissions for a round trip ferry from Melbourne to New York,
we first find the appropriate seaport code with the `seaport_finder()`
function:

``` r
seaport_finder(country = "Australia", city = "Melbourne")
```

| country   | city                       | country_code | port_code | latitude | longitude |
|:----------|:---------------------------|:-------------|:----------|---------:|----------:|
| Australia | Point Henry Pier/Melbourne | AU           | PHP       |   -38.07 |    144.26 |
| Australia | Port Melbourne             | AU           | POR       |   -37.50 |    144.56 |

``` r
seaport_finder(country = "US", city = "New York")
```

| country       | city              | country_code | port_code | latitude | longitude |
|:--------------|:------------------|:-------------|:----------|---------:|----------:|
| United States | Brooklyn/New York | US           | BOY       |    40.44 |    -73.56 |

Now we can find the overall emission value using the appropriate seaport
code:

``` r
ferry_emissions("POR", "BOY", round_trip = TRUE)
#> [1] 4.422754
```

For the UK we can calculate emissions for a train journey. Like with
`airplane_emissions()` and `ferry_emissions()`, the distances are
calculated using the Haversine formula - this is calculated as the crow
flies. As before, we first find the stations. As always, for a more
accurate estimation we can include via points:

To calculate emissions for a train journey from Bristol Temple Meads to
Edinburgh Waverley, via Birmingham New Street. We can use a data frame
and `purrr::map()` to read through the data easier:

``` r
multiple_ind <- tibble::tribble(~ID, ~station,
                        "From", "Bristol",
                        "To", "Edinburgh",
                        "Via", "Birmingham")
purrr::map(.x = multiple_ind$station, .f = ~rail_finder(.x)) %>%
  dplyr::bind_rows()
```

| station_code | station                  | region        | county                | district              | latitude | longitude |
|:-------------|:-------------------------|:--------------|:----------------------|:----------------------|---------:|----------:|
| BPW          | Bristol Parkway          | South West    | South Gloucestershire | South Gloucestershire | 51.51380 | -2.542163 |
| BRI          | Bristol Temple Meads     | South West    | Bristol City Of       | Bristol City Of       | 51.44914 | -2.581315 |
| EDB          | Edinburgh                | Scotland      | Edinburgh City Of     | Edinburgh City Of     | 55.95239 | -3.188228 |
| EDP          | Edinburgh Park           | Scotland      | Edinburgh City Of     | Edinburgh City Of     | 55.92755 | -3.307664 |
| BBS          | Birmingham Bordesley     | West Midlands | West Midlands         | Birmingham            | 52.47187 | -1.877769 |
| BHI          | Birmingham International | West Midlands | West Midlands         | Solihull              | 52.45081 | -1.725857 |
| BHM          | Birmingham New Street    | West Midlands | West Midlands         | Birmingham            | 52.47782 | -1.900205 |
| BMO          | Birmingham Moor Street   | West Midlands | West Midlands         | Birmingham            | 52.47908 | -1.892473 |
| BSW          | Birmingham Snow Hill     | West Midlands | West Midlands         | Birmingham            | 52.48335 | -1.899088 |

Then we can estimate the overall tCO2e emissions for the journey:

``` r
rail_emissions(from = "Bristol Temple Meads", to = "Edinburgh", via = "Birmingham New Street")
#> [1] 0.02303694
```

We can use a data frame to read through the data easier in general. For
example, if we had data for multiple individuals, or journeys:

``` r
multiple_ind <- tibble::tribble(~ID, ~rail_from, ~rail_to, ~air_from, ~air_to, ~air_via,
                        "Clint", "Bristol Temple Meads", "Paddington", "LHR", "KIS", "NBO",
                        "Zara", "Bristol Temple Meads", "Paddington", "LHR", "LAX", "ORL")
multiple_ind %>%
  dplyr::rowwise() %>%
  dplyr::mutate(plane_emissions = airplane_emissions(air_from,
                                              air_to,
                                              air_via)) %>%
  dplyr::mutate(train_emissions = rail_emissions(rail_from,
                                          rail_to)) %>%
  dplyr::mutate(total_emissions = plane_emissions + train_emissions)
```

| ID    | rail_from            | rail_to    | air_from | air_to | air_via | plane_emissions | train_emissions | total_emissions |
|:------|:---------------------|:-----------|:---------|:-------|:--------|----------------:|----------------:|----------------:|
| Clint | Bristol Temple Meads | Paddington | LHR      | KIS    | NBO     |        1.526127 |       0.0074019 |        1.533529 |
| Zara  | Bristol Temple Meads | Paddington | LHR      | LAX    | ORL     |        2.253014 |       0.0074019 |        2.260416 |

Additional emissions can be calculated as well. For example, office
emissions

``` r
office_emissions(specify = TRUE, electricity_kWh = 255.2, water_supply = 85, heat_kWh = 8764)
#> [1] 0.002230256
```

Alternatively, more advance emissions can be given with other functions,
such as the `material_emissions()`, `construction_emissions()`, and
`raw_fuels()` functions.

## Shiny App

An interactive calculator using Shiny can be accessed by the
`shiny_emissions()` function. This calculator uses some of the functions
in the `carbonr` package:

``` r
shiny_emissions()
```

## For the future

To calculate office emissions, we want the ability for the function to
read in data from the office, perhaps accounting data. While the R side
of this is relatively straightforward, this is on hold while we look to
have an appropriate data set in place.

We intend to build in reports that give information on the users
estimated emissions. This would include summary statistics, tables, and
graphs.

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
