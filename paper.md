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
  - orcid: 0000-0001-8864-0552
  - affiliation: "1"
affiliations:
  - name: IDEMS International
    index: 1
date: 3 June 2024
bibliography: paper.bib

---
  
# Summary
The `carbonr` package provides a user-friendly, open-source tool for calculating carbon-equivalent emissions based on various sources, primarily the UK Government’s greenhouse gas reporting guidelines [@ukgov_greenhouse_gas_reporting_2023].

Designed for flexibility and ease of use, `carbonr` enables users from different sectors to estimate emissions from travel, construction, office environments, and, more recently, clinical settings, thereby aiding in informed decision-making for environmental impact reduction.

# Statement of Need
Climate change and environmental sustainability are pressing global challenges that require sophisticated methods for assessing and mitigating carbon emissions across various sectors [@WHO2023]. Traditional tools for carbon accounting often lack flexibility, transparency, and/or accessibility. These limitations can hamper scientific advancements and the widespread adoption of best practices accounting for in carbon emissions.

To address these issues, `carbonr` offers an open-source solution that improves the reproducibility of carbon emission calculations and enhances the understanding of these emissions within the research community. Key features of `carbonr` include its simplicity, user-friendly Shiny interface, and adaptability to different sector needs, making it accessible to a broader audience.

By being hosted on GitHub, `carbonr` encourages global community engagement. This collaborative environment not only keeps the tool up-to-date but also allows it to be tailored to specific sectors. A notable enhancement in the application of `carbonr` is its role in assessing emissions from operating theatres, which are significant contributors to hospital carbon footprints. In a collaborative initiative hosted on GitHub, `carbonr` was adapted to include a set of functions that calculate carbon emissions specifically for operating theatres [@ma2024green].

Furthermore, the open-source nature of `carbonr` allows for ongoing verification and comparison of emissions data, this is important for accurate environmental impact assessments.

The emission calculations of `carbonr` are primarily based on the UK Government’s greenhouse gas reporting guidelines [@ukgov_greenhouse_gas_reporting_2023]. The integration of a straightforward Shiny interface broadens its usability beyond technically skilled users to anyone interested in carbon management, reflecting our commitment to making carbon estimation as inclusive and user-friendly as possible.

By bridging these gaps, `carbonr` not only facilitates precise and comprehensive emission calculations, but also promotes a deeper understanding of emissions across different sectors. Its ongoing development and adaptability highlight its potential to significantly influence both research and practical applications in environmental sustainability, ensuring it remains relevant and effective in the face of evolving challenges.

# Usage
With `carbonr`, users can estimate emissions for various activities such as air travel, hotel stays, and construction work using straightforward functions like `airplane_emissions()` or `construction_emissions()`. 


The `carbonr` package complements other R tools by providing functions to estimate and analyse emissions from various activities such as air travel, hotel stays, and construction work. Below are detailed examples demonstrating common uses in estimating travel emissions

### Estimating Travel Emissions

First, use the `airport_finder` function to lookup IATA codes for airports. Here's how you find the code for London Heathrow and Nairobi airports:

```{r, message = FALSE, warning = FALSE, eval = TRUE, include = FALSE}
library(carbonr)
library(dplyr)
```

```{r, message = FALSE, warning = FALSE, eval = FALSE, include=TRUE}
library(carbonr)
library(dplyr)
# Finding the airport code for London Heathrow
airport_finder(name = "Heathrow")
```

+-------------------+------------+----------+----------+
| Header 1          | Header 2   | Header 3 | Header 4 |
|                   |            |          |          |
+:=================:+:==========:+:========:+:========:+
| row 1, column 1   | column 2   | column 3 | column 4 |
+-------------------+------------+----------+----------+
| row 2             | cells span columns               |
+-------------------+------------+---------------------+
| row 3             | cells      | - body              |
+-------------------+ span rows  | - elements          |
| row 4             |            | - here              |
+===================+============+=====================+
| Footer                                               |
+===================+============+=====================+

# ...

| Name            | City    | Country        | IATA |
+:===============:+:=======:+:==============:+:====:+
| London Heathrow | London  | United Kingdom | LHR  |
| Airport         |         |                |      |


```{r, message = FALSE, warning = FALSE, eval=FALSE, include=TRUE}
# Finding the airport codes for airports in Nairobi
carbonr::airport_finder(city = "Nairobi")
```

+-----------------+---------+----------------+------+
| Name            | City    | Country        | IATA |
+:===============:+:=======:+:==============:+:====:+
| Nairobi Wilson  | Nairobi | Kenya          | WIL  |
| Airport         |         |                |      |
+-----------------+---------+----------------+------+
| Moi Air Base    | Nairobi | Kenya          | N/A  |
+-----------------+---------+----------------+------+
| Jomo Kenyatta   | Nairobi | Kenya          | NBO  |
| International   |         |                |      |
| Airport         |         |                |      |
+-----------------+---------+----------------+------+

Using these codes, calculate the emissions for a round-trip journey:

```{r, message = FALSE, warning = FALSE, eval=FALSE, include=TRUE}
# Calculating emissions for a round-trip flight
airplane_emissions(from = "LHR", to = "KIS", via = "NBO")
```

### Analysing Emissions Data Sets

For a more comprehensive analysis, integrate information for multiple travellers and journey types:

```{r, message = FALSE, warning = FALSE, eval=FALSE, include=TRUE}
# Example dataset of multiple individuals' travel details
multiple_ind <- tibble::tribble(
  ~ID, ~rail_from, ~rail_to, ~air_from, ~air_to, ~air_via,
  "Clint", "Bristol Temple Meads", "Paddington", "LHR", "KIS", "NBO",
  "Zara", "Bristol Temple Meads", "Paddington", "LHR", "LAX", "ORL"
)

multiple_ind %>%
  dplyr::rowwise() %>%
  dplyr::mutate(plane_emissions = airplane_emissions(air_from, air_to, air_via)) %>%
  dplyr::mutate(train_emissions = rail_emissions(rail_from, rail_to)) %>%
  dplyr::mutate(total_emissions = plane_emissions + train_emissions)
```

+-------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| ID    | Rail from | Rail to   | Air from  | Air to    | Air via   | Air       | Rail      | Total     |
|       |           |           |           |           |           | emissions | emissions | emissions |
+:=====:+:=========:+:=========:+:=========:+:=========:+:=========:+:=========:+:=========:+:=========:+
| Clint | Bristol   |Paddington | LHR       | KIS       | NBO       | 2.091     | 0.007     | 2.098     |
|       | Temple    |           |           |           |           |           |           |           |
|       | Meads     |           |           |           |           |           |           |           |
+-------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Zara  | Bristol   |Paddington | LHR       | LAX       | ORL       | 3.086     | 0.007     | 3.093     |
|       | Temple    |           |           |           |           |           |           |           |
|       | Meads     |           |           |           |           |           |           |           |
+-------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+

# Future Goals
The ongoing development of `carbonr` is focused on enhancing its utility and sustainability as a key research tool. We are committed to the following multiple objectives. 

First, we aim to expand `carbonr`'s capabilities to process annual data from both companies and individuals, enabling detailed emissions reporting with advanced visualisations and tailored data tables. This feature would support researchers in tracking temporal trends and assessing long-term environmental strategies.

Futhermore, reflecting on successful collaborations, such as the one that led to the inclusion of operating theatre emissions [@ma2024green], we encourage the community to actively participate in `carbonr`'s evolution. Our GitHub platform is open for researchers, developers, and environmental practitioners to contribute insights, refine methodologies, and address emerging challenges.

We plan to regularly update `carbonr` by integrating the latest research findings and environmental reporting standards. Our release cycle includes bi-annual updates to maintain relevance and accuracy, supporting both practical application and scientific research.

By integrating these changes, we hope for `carbonr` to both remain relevant as a practical tool and to grow as a research tool. This can contribute to the scientific community’s efforts to combat climate change through better data understanding and informed policy-making.

# References
