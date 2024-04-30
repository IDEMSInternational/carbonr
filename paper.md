---
title: 'carbonr: An R Package for Estimating Carbon-Equivalent Emissions'
tags:
- R
- carbon emissions
- open-source
- environmental impact
- greenhouse gas reporting
- climate change
- sustainability
- reproducibility
- transparency
- Shiny
- emissions data
- environmental strategies
authors:
  - name: Lily Clements
    orcid: 0000-0001-8864-0552
    equal-contrib: true
    affiliation: "1"
affiliations:
  - name: IDEMS International
    index: 1
date: 29 April 2024
bibliography: paper.bib

---
  
# Summary
  
The `carbonr` package provides a user-friendly, open-source tool for calculating carbon-equivalent emissions based on various sources, primarily the UK Government’s greenhouse gas reporting guidelines [@ukgov_greenhouse_gas_reporting_2023].

Designed for flexibility and ease of use, `carbonr` enables users from different sectors to estimate emissions from travel, construction, office environments, and, more recently, clinical settings, thereby aiding in informed decision-making for environmental impact reduction.

# Statement of need
Climate change and environmental sustainability are pressing global challenges [@WHO2023]. Accurately estimating carbon emissions is important for organisations that aim to understand and mitigate their environmental impact. Despite the significance of this task, there has been a notable lack of open-source tools, which can affect the reproducibility, transparency, and adaptability of existing solutions.

The `carbonr` package aims to fill this gap by providing an open-source solution in R, hosted on GitHub. It aims to deliver reliable and reproducible emission estimates, ensuring that results can be reviewed over time. This invites ongoing critique and enhancement of both the code and the estimates, helping `carbonr` to continually improve.
`carbonr` can offer the flexibility to adjust emission factors and methodologies to suit specific contexts, thereby enhancing the accuracy and relevance of its outputs. By being hosted on GitHub, `carbonr` encourages global community engagement and contributions, enriching the tool with diverse insights and expertise.

The emission calculations are primarily based on the UK Government’s greenhouse gas reporting guidelines [@ukgov_greenhouse_gas_reporting_2023]. Key features of `carbonr` include its simplicity and the integration of a user-friendly Shiny interface, which broadens its accessibility beyond technically skilled users to others interested in estimating their carbon emissions. This approach underscores our commitment to making carbon estimation as straightforward and inclusive as possible.

# Usage
With `carbonr`, users can estimate emissions for various activities such as air travel, hotel stays, and construction work using straightforward functions like `airplane_emissions()` or `construction_emissions()`. 

## Examples
The package is designed to complement other R tools. The documentation includes examples demonstrating how to apply `carbonr` for common tasks like estimating travel emissions or assessing the environmental impact of operating theatres. For instance, consider calculating the round-trip emissions for a journey from London Heathrow to Kisumu, Kenya, via Nairobi. You can find the IATA codes by the `airport_finder` function. For example:
  
```{r, message = FALSE, warning = FALSE}
library(carbonr)
```
```{r, message = FALSE, warning = FALSE, eval=FALSE, include=TRUE}
airport_finder(name = "heathrow")
```
```{r, message = FALSE, warning = FALSE, echo = FALSE}
library(magrittr)
airport_finder(name = "heathrow") %>%
  knitr::kable()
```
```{r, message = FALSE, warning = FALSE, eval=FALSE, include=TRUE}
airport_finder(city = "nairobi")
```
```{r, message = FALSE, warning = FALSE, echo = FALSE}
airport_finder(city = "nairobi") %>%
  knitr::kable()
```

These codes can then be used to calculate the airplane emissions:
  
```{r, message = FALSE, warning = FALSE}
airplane_emissions(from = "LHR", to = "KIS", via = "NBO")
```

Users can also analyse emissions data sets, integrating information for multiple travellers or journey types. For example,

```{r, message = FALSE, warning = FALSE, eval=FALSE, include=TRUE}
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
```{r, message = FALSE, warning = FALSE, echo = FALSE}
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
  dplyr::mutate(total_emissions = plane_emissions + train_emissions) %>%
  knitr::kable()
```

# Future Goals
As `carbonr` continues to evolve, we aim to enhance its functionality to accommodate the processing of annual data from companies or individuals. This would allow the software to provide comprehensive emission reports, complete with detailed graphics and tailored data tables. Such features would enable users to track and analyse emissions trends over time, providing more informed environmental strategies.

Initiated through collaboration on GitHub, `carbonr` now includes capabilities for estimating emissions specific to operating theatres [@ma2024green]. Looking ahead, we remain committed to refining `carbonr` through ongoing community-driven development. We welcome contributions that can help extend the software’s functionality, improve its accuracy, and adapt it to broader contexts and needs.

# References