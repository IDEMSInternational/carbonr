---
title: 'carbonR: An R Package for Estimating Carbon-Equivalent Emissions'
tags:
- R
- carbon emissions
- todo
authors:
  - name: Lily Clements
orcid: 0000-0000-0000-0000
equal-contrib: true
affiliation: "1"
affiliations:
  - name: IDEMS International
index: 1
date: 29 April 2024
bibliography: paper.bib

---
  
# Summary
  
The `carbonr` package provides a user-friendly, open-source tool for calculating carbon-equivalent emissions based on various sources, primarily the UK Government’s greenhouse gas reporting guidelines [ref].

Designed for flexibility and ease of use, it enables users from different sectors to estimate emissions from travel, construction, office environments, and, more recently, clinical settings, thereby aiding in informed decision-making for environmental impact reduction.

# Statement of need

Climate change and environmental sustainability are pressing global challenges [ref]. Accurate estimation of carbon emissions is important for organisations aiming to understand and mitigate their environmental impact. Despite the significance, there was a notable absence of open-source tools tailored for this purpose. This meant that current solutions may not be reproducible, transparent, adaptable, or offer collaboration.

The "carbonr" package fills this gap by providing an open-source solution in R, hosted on GitHub. `carbonr` aims to offer reliable, reproducible estimates to emission levels - ensuring results can be saved over time, as well as inviting critiques on the current code and estimates to help it to continually improve. In addition, by being transparent with the code, `carbonr` can help provide the ability for users to adjust emission factors and methodologies to suit specific contexts, enhancing the accuracy and relevance of the outputs. Finally, GitHub facilitates engagement and contributions from the global community to help enrich the package through diverse insights and expertise.

Furthermore, `carbonr` integrates a user-friendly Shiny interface, broadening accessibility beyond those with extensive technical skills to include any user interested in understanding and managing carbon emissions. This feature underscores our commitment to making carbon estimation as straightforward and inclusive as possible.

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

Initiated through collaboration on GitHub, `carbonr` now includes capabilities for estimating emissions specific to operating theatres. Looking ahead, we remain committed to refining `carbonr` through ongoing community-driven development. We welcome contributions that can help extend the software’s functionality, improve its accuracy, and adapt it to broader contexts and needs.

We aim to continually adapt `carbonr` to meet emerging challenges and opportunities in environmental analysis.

# Acknowledgements

Mention (if applicable) a representative set of past or ongoing research projects using the software and recent scholarly publications enabled by it.


# References