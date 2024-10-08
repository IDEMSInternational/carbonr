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
 - name: IDEMS International, Reading, UK
   index: 1
date: 4th June
bibliography: paper.bib

---
  
# Summary
The `carbonr` package is an open-source, user-friendly tool for calculating carbon-equivalent emissions, primarily based on the UK Government’s greenhouse gas reporting guidelines [@ukgov_greenhouse_gas_reporting_2023]. 
Designed for flexibility and ease of use, `carbonr` supports emissions estimation across various sectors, including travel, construction, office environments, and clinical settings, aiding informed environmental decision-making for environmental impact reduction.

# Statement of Need
Addressing climate change and environmental sustainability requires advanced methods for assessing and mitigating carbon emissions [@WHO2021]. Many existing tools available to researchers and practitioners, such as the UK Government's Excel templates [@ukgov_greenhouse_gas_reporting_2023] and online calculators [@carbonfootprint_calculator], often involve manual calculations using spreadsheets or proprietary software.
These tools, while comprehensive, are often not easily adaptable to different sectors and can lack the reproducibility and automation of open-source solutions. These limitations can hamper scientific advancements and the widespread adoption of best practices in accounting for carbon emissions. 
Open-source tools like co2calculator [@pledge4future_co2calculator] and footprint [@rpackage_footprint] cover limited areas, such as specialising in air travel, and do not meet the diverse needs of users who require a broader range of emission activities.

`carbonr` addresses these gaps by offering a flexible, open-source solution that improves the reproducibility of carbon emission calculations and enhances the understanding of these emissions within the research community.

One key feature of `carbonr` is its user-friendly Shiny interface, broadening access to include non-technical users to engage in carbon management.

Furthermore, by being hosted on GitHub, `carbonr` benefits from global community engagement, allowing for continuous updates and tailored adaptations. For example, through a collaborative GitHub initiative, `carbonr` was adapted to include functions that calculate emissions from operating theatres [@ma2024green]. Operating theatre emissions are significant contributors to hospital emissions due to their high energy demands from factors like heating requirements, anaesthetic gases, and plastic waste [@macneill2017impact], and hence, integrating this functionality helps provide a more comprehensive tool for assessing and managing these critical environmental impacts.

In addition, the open-source nature of `carbonr` allows for ongoing verification and comparison of emissions data, this is important for accurate environmental impact assessments. Users can easily modify the tool to suit their specific needs, share their adaptations with the community, and contribute to the continuous improvement of the package.

While primarily based on UK guidelines [@ukgov_greenhouse_gas_reporting_2023], the open-source nature of `carbonr` allows for customisation with local data, broadening its applicability. `carbonr` not only facilitates precise and comprehensive emission calculations, but also promotes a deeper understanding of emissions across different sectors. Its ongoing development and adaptability highlight its potential to significantly influence both research and practical applications in environmental sustainability, ensuring it remains relevant and effective in the face of evolving challenges.

# Usage
With `carbonr`, users can estimate emissions for various activities such as air travel, hotel stays, and construction work using straightforward functions like `airplane_emissions()` or `construction_emissions()`. Below are examples demonstrating common uses in estimating travel emissions

### Estimating Travel Emissions

The `airport_finder` function can look-up IATA codes for airports; for example, for London Heathrow and Nairobi airports:

```
library(carbonr)
library(dplyr)

# Finding the airport code for London Heathrow
carbonr::airport_finder(name = "Heathrow")
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
carbonr::airplane_emissions(from = "LHR", to = "KIS", via = "NBO")
```

This calculation follows UK Government guidelines [@ukgov_greenhouse_gas_reporting_2023], which takes the total fuel consumption and divides by the number of passengers. Following these guidelines, in `carbonr` you can specify multiple passengers, which multiplies the emissions accordingly, and adjust for factors like travel class, reflecting the space occupied.

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

# Limitations
`carbonr` offers a flexible framework for carbon accounting but has some limitations. Its emission factors are based on UK Government guidelines and may not be directly applicable globally without modification. Users outside the UK might need to input local data, limiting its immediate global applicability. The package also depends on external sources for emission values, which may not cover all industry-specific nuances. Finally, while a Shiny interface is provided, advanced customisation to write or amend the R functions themselves requires technical skills, potentially limiting accessibility for non-technical users.

# Future Goals
The ongoing development of `carbonr` aims to enhance its utility and impact as a research tool by expanding its capabilities to handle annual emissions data for both companies and individuals. This will include advanced visualisations and tailored data tables to help researchers track trends and assess long-term strategies. 
We also encourage active participation from the research and environmental communities through our GitHub platform to refine methodologies and address new challenges, building on successful collaborations like the integration of operating theatre emissions [@ma2024green].
Finally, `carbonr` will undergo bi-annual updates to incorporate the latest research and reporting standards, ensuring its relevance and accuracy. These efforts will strengthen `carbonr` as a practical tool and research resource, contributing to more informed decision-making in the fight against climate change.

# References
