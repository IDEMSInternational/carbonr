#' Electrical emissions
#'
#' Computes embodied GHG emissions for electrical items using `uk_gov_data` rows with
#' Level 2 = "Electrical items". Material-use factors come from
#' `Level 1 = "Material use", Column Text = material_production` (your table
#' currently provides Primary material production only). Waste factors come
#' from `Level 1 = "Waste disposal", Column Text = waste_disposal`.
#' Factors are kg CO2e per tonne.
#'
#' @param use Named numeric vector of quantities in tonnes.
#'   Canonical names supported:
#'   `fridges`, `freezers`, `large_electrical`, `it`, `small_electrical`,
#'   `alkaline_batteries`, `liion_batteries`, `nimh_batteries`.
#'   Aliases accepted (case/punct-insensitive), e.g. `"fridge"`, `"freezer"`,
#'   `"large"`, `"it equipment"`, `"small"`, `"alkaline"`, `"liion"`, `"ni mh"`,
#'   Unknown names warn and are ignored.
#' @param waste Logical. If `TRUE`, waste tonnages equal `use`. If `FALSE`, no waste.
#' @param material_production Either a single string for all items
#'   (e.g., `"Primary material production"`) or a named vector per item.
#'   Synonyms accepted: `"primary"`, `"closed loop"`, etc. (If a chosen option is
#'   absent in the table, behaviour depends on `strict`.)
#' @param waste_disposal One of `"Landfill"` or `"Open-loop"`. Applied to all waste.
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param value_col Which numeric column to use: `"value"` or `"value_2024"`.
#' @param strict If `TRUE` (default), error when any nonzero `use`/waste needs a
#'   factor missing from the table. If `FALSE`, treat missing factors as `0`.
#'
#' @return Numeric total emissions in requested `units`.
#'
#' @examples
#' # Primary production + landfill; waste = use
#' electrical_emissions(
#'   use = c(fridges = 1, freezers = 0.5, large_electrical = 0.2),
#'   waste_disposal = "Landfill",
#'   waste = TRUE,
#'   units = "kg"
#' )
#'
#' # 2024 factors, no waste, report in tonnes
#' electrical_emissions(
#'   use = c(it = 0.01, liion_batteries = 0.002),
#'   value_col = "value_2024",
#'   waste = FALSE,
#'   units = "tonnes"
#' )
electrical_emissions <- function(
    use                 = setNames(numeric(), character()),
    waste               = TRUE,
    material_production = "Primary material production",
    waste_disposal      = c("Landfill", "Open-loop"),
    units               = c("kg", "tonnes"),
    value_col           = c("value", "value_2024"),
    strict              = TRUE
) {
  waste_disposal <- match.arg(waste_disposal)
  units          <- match.arg(units)
  value_col      <- match.arg(value_col)
  
  # Canonical keys we expose
  el_names <- c("fridges","freezers","large_electrical","it","small_electrical",
                "alkaline_batteries","liion_batteries","nimh_batteries")
  
  # Robust normaliser: drop prefixes like "Electrical items - " / "Batteries - ",
  # drop trailing "(...)", unify punctuation
  norm_el <- function(x){
    x <- tolower(trimws(x))
    x <- sub(".*?:\\s*", "", x)        # drop up to colon (rare)
    x <- sub(".*?-\\s*",  "", x)       # drop up to dash
    x <- sub("\\s*\\(.*\\)$", "", x)   # drop "(...)"
    x <- gsub("[^a-z0-9]+", "_", x)
    x <- gsub("^_+|_+$", "", x)
    x <- gsub("_+", "_", x)
    x
  }
  
  # Map variants/aliases to canonical keys
  canon_el_keys <- function(nm) switch(nm,
                                       # Table's combined row → both fridges & freezers
                                       "fridges_and_freezers" = c("fridges","freezers"),
                                       "fridge_and_freezer"   = c("fridges","freezers"),
                                       # singular/plural & common aliases
                                       "fridge"               = "fridges",
                                       "fridges"              = "fridges",
                                       "freezer"              = "freezers",
                                       "freezers"             = "freezers",
                                       "large"                = "large_electrical",
                                       "large_electrical"     = "large_electrical",
                                       "it"                   = "it",
                                       "it_equipment"         = "it",
                                       "small"                = "small_electrical",
                                       "small_electrical"     = "small_electrical",
                                       "alkaline"             = "alkaline_batteries",
                                       "alkaline_batteries"   = "alkaline_batteries",
                                       "li-ion"               = "liion_batteries",
                                       "li_ion"               = "liion_batteries",
                                       "liion"                = "liion_batteries",
                                       "liion_batteries"      = "liion_batteries",
                                       "nimh"                 = "nimh_batteries",
                                       "ni_mh"                = "nimh_batteries",
                                       "nimh_batteries"       = "nimh_batteries",
                                       nm
  )
  
  # Map WD Level 3 to canonical keys (handles WEEE groupings + Batteries)
  canon_el_wd_keys <- function(nm) switch(nm,
                                          "fridges_and_freezers" = c("fridges","freezers"),
                                          "large"                = "large_electrical",
                                          "small"                = "small_electrical",
                                          "mixed"                = "it",
                                          "batteries"            = c("alkaline_batteries","liion_batteries","nimh_batteries"),
                                          nm
  )
  
  # Expand user input to canonical names, WARNING on unknowns
  expand_vec <- function(x) {
    if (length(x) == 0) return(stats::setNames(numeric(length(el_names)), el_names))
    checkmate::assert_numeric(x, lower = 0, any.missing = FALSE, names = "named")
    
    raw_names  <- names(x)
    norm_names <- norm_el(raw_names)
    keys_list  <- lapply(norm_names, canon_el_keys)
    
    unknown_idx <- vapply(keys_list, function(k) all(!(k %in% el_names)), logical(1))
    if (any(unknown_idx)) {
      warning(
        "Ignoring unknown electrical material name(s): ",
        paste(unique(raw_names[unknown_idx]), collapse = ", "),
        call. = FALSE
      )
    }
    
    out <- stats::setNames(numeric(length(el_names)), el_names)
    for (i in seq_along(x)) {
      ks <- keys_list[[i]]
      for (k in ks) if (k %in% el_names) out[k] <- out[k] + x[[i]]
    }
    out
  }
  
  use_vec   <- expand_vec(use)
  waste_vec <- if (isTRUE(waste)) use_vec else stats::setNames(numeric(length(el_names)), el_names)
  
  # -------- material_production resolution (scalar or per-item) --------
  choices_use <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Material use",
                  .data[["Level 2"]] == "Electrical items") |>
    dplyr::distinct(`Column Text`) |>
    dplyr::pull()
  
  norm_ct <- function(x) gsub("[^a-z]+","", tolower(x))
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
    mp_vec <- stats::setNames(rep(default_ct, length(el_names)), el_names)
  } else {
    checkmate::assert_character(material_production, any.missing = FALSE, names = "named")
    mp_vec <- stats::setNames(rep(resolve_ct("Primary material production"), length(el_names)), el_names)
    nm <- names(material_production)
    nm <- norm_el(nm)
    # map each provided name to canonical and set its CT
    for (i in seq_along(material_production)) {
      ks <- canon_el_keys(nm[i])
      for (k in ks) if (k %in% el_names) mp_vec[k] <- resolve_ct(material_production[[i]])
    }
  }
  
  # -------- factor builders --------
  # Material use (respect per-item CT). Table's combined row should propagate to fridges & freezers.
  ef_use <- {
    out <- stats::setNames(rep(NA_real_, length(el_names)), el_names)
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Material use",
                    .data[["Level 2"]] == "Electrical items") |>
      dplyr::transmute(keys = lapply(norm_el(.data[["Level 3"]]), canon_el_keys),
                       ct   = .data[["Column Text"]],
                       val  = .data[[value_col]])
    for (i in seq_len(nrow(tbl))) {
      ks <- tbl$keys[[i]]
      for (k in ks) {
        if (k %in% el_names && tbl$ct[i] == mp_vec[[k]] && is.na(out[k])) {
          out[k] <- tbl$val[i]
        }
      }
    }
    out
  }
  
  # Waste (single route for all). WEEE rows & generic "Batteries" are expanded to the right items.
  ef_waste <- {
    out <- stats::setNames(rep(NA_real_, length(el_names)), el_names)
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                    .data[["Level 2"]] == "Electrical items",
                    .data[["Column Text"]] == waste_disposal) |>
      dplyr::transmute(keys = lapply(norm_el(.data[["Level 3"]]), canon_el_wd_keys),
                       val  = .data[[value_col]])
    for (i in seq_len(nrow(tbl))) {
      ks <- tbl$keys[[i]]
      for (k in ks) if (k %in% el_names && is.na(out[k])) out[k] <- tbl$val[i]
    }
    out
  }
  
  # -------- validate BEFORE zero-fill --------
  miss_use   <- names(use_vec)[use_vec > 0 & is.na(ef_use)]
  miss_waste <- names(waste_vec)[waste_vec > 0 & is.na(ef_waste[names(waste_vec)])]
  if (strict && length(miss_use)) {
    stop("No material-use factor for electrical items (", paste(miss_use, collapse = ", "),
         "); set strict = FALSE to treat as 0.")
  }
  if (strict && length(miss_waste)) {
    stop("No waste-disposal factor (", waste_disposal, ") for electrical items: ",
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
