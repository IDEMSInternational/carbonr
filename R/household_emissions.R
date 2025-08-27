#' Calculate household material emissions (vector-first)
#'
#' Sums emissions from paper, plastics, metals, electrical, construction
#' (delegated to their calculators) plus household-specific streams:
#' Glass/Clothing/Books (GCB), Organic (food/drink/compost), and
#' Household residual waste.
#'
#' @section Inputs:
#' Provide named `*_use` vectors in tonnes and `*_waste = TRUE/FALSE` flags.
#' Unknown names in `gcb_use` / `organic_use` are ignored with a warning.
#'
#' @param paper_use,plastic_use,metal_use,electrical_use,construction_use
#'   Named numeric vectors (tonnes) passed to the corresponding calculators.
#' @param paper_waste,plastic_waste,metal_waste,electrical_waste,construction_waste
#'   Logical; if `TRUE`, apply waste factors to the same tonnages as `*_use`.
#' @param paper_material_production,metal_material_production,construction_material_production
#'   Single string or per-material named vector for MU column text; forwarded.
#' @param paper_waste_disposal,plastic_waste_disposal,metal_waste_disposal,electrical_waste_disposal,construction_waste_disposal
#'   Waste route per family; forwarded.
#'
#' @param gcb_use Named numeric vector for Glass/Clothing/Books (keys: `glass`, `clothing`, `books`).
#' E.g., `gcb_use = c(glass = 3, books = 0.5)`
#' @param gcb_waste Logical; if `TRUE`, apply GCB waste factors to same tonnages.
#' @param gcb_waste_disposal One of `"Closed-loop"`, `"Combustion"`, `"Landfill"`.
#'
#' @param organic_use Named numeric vector for `food`, `drink`,
#'   `compost_from_garden`, `compost_from_food_and_garden`.
#' @param organic_waste Logical; if `TRUE`, apply organic waste factors to same tonnages.
#' @param compost_waste_disposal One of `"Anaerobic digestion"`, `"Combustion"`, `"Composting"`, `"Landfill"`.
#'
#' @param household_residual_waste Numeric (tonnes).
#' @param hh_waste_disposal `"Combustion"` or `"Landfill"`.
#'
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param value_col Which factor column in `uk_gov_data` to use: `"value"` or `"value_2024"`.
#' @param strict If `TRUE` (default) error when a required factor is missing; if `FALSE`, treat as 0.
#'
#' @return Numeric total emissions in requested `units`.
#' @export
#'
#' @examples
#' household_emissions(
#'   gcb_use = c(glass = 3, books = 0.5),
#'   organic_use = c(food = 1, drink = 0.5),
#'   household_residual_waste = 0.8,
#'   gcb_waste = TRUE, organic_waste = TRUE,
#'   gcb_waste_disposal = "Closed-loop",
#'   compost_waste_disposal = "Anaerobic digestion",
#'   hh_waste_disposal = "Combustion",
#'   units = "kg"
#' )
household_emissions <- function(
    # ---- families forwarded to their calculators ----
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
    
    # ---- household-specific streams ----
    gcb_use = stats::setNames(numeric(), character()),              # glass/clothing/books
    gcb_waste = TRUE,
    gcb_waste_disposal = c("Closed-loop","Combustion","Landfill"),
    
    organic_use = stats::setNames(numeric(), character()),          # food/drink/compost...
    organic_waste = TRUE,
    compost_waste_disposal = c("Anaerobic digestion","Combustion","Composting","Landfill"),
    
    household_residual_waste = 0,
    hh_waste_disposal = c("Combustion","Landfill"),
    
    # ---- globals ----
    units     = c("kg","tonnes"),
    value_col = c("value","value_2024"),
    strict    = TRUE
){
  # match options
  paper_waste_disposal        <- match.arg(paper_waste_disposal)
  plastic_waste_disposal      <- match.arg(plastic_waste_disposal)
  metal_waste_disposal        <- match.arg(metal_waste_disposal)
  electrical_waste_disposal   <- match.arg(electrical_waste_disposal)
  construction_waste_disposal <- match.arg(construction_waste_disposal)
  gcb_waste_disposal          <- match.arg(gcb_waste_disposal)
  compost_waste_disposal      <- match.arg(compost_waste_disposal)
  hh_waste_disposal           <- match.arg(hh_waste_disposal)
  units     <- match.arg(units)
  value_col <- match.arg(value_col)
  
  # helpers
  norm <- function(x) gsub("[^a-z0-9]+", "_", tolower(trimws(x)))
  
  # expand & warn unknown names
  expand_named <- function(x, allowed, label) {
    if (length(x) == 0) return(stats::setNames(numeric(length(allowed)), allowed))
    checkmate::assert_numeric(x, lower = 0, any.missing = FALSE, names = "named")
    raw <- names(x)
    nn  <- norm(names(x))
    names(x) <- nn
    out <- stats::setNames(numeric(length(allowed)), allowed)
    hits <- intersect(nn, allowed)
    out[hits] <- x[hits]
    unknown <- raw[!(nn %in% allowed)]
    if (length(unknown)) warning("Ignoring unknown ", label, " name(s): ",
                                 paste(unique(unknown), collapse = ", "),
                                 call. = FALSE)
    out
  }
  
  gcb_names <- c("glass","clothing","books")
  org_names <- c("food","drink","compost_from_garden","compost_from_food_and_garden")
  
  gcb_use_vec <- expand_named(gcb_use, gcb_names, "GCB")
  org_use_vec <- expand_named(organic_use, org_names, "organic")
  
  gcb_waste_vec <- if (isTRUE(gcb_waste)) gcb_use_vec else stats::setNames(numeric(length(gcb_names)), gcb_names)
  org_waste_vec <- if (isTRUE(organic_waste)) org_use_vec else stats::setNames(numeric(length(org_names)), org_names)
  
  # ---------- delegated families (kg) ----------
  fam_kg <- material_emissions(
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
  
  # ---------- GCB MU factors (Material use / Level 2 = "Other") ----------
  gcb_mu_tbl <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Material use",
                  .data[["Level 2"]] == "Other",
                  .data[["Column Text"]] == "Primary material production") |>
    dplyr::transmute(key = norm(.data[["Level 3"]]), val = .data[[value_col]]) |>
    dplyr::distinct(key, .keep_all = TRUE)
  ef_gcb_mu <- stats::setNames(rep(NA_real_, length(gcb_names)), gcb_names)
  ef_gcb_mu[gcb_mu_tbl$key[gcb_mu_tbl$key %in% gcb_names]] <- gcb_mu_tbl$val[gcb_mu_tbl$key %in% gcb_names]
  
  # Warn + zero-fill GCB MU (books often missing)
  miss_gcb_mu <- names(gcb_use_vec)[gcb_use_vec > 0 & is.na(ef_gcb_mu)]
  if (length(miss_gcb_mu)) {
    warning("No material use factor for GCB material(s): ",
            paste(miss_gcb_mu, collapse = ", "),
            " – treating material use as 0 so waste can still be applied.",
            call. = FALSE)
  }
  ef_gcb_mu[is.na(ef_gcb_mu)] <- 0
  
  # ---------- GCB WD factors (Waste disposal / Level 2 = "Other") ----------
  gcb_wd_tbl <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                  .data[["Level 2"]] == "Other",
                  .data[["Column Text"]] == gcb_waste_disposal) |>
    dplyr::transmute(key = norm(.data[["Level 3"]]), val = .data[[value_col]]) |>
    dplyr::distinct(key, .keep_all = TRUE)
  ef_gcb_wd <- stats::setNames(rep(NA_real_, length(gcb_names)), gcb_names)
  ef_gcb_wd[gcb_wd_tbl$key[gcb_wd_tbl$key %in% gcb_names]] <- gcb_wd_tbl$val[gcb_wd_tbl$key %in% gcb_names]
  miss_gcb_wd <- names(gcb_waste_vec)[gcb_waste_vec > 0 & is.na(ef_gcb_wd)]
  if (strict && length(miss_gcb_wd)) {
    stop("No WD factor (", gcb_waste_disposal, ") for GCB: ",
         paste(miss_gcb_wd, collapse = ", "), call. = FALSE)
  }
  ef_gcb_wd[is.na(ef_gcb_wd)] <- 0
  gcb_kg <- sum(gcb_use_vec * ef_gcb_mu) + sum(gcb_waste_vec * ef_gcb_wd)
  
  # ---------- Organic MU (from TWO places) ----------
  # Food & drink MU lives under "Other" goes to "Food and drink"
  # Compost MU lives under "Organic" goes to "Compost from ..."
  org_mu_tbl <- dplyr::bind_rows(
    uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Material use",
                    .data[["Level 2"]] == "Other",
                    .data[["Column Text"]] == "Primary material production") |>
      dplyr::transmute(key = norm(.data[["Level 3"]]), val = .data[[value_col]]),
    uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Material use",
                    .data[["Level 2"]] == "Organic",
                    .data[["Column Text"]] == "Primary material production") |>
      dplyr::transmute(key = norm(.data[["Level 3"]]), val = .data[[value_col]])
  ) |>
    dplyr::distinct(key, .keep_all = TRUE)
  
  # map MU keys
  mu_map <- c(food = "food_and_drink",
              drink = "food_and_drink",
              compost_from_garden = "compost_from_garden_waste",
              compost_from_food_and_garden = "compost_from_food_and_garden_waste")
  ef_org_mu <- stats::setNames(rep(NA_real_, length(org_names)), org_names)
  for (nm in names(mu_map)) {
    k <- mu_map[[nm]]
    hit <- which(org_mu_tbl$key == k)[1]
    if (length(hit) && !is.na(hit)) ef_org_mu[[nm]] <- org_mu_tbl$val[[hit]]
  }
  
  # Warn + zero-fill Organic MU if missing (food/drink often omitted in MU)
  miss_org_mu <- names(org_use_vec)[org_use_vec > 0 & is.na(ef_org_mu)]
  if (length(miss_org_mu)) {
    warning("No MU factor for organic item(s): ",
            paste(miss_org_mu, collapse = ", "),
            " – treating MU as 0 so waste can still be applied.",
            call. = FALSE)
  }
  ef_org_mu[is.na(ef_org_mu)] <- 0
  
  # ---------- Organic WD (Waste disposal / Level 2 = "Refuse") ----------
  org_wd_tbl <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                  .data[["Level 2"]] == "Refuse",
                  .data[["Column Text"]] == compost_waste_disposal) |>
    dplyr::transmute(key = norm(.data[["Level 3"]]), val = .data[[value_col]]) |>
    dplyr::distinct(key, .keep_all = TRUE)
  # strip leading 'organic_' in keys like 'organic_food_and_drink_waste'
  org_wd_tbl$key <- sub("^organic_", "", org_wd_tbl$key)
  
  wd_map <- c(food = "food_and_drink_waste",
              drink = "food_and_drink_waste",
              compost_from_garden = "garden_waste",
              compost_from_food_and_garden = "food_and_garden_waste")
  ef_org_wd <- stats::setNames(rep(NA_real_, length(org_names)), org_names)
  for (nm in names(wd_map)) {
    k <- wd_map[[nm]]
    hit <- which(org_wd_tbl$key == k)[1]
    if (length(hit) && !is.na(hit)) ef_org_wd[[nm]] <- org_wd_tbl$val[[hit]]
  }
  miss_org_wd <- names(org_waste_vec)[org_waste_vec > 0 & is.na(ef_org_wd)]
  if (strict && length(miss_org_wd)) {
    stop("No WD factor (", compost_waste_disposal, ") for organic: ",
         paste(miss_org_wd, collapse = ", "), call. = FALSE)
  }
  ef_org_wd[is.na(ef_org_wd)] <- 0
  org_kg <- sum(org_use_vec * ef_org_mu) + sum(org_waste_vec * ef_org_wd)
  
  # ---------- Household residual waste ----------
  hrw_tbl <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                  norm(.data[["Level 3"]]) == "household_residual_waste",
                  .data[["Column Text"]] == hh_waste_disposal)
  ef_hrw <- if (nrow(hrw_tbl)) hrw_tbl[[value_col]][1] else NA_real_
  if (strict && household_residual_waste > 0 && is.na(ef_hrw)) {
    stop("No WD factor for Household residual waste (", hh_waste_disposal, ").", call. = FALSE)
  }
  if (is.na(ef_hrw)) ef_hrw <- 0
  hrw_kg <- household_residual_waste * ef_hrw
  
  # ---------- total ----------
  total_kg <- fam_kg + gcb_kg + org_kg + hrw_kg
  if (units == "tonnes") total_kg <- total_kg * 0.001
  total_kg
}
