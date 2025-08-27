#' Clinical Emissions
#'
#' Calculate CO2e from an operating theatre session by summing:
#' (1) wet clinical waste; (2) building use (water/electricity/heat);
#' (3) material purchases + end-of-life (paper, plastics, metal, electrical, construction);
#' (4) anaesthetic agents.
#'
#' @section Inputs – Material vectors:
#' For each material family, pass a **named numeric vector** of tonnages (in tonnes).
#' Names must be canonical keys (case/space/punctuation is normalised internally, but
#' using the canonical forms below is recommended):
#'
#' - **Paper** `paper_use`: `board`, `mixed`, `paper`
#' - **Plastics** `plastic_use`: `average`, `average_film`, `average_rigid`,
#'   `hdpe`, `ldpe`, `lldpe`, `pet`, `pp`, `ps`, `pvc`
#' - **Metal** `metal_use`: use your package’s canonical metal keys
#'   (e.g. `aluminium_cans`, `aluminium_foil`, `mixed_cans`, `scrap`, `steel_cans`)
#' - **Electrical** `electrical_use`: `fridges`, `freezers`, `large_electrical`,
#'   `it`, `small_electrical`, `alkaline_batteries`, `liion_batteries`, `nimh_batteries`
#' - **Construction** `construction_use`: e.g. `aggregates`, `average`, `asbestos`,
#'   `asphalt`, `bricks`, `concrete`, `insulation`, `metals`, `soils`, `mineral_oil`,
#'   `plasterboard`, `tyres`, `wood`
#'
#' For each family you can also set a single **waste toggle** (e.g. `plastic_waste = TRUE`)
#' to send the same tonnage to a single disposal route (e.g. `plastic_waste_disposal = "Landfill"`).
#'
#' @inheritParams building_emissions
#' @inheritParams material_emissions
#' @inheritParams anaesthetic_emissions
#'
#' @param wet_clinical_waste Numeric. Amount of (wet) clinical waste.
#' @param wet_clinical_waste_unit Unit for `wet_clinical_waste` (`"tonnes"` or `"kg"`).
#'
#' @param paper_use,plastic_use,metal_use,electrical_use,construction_use
#' Named numeric vectors (tonnes) for each material family (see **Material vectors** above).
#'
#' @param paper_waste,plastic_waste,metal_waste,electrical_waste,construction_waste
#' Logical. If `TRUE`, the same tonnage as the corresponding `*_use` is routed to waste
#' treatment using the family’s `*_waste_disposal` choice. Default `TRUE`.
#'
#' @param paper_material_production,metal_material_production,construction_material_production
#' Column Text choice for **material-use** factors (typically `"Primary material production"`).
#'
#' @param paper_waste_disposal,plastic_waste_disposal,metal_waste_disposal,
#' electrical_waste_disposal,construction_waste_disposal
#' Disposal route to use for that family (see [material_emissions()] for allowed values).
#'
#' @param value_col Which `uk_gov_data` column to use: `"value"` or `"value_2024"`. Default `"value"`.
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param strict Logical. If `TRUE`, missing factors error inside delegated functions; if `FALSE`, treat as 0. Default `TRUE`.
#'
#' @details
#' Wet clinical waste factor defaults to 0.879 tCO2e per tonne (NGA 2022).
#' Building emissions are computed via [building_emissions()] with `units = "kg"`.
#' Materials are computed via [material_emissions()] with `units = "kg"`.
#' Anaesthetic emissions are computed via [anaesthetic_emissions()] (tonnes) and converted to kg to sum.
#' The function sums all components in kg and returns in the `units` requested.
#'
#' @return Total CO2e in the units specified by `units` (kg or tonnes).
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Minimal example using vector-first materials
#' clinical_theatre_emissions(
#'   wet_clinical_waste = 100, wet_clinical_waste_unit = "kg",
#'
#'   # Building (kWh)
#'   electricity_kWh = 250, heat_kWh = 120,
#'
#'   # Materials: paper/plastic/metal/electrical/construction
#'   paper_use = c(paper = 20),
#'   paper_waste = TRUE, paper_waste_disposal = "Closed-loop",
#'
#'   plastic_use = c(pet = 10),
#'   plastic_waste = TRUE, plastic_waste_disposal = "Landfill",
#'
#'   metal_use = c(steel_cans = 0.2),
#'   metal_waste = TRUE, metal_waste_disposal = "Open-loop",
#'
#'   electrical_use = c(alkaline_batteries = 0.05),
#'   electrical_waste = TRUE, electrical_waste_disposal = "Open-loop",
#'
#'   construction_use = c(concrete = 1),
#'   construction_waste = FALSE,
#'
#'   value_col = "value",
#'   units = "kg"
#' )
#' }
clinical_theatre_emissions <- function(
    wet_clinical_waste,
    wet_clinical_waste_unit = c("tonnes", "kg"),
    
    # Anaesthetics (anaesthetic_emissions returns tonnes)
    desflurane = 0, sevoflurane = 0, isoflurane = 0, methoxyflurane = 0, N2O = 0, propofol = 0,
    
    # Building use
    water_supply = 0, water_trt = TRUE,
    water_unit = c("cubic metres", "million litres"),
    electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
    heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE,
    
    # ---------- NEW vector-first material API ----------
    paper_use        = stats::setNames(numeric(), character()),
    plastic_use      = stats::setNames(numeric(), character()),
    metal_use        = stats::setNames(numeric(), character()),
    electrical_use   = stats::setNames(numeric(), character()),
    construction_use = stats::setNames(numeric(), character()),
    
    paper_waste = TRUE,
    plastic_waste = TRUE,
    metal_waste = TRUE,
    electrical_waste = TRUE,
    construction_waste = TRUE,
    
    paper_material_production        = "Primary material production",
    metal_material_production        = "Primary material production",
    construction_material_production = "Primary material production",
    
    paper_waste_disposal        = c("Closed-loop","Combustion","Composting","Landfill"),
    plastic_waste_disposal      = c("Landfill","Open-loop","Closed-loop","Combustion"),
    metal_waste_disposal        = c("Closed-loop","Combustion","Landfill","Open-loop"),
    electrical_waste_disposal   = c("Landfill","Open-loop"),
    construction_waste_disposal = c("Closed-loop","Combustion","Composting","Landfill","Open-loop"),
    
    # Factor selection / behaviour
    value_col = c("value","value_2024"),
    units = "kg",
    strict = TRUE
){
  checkmate::assert_numeric(wet_clinical_waste, lower = 0)
  wet_clinical_waste_unit <- match.arg(wet_clinical_waste_unit)
  paper_waste_disposal        <- match.arg(paper_waste_disposal)
  plastic_waste_disposal      <- match.arg(plastic_waste_disposal)
  metal_waste_disposal        <- match.arg(metal_waste_disposal)
  electrical_waste_disposal   <- match.arg(electrical_waste_disposal)
  construction_waste_disposal <- match.arg(construction_waste_disposal)
  value_col <- match.arg(value_col)
  
  # --- 1) Wet clinical waste (factor in tCO2e/tonne) → convert to kg CO2e
  # Source: NGA Factors 2022 p.32; 0.879 tCO2e per tonne.
  # requested in issue 16
  factor_t_per_tonne <- 0.879
  wet_tonnes <- if (wet_clinical_waste_unit == "kg") wet_clinical_waste * 0.001 else wet_clinical_waste
  clinical_waste_kg <- wet_tonnes * factor_t_per_tonne * 1000
  
  # --- 2) Building emissions in kg
  bldg_kg <- building_emissions(
    water_supply = water_supply, water_trt = water_trt, water_unit = water_unit,
    electricity_kWh = electricity_kWh, electricity_TD = electricity_TD, electricity_WTT = electricity_WTT,
    heat_kWh = heat_kWh, heat_TD = heat_TD, heat_WTT = heat_WTT,
    units = "kg", value_col = value_col
  )
  
  # --- 3) Materials in kg
  usage_kg <- material_emissions(
    paper_use = paper_use, plastic_use = plastic_use, metal_use = metal_use,
    electrical_use = electrical_use, construction_use = construction_use,
    paper_waste = paper_waste, plastic_waste = plastic_waste, metal_waste = metal_waste,
    electrical_waste = electrical_waste, construction_waste = construction_waste,
    paper_material_production = paper_material_production,
    metal_material_production = metal_material_production,
    construction_material_production = construction_material_production,
    paper_waste_disposal = paper_waste_disposal,
    plastic_waste_disposal = plastic_waste_disposal,
    metal_waste_disposal = metal_waste_disposal,
    electrical_waste_disposal = electrical_waste_disposal,
    construction_waste_disposal = construction_waste_disposal,
    units = "kg", value_col = value_col, strict = strict
  )
  
  # --- 4) Anaesthetics (assumed tonnes) → convert to kg to sum
  anaes_t  <- anaesthetic_emissions(
    desflurane = desflurane, sevoflurane = sevoflurane, isoflurane = isoflurane,
    methoxyflurane = methoxyflurane, N2O = N2O, propofol = propofol
  )
  anaes_kg <- anaes_t * 1000
  
  # Sum in kg, return in tonnes
  total_kg <- clinical_waste_kg + bldg_kg + usage_kg + anaes_kg
  
  if (units == "kg") return(total_kg)
  else return(total_kg / 1000)
}
