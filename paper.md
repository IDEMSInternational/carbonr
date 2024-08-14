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
  - calculate
authors:
  - name: Lily Clements
    orcid: 0000-0001-8864-0552
    affiliation: 1
affiliations:
 - name: IDEMS International
   index: 1
date: 4th June
bibliography: paper.bib

---
  
# Summary
The `carbonr` package provides a user-friendly, open-source tool for calculating carbon-equivalent emissions based on various sources, primarily the UK Government’s greenhouse gas reporting guidelines [@ukgov_greenhouse_gas_reporting_2023].

Designed for flexibility and ease of use, `carbonr` enables users from different sectors to estimate emissions from travel, construction, office environments, and, more recently, clinical settings, thereby aiding in informed decision-making for environmental impact reduction.

# Statement of Need
Climate change and environmental sustainability are pressing global challenges that require sophisticated methods for assessing and mitigating carbon emissions across various sectors [@WHO2021]. Accurate carbon accounting is important for understanding and reducing environmental impacts; however, the tools available to researchers and practitioners often fall short in terms of flexibility, transparency, and accessibility.

Traditional carbon accounting tools often involve manual calculations using spreadsheets or proprietary software. For example, the UK Government provides Excel-based templates {@ukgov_greenhouse_gas_reporting_2023}, and the Carbon Footprint Calculator is one online calculator to estimate emissions [@carbonfootprint_calculator]. These tools, while comprehensive, are often not easily adaptable to different sectors or use-cases. Additionally, they lack the reproducibility offered by an open-source solution which could automate calculations and provide a more streamlined, adaptable approach. These limitations can hamper scientific advancements and the widespread adoption of best practices in accounting for carbon emissions. 

Current open-source solutions have a limited scope; for example, `co2calculator` in Python focusses on calculations related to heating, electricity, business trips, and transportation [@pledge4future_co2calculator]. Similarly, `footprint` in R specialises in air travel emissions [@rpackage_footprint]. These tools are not comprehensive enough to address the diverse needs of users who require a broader range of emission activities.

To address these issues, `carbonr` offers an open-source solution that improves the reproducibility of carbon emission calculations and enhances the understanding of these emissions within the research community. Key features include its simplicity, user-friendly Shiny interface, and adaptability to different sector needs, making it accessible to a broader audience.

By being hosted on GitHub, `carbonr` encourages global community engagement. This collaborative environment not only keeps the tool up-to-date but also allows it to be tailored to specific sectors. A notable enhancement in the application of `carbonr` is its role in assessing emissions from operating theatres, which are significant contributors to hospital carbon footprints. In a collaborative initiative hosted on GitHub, `carbonr` was adapted to include a set of functions that calculate carbon emissions specifically for operating theatres [@ma2024green].

Furthermore, the open-source nature of `carbonr` allows for ongoing verification and comparison of emissions data, this is important for accurate environmental impact assessments. Users can easily modify the tool to suit their specific needs, share their adaptations with the community, and contribute to the continuous improvement of the package.

The emission calculations of `carbonr` are primarily based on the UK Government’s greenhouse gas reporting guidelines [@ukgov_greenhouse_gas_reporting_2023]. The integration of a Shiny interface broadens its usability beyond technically skilled users to anyone interested in carbon management, reflecting our commitment to making carbon estimation as inclusive and user-friendly as possible.

By bridging these gaps, `carbonr` not only facilitates precise and comprehensive emission calculations, but also promotes a deeper understanding of emissions across different sectors. Its ongoing development and adaptability highlight its potential to significantly influence both research and practical applications in environmental sustainability, ensuring it remains relevant and effective in the face of evolving challenges.

# Usage
With `carbonr`, users can estimate emissions for various activities such as air travel, hotel stays, and construction work using straightforward functions like `airplane_emissions()` or `construction_emissions()`. 

The `carbonr` package complements other R tools by providing functions to estimate and analyse emissions from various activities such as air travel, hotel stays, and construction work. Below are detailed examples demonstrating common uses in estimating travel emissions

### Estimating Travel Emissions

The `airport_finder` function can look-up IATA codes for airports; for example, for London Heathrow and Nairobi airports:

```
library(carbonr)
library(dplyr)

# Finding the airport code for London Heathrow
airport_finder(name = "Heathrow")
```

| Name                     | City    | Country        | IATA |
|:------------------------:|:-------:|:--------------:|:----:|
| London Heathrow Airport  | London  | United Kingdom | LHR  |

```
# Finding the airport codes for airports in Nairobi
carbonr::airport_finder(city = "Nairobi")
```

| Name                                | City    | Country        | IATA |
|:-----------------------------------:|:-------:|:--------------:|:----:|
| Nairobi Wilson Airport              | Nairobi | Kenya          | WIL  | 
| Moi Air Base                        | Nairobi | Kenya          | N/A  |
| Jomo Kenyatta International Airport | Nairobi | Kenya          | NBO  |

Using these codes, calculate the emissions for a round-trip journey:

```
# Calculating emissions for a round-trip flight
airplane_emissions(from = "LHR", to = "KIS", via = "NBO")
```

### Analysing Emissions Data Sets

For a more comprehensive analysis, integrate information for multiple travellers and journey types:

```
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

| ID  | Rail from            | Rail to  | Air from | Air to | Air via | Air emissions | Rail emissions | Total emissions |
|:---:|:--------------------:|:--------:|:--------:|:------:|:-------:|:---------------:|:---------------:|:---------------:|
| Clint | Bristol Temple Meads | Paddington | LHR     | KIS    | NBO     | 2.091        | 0.007     | 2.098        |
| Zara  | Bristol Temple Meads | Paddington | LHR     | LAX    | ORL     | 3.086        | 0.007     | 3.093        |

# Future Goals
The ongoing development of `carbonr` is focused on enhancing its utility and sustainability as a key research tool. We are committed to multiple objectives. 

First, we aim to expand `carbonr`'s capabilities to process annual data from both companies and individuals, enabling detailed emissions reporting with advanced visualisations and tailored data tables. This feature would support researchers in tracking temporal trends and assessing long-term environmental strategies.

Futhermore, reflecting on successful collaborations, such as the one that led to the inclusion of operating theatre emissions [@ma2024green], we encourage the community to actively participate in `carbonr`'s evolution. Our GitHub platform is open for researchers, developers, and environmental practitioners to contribute insights, refine methodologies, and address emerging challenges.

We plan to regularly update `carbonr` by integrating the latest research findings and environmental reporting standards. Our release cycle includes bi-annual updates to maintain relevance and accuracy, supporting both practical application and scientific research.

By integrating these changes, we hope for `carbonr` to both remain relevant as a practical tool and to grow as a research tool. This can contribute to the scientific community’s efforts to combat climate change through better data understanding and informed policy-making.

# References
