#' Metal emissions (UK govt schema; table-driven, with material_production)
#'
#' Computes embodied GHG emissions for metals using `uk_gov_data` rows with
#' Level 2 = "Metal". Material-use factors come from
#' `Level 1 = "Material use", Column Text = material_production`. Waste factors
#' come from `Level 1 = "Waste disposal", Column Text = waste_disposal`.
#' Factors are kg CO2e per tonne.
#'
#' @param use Named numeric vector of metal quantities in tonnes.
#'   Canonical names supported: `aluminium`, `mixed_cans`, `scrap`, `steel_cans`.
#'   Aliases accepted (case/punct/UK-US spelling-insensitive), e.g.:
#'   `"Metal: aluminium cans and foil (excl. forming)"`, `aluminum_cans`,
#'   `aluminium_foil`, `mixed`, `scrap_metal`, etc.
#'   Unknown names warn and are ignored.
#' @param waste Logical. If `TRUE`, waste tonnages are the same as `use`.
#'   If `FALSE`, no waste is applied.
#' @param material_production Either a single string applied to all metals, or a
#'   named vector per metal type. Accepted values (matched leniently):
#'   `"Primary material production"`, `"Closed-loop source"`, `"Closed-loop"`,
#'   `"Open-loop"`, `"Combustion"`, `"Landfill"`.
#'   Synonyms accepted: `"primary"`, `"closed loop"`, `"open loop"`, etc.
#'   Unspecified metals default to `"Primary material production"`.
#' @param waste_disposal One of `"Closed-loop"`, `"Combustion"`, `"Landfill"`,
#'   `"Open-loop"`. Applied to all waste.
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param value_col Which numeric column in `uk_gov_data` to use: `"value"` or `"value_2024"`.
#' @param strict If `TRUE` (default), error when any nonzero `use`/waste needs a
#'   factor absent in the table. If `FALSE`, treat missing factors as 0.
#'
#' @return Numeric total emissions in requested `units`.
#'
#' @examples
#' # Primary for all; landfill; waste = use
#' metal_emissions(
#'   use = c(aluminium = 1.2, steel_cans = 0.4),
#'   material_production = "Primary material production",
#'   waste_disposal = "Landfill",
#'   waste = TRUE,
#'   units = "kg"
#' )
#'
#' # Per-metal: aluminium closed-loop source, others primary; no waste; 2024 factors
#' metal_emissions(
#'   use = c(`Metal: aluminium cans and foil (excl. forming)` = 0.5, mixed_cans = 0.2),
#'   material_production = c(aluminium = "closed loop"),
#'   waste = FALSE,
#'   value_col = "value_2024",
#'   units = "tonnes"
#' )
metal_emissions <- function(
    use                 = setNames(numeric(), character()),
    waste               = TRUE,
    material_production = "Primary material production",
    waste_disposal      = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
    units               = c("kg", "tonnes"),
    value_col           = c("value", "value_2024"),
    strict              = TRUE
) {
  waste_disposal <- match.arg(waste_disposal)
  units          <- match.arg(units)
  value_col      <- match.arg(value_col)
  
  # Canonical keys we expose
  mt_names <- c("aluminium","mixed_cans","scrap","steel_cans")
  
  # Robust normaliser: drop "Metal: ", drop trailing "(...)", squash punctuation
  norm_mt <- function(x){
    x <- tolower(trimws(x))
    x <- sub(".*?:\\s*", "", x)        # drop "Metal: "
    x <- sub("\\s*\\(.*\\)$", "", x)   # drop "(...)"
    x <- gsub("[^a-z0-9]+", "_", x)
    x <- gsub("^_+|_+$", "", x)
    x <- gsub("_+", "_", x)
    x
  }
  
  # Map variants/aliases to canonical keys
  canon_metal_keys <- function(nm) switch(nm,
                                          # aluminium (UK/US spellings + cans/foil variants + table label)
                                          "aluminium_cans_and_foil_excl_forming" = "aluminium",
                                          "aluminium_cans_and_foil"              = "aluminium",
                                          "aluminium_cans"                       = "aluminium",
                                          "aluminium_foil"                       = "aluminium",
                                          "aluminum_cans"                        = "aluminium",
                                          "aluminum_foil"                        = "aluminium",
                                          "aluminium"                            = "aluminium",
                                          "aluminum"                             = "aluminium",
                                          # mixed cans
                                          "mixed_cans"                           = "mixed_cans",
                                          "mixed_metal_cans"                     = "mixed_cans",
                                          "mixed"                                = "mixed_cans",
                                          # scrap metal
                                          "scrap_metal"                          = "scrap",
                                          "scrap"                                = "scrap",
                                          # steel cans
                                          "steel_cans"                           = "steel_cans",
                                          nm
  )
  
  # Expand user input to canonical names, warn on unknowns
  expand_vec <- function(x) {
    if (length(x) == 0) return(stats::setNames(numeric(length(mt_names)), mt_names))
    checkmate::assert_numeric(x, lower = 0, any.missing = FALSE, names = "named")
    
    raw_names  <- names(x)
    norm_names <- norm_mt(raw_names)
    keys_list  <- lapply(norm_names, canon_metal_keys)
    
    unknown_idx <- vapply(keys_list, function(k) all(!(k %in% mt_names)), logical(1))
    if (any(unknown_idx)) {
      warning(
        "Ignoring unknown metal material name(s): ",
        paste(unique(raw_names[unknown_idx]), collapse = ", "),
        call. = FALSE
      )
    }
    
    out <- stats::setNames(numeric(length(mt_names)), mt_names)
    for (i in seq_along(x)) {
      k <- canon_metal_keys(norm_names[i])
      if (k %in% mt_names) out[k] <- out[k] + x[[i]]
    }
    out
  }
  
  use_vec   <- expand_vec(use)
  waste_vec <- if (isTRUE(waste)) use_vec else stats::setNames(numeric(length(mt_names)), mt_names)
  
  # ----- material_production resolution (scalar or per-material) -----
  choices_use <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Material use",
                  .data[["Level 2"]] == "Metal") |>
    dplyr::distinct(`Column Text`) |>
    dplyr::pull()
  
  norm_ct  <- function(x) gsub("[^a-z]+","", tolower(x))
  resolve_ct <- function(desired) {
    if (length(choices_use) == 0) return(NA_character_)
    if (is.na(desired) || desired == "") return(NA_character_)
    d <- norm_ct(desired)
    syn <- list(
      primary          = "Primary material production",
      closedloop       = "Closed-loop source",
      closedloopsource = "Closed-loop source",
      closed_loop      = "Closed-loop source",
      openloop         = "Open-loop",
      combustion       = "Combustion",
      landfill         = "Landfill"
    )
    if (d %in% names(syn)) desired <- syn[[d]]
    cn <- norm_ct(choices_use)
    hit <- which(cn == norm_ct(desired))
    if (length(hit) >= 1) return(choices_use[hit][1])
    hit2 <- which(grepl(norm_ct(desired), cn, fixed = TRUE))
    if (length(hit2) >= 1) return(choices_use[hit2][1])
    NA_character_
  }
  
  is_per_material <- (length(material_production) >= 1 &&
                        !is.null(names(material_production)) &&
                        any(nzchar(names(material_production))))
  
  if (!is_per_material) {
    default_ct <- resolve_ct(material_production[[1]])
    mp_vec <- stats::setNames(rep(default_ct, length(mt_names)), mt_names)
  } else {
    checkmate::assert_character(material_production, any.missing = FALSE, names = "named")
    mp_vec <- stats::setNames(rep(resolve_ct("Primary material production"), length(mt_names)), mt_names)
    nm <- names(material_production)
    nm <- norm_mt(nm)
    nm <- vapply(nm, canon_metal_keys, character(1))
    for (i in seq_along(material_production)) {
      k <- nm[i]
      if (k %in% mt_names) mp_vec[k] <- resolve_ct(material_production[[i]])
    }
  }
  
  # ----- factor builders -----
  # Material use factors (respect per-metal Column Text)
  ef_use <- {
    out <- stats::setNames(rep(NA_real_, length(mt_names)), mt_names)
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Material use",
                    .data[["Level 2"]] == "Metal") |>
      dplyr::transmute(key = vapply(norm_mt(.data[["Level 3"]]), canon_metal_keys, character(1)),
                       ct  = .data[["Column Text"]],
                       val = .data[[value_col]])
    for (k in mt_names) {
      sel <- tbl$key == k & tbl$ct == mp_vec[[k]]
      if (any(sel)) out[k] <- tbl$val[which(sel)[1]]
    }
    out
  }
  
  # Waste factors (single route)
  ef_waste <- {
    out <- stats::setNames(rep(NA_real_, length(mt_names)), mt_names)
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                    .data[["Level 2"]] == "Metal",
                    .data[["Column Text"]] == waste_disposal) |>
      dplyr::transmute(key = vapply(norm_mt(.data[["Level 3"]]), canon_metal_keys, character(1)),
                       val = .data[[value_col]])
    for (k in mt_names) {
      sel <- tbl$key == k
      if (any(sel)) out[k] <- tbl$val[which(sel)[1]]
    }
    out
  }
  
  # ----- validate BEFORE zero-fill -----
  miss_use   <- names(use_vec)[use_vec > 0 & is.na(ef_use)]
  miss_waste <- names(waste_vec)[waste_vec > 0 & is.na(ef_waste[names(waste_vec)])]
  if (strict && length(miss_use)) {
    stop("No material-use factor for metal (", paste(miss_use, collapse = ", "),
         ") with material_production; set strict = FALSE to treat as 0.")
  }
  if (strict && length(miss_waste)) {
    stop("No waste-disposal factor (", waste_disposal, ") for metal: ",
         paste(miss_waste, collapse = ", "),
         ". Set strict = FALSE to treat as 0.")
  }
  
  # zero-fill for arithmetic
  ef_use[is.na(ef_use)]     <- 0
  ef_waste[is.na(ef_waste)] <- 0
  
  total_kg <- sum(use_vec * ef_use) + sum(waste_vec * ef_waste)
  if (units == "tonnes") total_kg <- total_kg * 0.001
  total_kg
}
