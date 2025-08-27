#' Calculate construction emissions (UK govt schema)
#'
#' Computes embodied GHG emissions for construction materials using the
#' UK government conversion factors table (`uk_gov_data`), specifically rows
#' with Level 2 = "Construction". Factors are taken from the selected
#' column (`value` or `value_2024`) and are assumed to be kg CO2e per tonne.
#'
#' @param use Named numeric vector of material quantities in tonnes.
#'   Names are matched case/space/punctuation-insensitively to `Level 3`
#'   (e.g., `"Mineral oil"`, `"mineral_oil"`, `"MINERAL-OIL"` all match).
#'   Missing/unknown materials are treated as zero.
#' @param waste Logical. If `TRUE`, waste quantities are assumed equal to `use`
#'   (i.e., the same tonnage is sent to the chosen disposal route).
#'   If `FALSE`, no waste is applied (equivalent to zero for all materials).
#' @param material_production Either:
#'   - a single string applied to all materials, e.g.
#'     `"Primary material production"`, `"Closed-loop source"`, or `"Re-used"`; or
#'   - a named character vector giving a choice per material name,
#'     e.g. `c(concrete = "Closed-loop source", wood = "Re-used")`.
#'   Synonyms are accepted for material production: `"reused"/"re-used"`,
#'   `"closed loop"/"closed-loop"/"closed-loop source"`.
#'
#' @param waste_disposal One of `"Closed-loop"`, `"Combustion"`, `"Composting"`,
#'   `"Landfill"`, or `"Open-loop"`. Applied to all waste. If the chosen
#'   disposal route is not available for a material, behaviour depends on `strict`.
#'
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param value_col Which factor column to use from `uk_gov_data`: `"value"` or `"value_2024"`.
#' @param strict Logical (default `TRUE`). If `TRUE`, error when a required factor
#'   is missing/invalid for any nonzero quantity (either material use or waste).
#'   If `FALSE`, treat missing factors as zero contribution.
#'
#' @details
#' Material-production options (Column Text under Material use):
#'
#' - Aggregates, Asphalt: `"Primary material production"`, `"Closed-loop source"`, `"Re-used"`.
#' - Asbestos, Average Construction, Bricks: `"Primary material production"` only.
#' - Concrete, Insulation, Metals, Mineral Oil, Plasterboard:
#'   `"Primary material production"` or `"Closed-loop source"`.
#' - Soils: `"Closed-loop source"` only.
#' - Tyres, Wood: `"Primary material production"` or `"Re-used"`.
#'
#' Waste-disposal options (Column Text under Waste disposal):
#'
#' - `"Closed-loop"` is valid for aggregates, average, asphalt, concrete,
#'   insulation, metal, soils, mineral oil, plasterboard, tyres, wood.
#' - `"Combustion"` is valid for average, mineral oil, wood.
#' - `"Composting"` is valid for wood only.
#' - `"Landfill"` is valid for everything except average, mineral oil, tyres.
#' - `"Open-loop"` is valid for aggregates, average, asphalt, bricks, concrete
#'   (and any other materials where the table provides a factor).
#'
#' These rules are enforced by the presence/absence of rows in `uk_gov_data`. If a
#' requested material-route pair has no factor in the table, the lookup yields `NA`:
#' with `strict = TRUE` a descriptive error is thrown; with `strict = FALSE` it
#' contributes zero to the total.
#'
#' Units: Factors are kg CO2e / tonne; if `units = "tonnes"`, the result
#' is divided by 1000.
#'
#' @return Numeric total emissions in the requested `units`.
#'
#' @examples
#' # 1) Basic: primary production for all materials, landfill waste = use
#' construction_emissions(
#'   use = c(Aggregates = 1000, Concrete = 500, Wood = 2000),
#'   material_production = "Primary material production",
#'   waste_disposal = "Landfill",
#'   waste = TRUE,
#'   strict = FALSE,
#'   units = "kg"
#' )
#'
#' # 2) Per-material production + synonyms ("closed loop" -> "Closed-loop source", "reused" -> "Re-used")
#' construction_emissions(
#'   use = c(aggregates = 100, concrete = 50, wood = 10),
#'   material_production = c(aggregates = "closed loop", concrete = "Closed-loop source", wood = "reused"),
#'   waste_disposal = "Landfill",
#'   waste = TRUE,
#'   units = "tonnes",
#'   value_col = "value_2024"
#' )
#'
#' # 3) Invalid combos under strict mode (e.g., bricks cannot be "Re-used")
#' \dontrun{
#' construction_emissions(
#'   use = c(bricks = 10),
#'   material_production = "Re-used",
#'   strict = TRUE
#' )}
#' 
#' # Tolerant mode treats missing factors as zero:
#' construction_emissions(
#'   use = c(bricks = 10),
#'   material_production = "Re-used",
#'   strict = FALSE
#' )
construction_emissions <- function(
    use   = setNames(numeric(), character()),
    waste = TRUE,
    material_production = c("Primary material production", "Re-used", "Closed-loop source"),
    waste_disposal = c("Closed-loop","Combustion","Composting","Landfill","Open-loop"),
    units = c("kg","tonnes"),
    value_col = c("value","value_2024"),
    strict = TRUE
) {
  waste_disposal <- match.arg(waste_disposal)
  units          <- match.arg(units)
  value_col      <- match.arg(value_col)
  
  # normalisers
  norm_mat  <- function(x) gsub("[^a-z0-9]+","_", tolower(trimws(x)))
  norm_ctxt <- function(x) gsub("[^a-z]+","", tolower(x))  # strip hyphens/spaces/punct
  
  # materials present in the table (Level 3 under Construction)
  mat_names <- uk_gov_data |>
    dplyr::filter(.data[["Level 2"]] == "Construction") |>
    dplyr::pull("Level 3") |>
    unique() |>
    norm_mat()
  
  # expand user inputs to full material set
  expand_vec <- function(x) {
    if (length(x) == 0) return(setNames(numeric(length(mat_names)), mat_names))
    checkmate::assert_numeric(x, lower = 0, any.missing = FALSE, names = "named")
    names(x) <- norm_mat(names(x))
    out <- setNames(numeric(length(mat_names)), mat_names)
    common <- intersect(names(x), mat_names)
    out[common] <- x[common]
    out
  }
  use   <- expand_vec(use)
  if (waste) waste <- use
  else waste <- setNames(numeric(length(mat_names)), mat_names)
  
  # --- resolve Column Text choices available in the data (for Material use) ---
  choices_use <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Material use",
                  .data[["Level 2"]] == "Construction") |>
    dplyr::distinct(`Column Text`) |>
    dplyr::pull()
  
  # map friendly/synonym inputs -> actual Column Text in the table
  resolve_ct <- function(desired) {
    if (length(choices_use) == 0) return(NA_character_)
    if (is.na(desired) || desired == "") return(NA_character_)
    d <- norm_ctxt(desired)
    # common synonyms
    syn <- list(
      primary   = "Primary material production",
      reused    = "Re-used",
      reused2   = "Re-used",
      closedloop= "Closed-loop"
    )
    if (d %in% names(syn)) desired <- syn[[d]]
    
    cand_norm <- norm_ctxt(choices_use)
    # exact after norm
    hit <- which(cand_norm == norm_ctxt(desired))
    if (length(hit) == 1) return(choices_use[hit])
    # fuzzy: substring match (e.g., "closedloop" inside "closedloopsource")
    hit <- which(grepl(norm_ctxt(desired), cand_norm, fixed = TRUE))
    if (length(hit) >= 1) return(choices_use[hit][1])
    NA_character_
  }
  
  # material_production may be scalar or named per-material vector
  # Build a per-material vector of chosen Column Text
  if (length(material_production) == 1) {
    mp_resolved_all <- resolve_ct(material_production)
    mp_vec <- setNames(rep(mp_resolved_all, length(mat_names)), mat_names)
  } else {
    checkmate::assert_character(material_production, any.missing = FALSE, min.chars = 1, names = "named")
    names(material_production) <- norm_mat(names(material_production))
    mp_vec <- setNames(rep(NA_character_, length(mat_names)), mat_names)
    for (m in intersect(names(material_production), mat_names)) {
      mp_vec[m] <- resolve_ct(material_production[[m]])
    }
    # fill unset materials with the scalar default if user also provided it in ... (optional)
    if (!("default" %in% names(material_production)) && is.character(material_production) && length(material_production) > 0) {
      # leave others as NA (treated per strict)
    }
  }
  
  # helper to get a single factor for one material + column text
  lookup_use_factor <- function(material_norm, column_text) {
    if (is.na(column_text)) return(NA_real_)
    row <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Material use",
                    .data[["Level 2"]] == "Construction",
                    norm_mat(.data[["Level 3"]]) == material_norm,
                    .data[["Column Text"]] == column_text)
    if (nrow(row) == 0) return(NA_real_)
    row[[value_col]][1]
  }
  
  # vector of use emission factors per material (honours per-material production choice)
  ef_use <- vapply(mat_names, function(m) lookup_use_factor(m, mp_vec[[m]]), numeric(1))
  
  # waste (kept scalar disposal mode for simplicity)
  ef_waste <- {
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                    .data[["Level 2"]] == "Construction",
                    .data[["Column Text"]] == waste_disposal) |>
      dplyr::transmute(material = norm_mat(.data[["Level 3"]]),
                       value    = .data[[value_col]]) |>
      dplyr::distinct(material, .keep_all = TRUE)
    vec <- stats::setNames(tbl$value, tbl$material)
    out <- setNames(rep(NA_real_, length(mat_names)), mat_names)
    out[names(vec)] <- vec
    out
  }
  
  # --- Validate allowed combinations ---
  # If a requested combo isn't present in the data, it will already be NA via lookups.
  # We surface nice messages listing the invalid pairs (material -> option).
  missing_use   <- names(use)[use   > 0 & is.na(ef_use)]
  missing_waste <- names(waste)[waste > 0 & is.na(ef_waste[names(waste)])]
  
  if (strict && length(missing_use)) {
    bad <- paste0(missing_use, "→", ifelse(is.na(mp_vec[missing_use]), "unspecified", mp_vec[missing_use]))
    stop("No material-use factor for: ", paste(bad, collapse = ", "),
         ". Either choose a valid option for those materials or set strict = FALSE.")
  }
  if (strict && length(missing_waste)) {
    stop("No waste-disposal factor for: ", paste(missing_waste, collapse = ", "),
         " with disposal '", waste_disposal, "'. Set strict = FALSE to treat as 0.")
  }
  
  # --- Always treat missing factors as 0 for the calculation ---
  ef_use[is.na(ef_use)]     <- 0
  ef_waste[is.na(ef_waste)] <- 0
  
  # Compute total
  total_kg <- sum(use * ef_use) + sum(waste * ef_waste)
  if (units == "tonnes") total_kg <- total_kg * 0.001
  return(total_kg)
}
