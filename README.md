
<!-- README.md is generated from README.Rmd. Please edit that file -->

# carbonr <img src='man/figures/carbonr_icon_2.png' align="right" height="139"/>

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
(2023)](https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2023)
whereever available.

## Installation

You can install the development version of carbonr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("IDEMSInternational/carbonr")
```

## Aims of carbonr

In 2021, work began on the `carbonr` package in R with the aim of
addressing the following challenges and improving the estimation of
carbon-equivalent emissions. This came after a review of current
approaches to estimate carbon-equivalent emissions.

`carbonr` aims to provide a reliable and reproducible approach to
calculating emissions levels, ensuring that the results can be saved,
edited, and redistributed easily. Further, `carbonr` aims to be
transparent in its calculations and values applied. This has the bonus
of allowing for flexibility and customisation in estimating
carbon-equivalent emissions.

The vision for `carbonr` is to expand and become more comprehensive. We
invite contributions from the community to extend the package’s
functionality, build additional features, and transform it into a more
robust tool for estimating carbon-equivalent emissions. Similarly, we
invite open discussions and contribution to capture different
perspectives and enhancing the functionality of the package.

Finally, `carbonr` aims to make the estimation of carbon-equivalent
emissions more accessible by offering a user-friendly front-end
interface using Shiny. This ensures that the tools are easier to use,
even for individuals with limited programming experience.

## Functions in `carbonr`

Currently, emission estimates relate to travel, materials, day-to-day,
and clinically based.

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

We give some small examples in using the functions in `carbonr()`.
Further, more comprehensive, examples are available in the vignette.

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
airplane_emissions("YVR", "YTZ")
#> [1] 0.9876006
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
| Clint | Bristol Temple Meads | Paddington | LHR      | KIS    | NBO     |        2.090193 |       0.0074051 |        2.097598 |
| Zara  | Bristol Temple Meads | Paddington | LHR      | LAX    | ORL     |        3.085740 |       0.0074051 |        3.093146 |

Additional emissions can be calculated as well. For example, office
emissions

``` r
office_emissions(specify = TRUE, electricity_kWh = 255.2, water_supply = 85, heat_kWh = 8764)
#> [1] 0.002345161
```

Alternatively, more advance emissions can be given with other functions,
such as the `material_emissions()`, `construction_emissions()`, and
`raw_fuels()` functions.

### Beyond the Emissions Available in the 2023 UK Report

There are additional more specific functions related to calculating
emissions that are not covered in the [UK Government report
(2023)](https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2023).

One large set of these relate to operating theatre waste. Usage on this
are outlined in the vignette. Alternative sources are used to calculate
this set of emissions. The discussions in creating these emissions can
be found under issues, and the sources to calculate the emissions can be
found in the References section.

Carbon credit prices are additionally available in the
`carbon_credit_price()` function where values are based on the [World
Bank data](https://carbonpricingdashboard.worldbank.org/). The
jurisdiction and year available for that jurisdiction can be found in
the `check_CPI()` function.

## Shiny App

An interactive calculator using Shiny can be accessed by the
`shiny_emissions()` function. This calculator uses some of the functions
in the `carbonr` package:

``` r
shiny_emissions()
```

<img src='man/figures/shiny_example.png' align="center" height="400"/>

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

\[1\] For the UK Government Report:

Department for Energy Security and Net Zero. (2023). Greenhouse Gas
Reporting: Conversion Factors 2023. Retrieved from
<https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2023>.
Published on 7 June 2023, last updated on 28 June 2023.

Note emissions for flights in the code uses values from direct effects
only. `Radiative forcing = TRUE` will give indirect and direct effects.
(multiplies by 1.891). See “business travel - air” sheet of gov.uk excel
sheet linked above.

\[2\] Radiative forcing as 1.891:

DEFRA, 2016. Government GHG conversion factors for company reporting:
Methodology paper for emission factors.

\[3\] For Clinically-based emissions, we expanded beyond the 2023
Government Report since there were not estimates available.

Anaesthetic emissions from:

Varughese, S. and Ahmed, R., 2021. Environmental and occupational
considerations of anesthesia: a narrative review and update. Anesthesia
& Analgesia, 133(4), pp.826-835;

McGain, F., Muret, J., Lawson, C. and Sherman, J.D., 2020. Environmental
sustainability in anaesthesia and critical care. British Journal of
Anaesthesia, 125(5), pp.680-692;

Wyssusek, K., Chan, K.L., Eames, G. and Whately, Y., 2022. Greenhouse
gas reduction in anaesthesia practice: a departmental environmental
strategy. BMJ Open Quality, 11(3), p.e001867;

Sherman, J., Le, C., Lamers, V. and Eckelman, M., 2012. Life cycle
greenhouse gas emissions of anesthetic drugs. Anesthesia & Analgesia,
114(5), pp.1086-1090.

Clinical wet waste emissions from: Department of Climate Change, Energy,
the Environment and Water. (2022). National Greenhouse Accounts Factors:
2022 (p32) \[Brochure\]. Retrieved from
<https://www.dcceew.gov.au/climate-change/publications/national-greenhouse-accounts-factors-2022>.
