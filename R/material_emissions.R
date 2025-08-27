#' Material (and waste) emissions — vector-first wrapper
#'
#' Convenience wrapper that sums emissions from paper, plastics, metals,
#' electrical items, construction materials, glass, and industrial waste.
#' It forwards to the dedicated calculators:
#' [paper_emissions()], [plastic_emissions()], [metal_emissions()],
#' [electrical_emissions()], and [construction_emissions()].
#'
#' For each family you provide a named `use` vector in tonnes plus a
#' `waste = TRUE/FALSE` flag (waste tonnage equals `use` when `TRUE`).
#' Unknown names are ignored by the underlying calculators (with warnings).
#'
#' @section Canonical names (examples):
#' - Paper: `board`, `mixed`, `paper`
#' - Plastics: `average`, `average_film`, `average_rigid`, `hdpe`, `ldpe`, `lldpe`, `pet`, `pp`, `ps`, `pvc`
#' - Metals: `aluminium` (cans/foil), `mixed_cans`, `scrap`, `steel_cans`
#' - Electrical: `fridges`, `freezers`, `large_electrical`, `it`, `small_electrical`,
#'   `alkaline_batteries`, `liion_batteries`, `nimh_batteries`
#' - Construction: use the material names supported by [construction_emissions()]
#'
#' @param paper_use,plastic_use,metal_use,electrical_use,construction_use
#'   Named numeric vectors of quantities in tonnes (defaults empty).
#' @param paper_waste,plastic_waste,metal_waste,electrical_waste,construction_waste,glass_waste
#'   Logical flags: if `TRUE`, apply waste factors to the same tonnages as `use`.
#' @param paper_material_production,metal_material_production,construction_material_production
#'   Either a single string (applied to all materials) or a named vector per material.
#'   Common values: `"Primary material production"`, `"Closed-loop source"`, `"Closed-loop"`,
#'   `"Open-loop"`, `"Combustion"`, `"Landfill"` (availability depends on the table).
#' @param paper_waste_disposal,plastic_waste_disposal,metal_waste_disposal,electrical_waste_disposal,construction_waste_disposal,glass_waste_disposal
#'   Waste route to use for the family. See the calculators' docs for valid choices.
#'   (Electrical typically: `"Landfill"`, `"Open-loop"`; Construction supports `"Closed-loop"`,
#'   `"Combustion"`, `"Composting"`, `"Landfill"`, `"Open-loop"` with material-specific availability.)
#' @param glass Numeric tonnage of glass (material use).
#' @param industrial_waste Numeric tonnage of commercial and industrial waste (end-of-life only).
#' @param industrial_waste_disposal `"Combustion"` or `"Landfill"`.
#' @param units Output units: `"kg"` or `"tonnes"` (default `"kg"`).
#' @param value_col Which factor column in `uk_gov_data` to use: `"value"` or `"value_2024"`.
#' @param strict If `TRUE` (default), error when a required factor is missing; if `FALSE`, treat missing factors as 0.
#'
#' @section Backwards compatibility:
#' Legacy scalar arguments (e.g. `board`, `HDPE`, `fridges`, `aluminuim_cans`, …) are
#' still accepted and are added into the corresponding `*_use` vectors.
#' Legacy `*_WD` arguments (separate waste tonnages) are deprecated and ignored;
#' supply `*_waste = TRUE` instead.
#'
#' @return Total emissions in the requested `units`.
#' @export
#'
#' @examples
#' # Paper + Metals + Glass, with waste to the same tonnages
#' material_emissions(
#'   paper_use = c(board = 10, paper = 5),
#'   metal_use = c(aluminium = 0.4, steel_cans = 0.2),
#'   glass = 3, glass_waste = TRUE,
#'   paper_waste_disposal = "Closed-loop",
#'   metal_waste_disposal = "Landfill",
#'   glass_waste_disposal = "Closed-loop",
#'   units = "kg"
#' )
material_emissions <- function(
    # ---- vector-first inputs ----
    paper_use        = setNames(numeric(), character()),
    plastic_use      = setNames(numeric(), character()),
    metal_use        = setNames(numeric(), character()),
    electrical_use   = setNames(numeric(), character()),
    construction_use = setNames(numeric(), character()),
    
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
    
    glass = 0,
    glass_waste = TRUE,
    glass_waste_disposal = c("Closed-loop","Combustion","Landfill","Open-loop"),
    
    industrial_waste = 0,
    industrial_waste_disposal = c("Combustion","Landfill"),
    
    # ---- global options ----
    units     = c("kg","tonnes"),
    value_col = c("value","value_2024"),
    strict    = TRUE
){
  # --- match options
  paper_waste_disposal        <- match.arg(paper_waste_disposal)
  plastic_waste_disposal      <- match.arg(plastic_waste_disposal)
  metal_waste_disposal        <- match.arg(metal_waste_disposal)
  electrical_waste_disposal   <- match.arg(electrical_waste_disposal)
  construction_waste_disposal <- match.arg(construction_waste_disposal)
  glass_waste_disposal        <- match.arg(glass_waste_disposal)
  industrial_waste_disposal   <- match.arg(industrial_waste_disposal)
  units     <- match.arg(units)
  value_col <- match.arg(value_col)
  
  # --- fold legacy scalar inputs into vector-first arguments
  nz <- function(x) is.numeric(x) && length(x) == 1 && isTRUE(x > 0)
  
  # --- compute family totals (request kg from sub-calculators)
  pap_kg <- paper_emissions(
    use = paper_use,
    waste = paper_waste,
    material_production = paper_material_production,
    waste_disposal = paper_waste_disposal,
    units = "kg",
    value_col = value_col,
    strict = strict
  )
  
  pla_kg <- plastic_emissions(
    use = plastic_use,
    waste = plastic_waste,
    waste_disposal = plastic_waste_disposal,
    units = "kg",
    value_col = value_col,
    strict = strict
  )
  
  met_kg <- metal_emissions(
    use = metal_use,
    waste = metal_waste,
    material_production = metal_material_production,
    waste_disposal = metal_waste_disposal,
    units = "kg",
    value_col = value_col,
    strict = strict
  )
  
  ele_kg <- electrical_emissions(
    use = electrical_use,
    waste = electrical_waste,
    waste_disposal = electrical_waste_disposal,
    units = "kg",
    value_col = value_col,
    strict = strict
  )
  
  con_kg <- construction_emissions(
    use = construction_use,
    waste = construction_waste,
    material_production = construction_material_production,
    waste_disposal = construction_waste_disposal,
    units = "kg",
    value_col = value_col,
    strict = strict
  )
  
  # --- Glass (material use + optional waste)
  # helpers
  pull_first <- function(df) if (nrow(df)) df[[value_col]][1] else NA_real_
  need_or_zero <- function(val, needed_label, need) {
    if (!need) return(0)
    if (is.na(val)) { if (strict) stop("No factor for ", needed_label, call. = FALSE); 0 } else val
  }
  # resolve Column Text synonyms like other fns
  norm_ct <- function(x) gsub("[^a-z]+","", tolower(x))
  choices_use_gl <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Material use",
                  .data[["Level 3"]] == "Glass") |>
    dplyr::distinct(`Column Text`) |>
    dplyr::pull()
  resolve_ct <- function(desired) {
    if (length(choices_use_gl) == 0) return(NA_character_)
    if (is.na(desired) || desired == "") return(NA_character_)
    syn <- list(
      primary          = "Primary material production",
      closedloop       = "Closed-loop source",
      closedloopsource = "Closed-loop source",
      closed_loop      = "Closed-loop source",
      openloop         = "Open-loop",
      combustion       = "Combustion",
      landfill         = "Landfill"
    )
    d <- norm_ct(desired); if (d %in% names(syn)) desired <- syn[[d]]
    cn <- norm_ct(choices_use_gl)
    hit <- which(cn == norm_ct(desired)); if (length(hit)) return(choices_use_gl[hit][1])
    hit2 <- which(grepl(norm_ct(desired), cn, fixed = TRUE)); if (length(hit2)) return(choices_use_gl[hit2][1])
    NA_character_
  }
  glass_ct <- resolve_ct("Primary material production")
  
  ef_glass_use <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Material use",
                  .data[["Level 3"]] == "Glass",
                  .data[["Column Text"]] == glass_ct) |>
    pull_first()
  
  ef_glass_wd <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                  .data[["Level 3"]] == "Glass",
                  .data[["Column Text"]] == glass_waste_disposal) |>
    pull_first()
  
  gl_use   <- need_or_zero(ef_glass_use, "Glass material use", glass > 0)
  gl_waste <- need_or_zero(ef_glass_wd,  paste0("Glass waste (", glass_waste_disposal, ")"),
                           glass_waste && glass > 0)
  
  gla_kg <- glass * (gl_use + gl_waste)
  
  # --- Industrial waste (EoL only)
  ef_ind <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                  .data[["Level 3"]] == "Commercial and industrial waste",
                  .data[["Column Text"]] == industrial_waste_disposal) |>
    pull_first()
  ind_kg <- if (industrial_waste > 0)
    need_or_zero(ef_ind, paste0("Industrial waste (", industrial_waste_disposal, ")"), TRUE) * industrial_waste
  else 0
  
  # --- total
  total_kg <- pap_kg + pla_kg + met_kg + ele_kg + con_kg + gla_kg + ind_kg
  if (units == "tonnes") total_kg <- total_kg * 0.001
  total_kg
}
