#' Calculate plastic emissions
#'
#' Computes embodied GHG emissions for plastics using `uk_gov_data` rows with
#' Level 2 = "Plastic". Material-use factors come from
#' `Level 1 = "Material use", Column Text = "Primary material production"`.
#' Waste factors come from `Level 1 = "Waste disposal", Column Text = waste_disposal`.
#' Factors are assumed kg CO2e per tonne (`UOM = tonne`, `GHG/Unit = kg CO2e`).
#'
#' @param use Named numeric vector of plastic quantities in tonnes.
#'   Names are matched (case/space/punctuation-insensitive) to `Level 3`
#'   after normalisation that also:
#'   1) removes any prefix up to `": "` (e.g., `"Plastics: HDPE"` is `"HDPE"`), and
#'   2) strips any trailing parenthetical (e.g., `"HDPE (bottles)"` is `"HDPE"`).
#'   Accepted types: `average`, `average_film`, `average_rigid`,
#'   `hdpe`, `ldpe`, `lldpe`, `pet`, `pp`, `ps`, `pvc`.
#'   Unknown names are ignored (treated as zero).
#' @param waste Logical. If `TRUE`, the same tonnages as `use` are sent to the
#'   chosen waste route. If `FALSE`, no waste is applied.
#' @param waste_disposal One of `"Landfill"`, `"Open-loop"`, `"Closed-loop"`,
#'   or `"Combustion"`. Applied to all waste. If a plastic lacks a factor for the
#'   chosen route, behaviour depends on `strict`.
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param value_col Which numeric column to use in `uk_gov_data`: `"value"` or `"value_2024"`.
#' @param strict If `TRUE` (default), error when any nonzero `use` or implied
#'   `waste` requires a factor that is absent in the table. If `FALSE`, treat
#'   missing factors as zero.
#'
#' @details
#' Material use: Plastics generally use `"Primary material production"`
#' as the `Column Text`. This function always uses that for material-use factors.
#'
#' Waste disposal: Factors are taken from the specified `waste_disposal`
#' route. Availability varies by plastic type and year; this is enforced by the
#' presence/absence of rows in `uk_gov_data`. Missing pairs error under
#' `strict = TRUE` or contribute zero under `strict = FALSE`.
#'
#' Units: Factors are kg CO2e per tonne; if `units = "tonnes"`, the total is
#' divided by 1000.
#'
#' @export
#' @return Numeric total emissions in requested `units`.
#'
#' @examples
#' # 1) Basic: primary material production + landfill; waste tonnage = use
#' plastic_emissions(
#'   use = c(average_plastics = 100, hdpe = 50, pet = 25),  # tonnes
#'   waste_disposal = "Landfill",
#'   waste = TRUE,
#'   units = "kg"
#' )
#'
#' # 2) Choose 2024 factors and report in tonnes; no waste applied
#' plastic_emissions(
#'   use = c(average_plastic_film = 10, average_plastic_rigid = 5, pp = 2),
#'   waste_disposal = "Closed-loop",
#'   waste = FALSE,
#'   value_col = "value_2024",
#'   units = "tonnes"
#' )
#'
#' # 3) Strict behaviour: error if a required waste route is unavailable
#' \dontrun{
#' plastic_emissions(
#'   use = c(ps = 1),
#'   waste_disposal = "Combustion",
#'   waste = TRUE,
#'   strict = TRUE
#' )}
#' # Tolerant: treat missing waste factors as 0
#' plastic_emissions(
#'   use = c(ps = 1),
#'   waste_disposal = "Combustion",
#'   waste = TRUE,
#'   strict = FALSE
#' )
plastic_emissions <- function(
    use        = stats::setNames(numeric(), character()),
    waste      = TRUE,
    waste_disposal = c("Landfill","Open-loop","Closed-loop","Combustion"),
    units      = c("kg","tonnes"),
    value_col  = c("value","value_2024"),
    strict     = TRUE
){
  waste_disposal <- match.arg(waste_disposal)
  units         <- match.arg(units)
  value_col     <- match.arg(value_col)
  
  # canonical keys we support (what callers can supply)
  pl_names <- c("average","average_film","average_rigid","hdpe","ldpe","lldpe","pet","pp","ps","pvc")
  
  # robust normaliser for both table Level 3 and user names
  norm_pl <- function(x) {
    x <- tolower(trimws(x))
    # strip "plastic(s) - " or "plastic(s): " prefixes (incl. en/em dashes)
    x <- gsub("^(plastics?|plastic)\\s*[-:--]\\s*", "", x)
    # drop trailing parentheses e.g. "pet (rigid)"
    x <- gsub("\\s*\\(.*?\\)\\s*$", "", x)
    # collapse non-alnum to underscore
    x <- gsub("[^a-z0-9]+", "_", x)
    x <- gsub("_+", "_", x)
    # unify common aliases/buckets
    x <- sub("^average_plastic$", "average", x)
    x <- sub("^average_plastics$", "average", x)
    x <- sub("^average_plastic_film$", "average_film", x)
    x <- sub("^average_plastic_rigid$", "average_rigid", x)
    # LDPE/LLDPE joint bucket as it appears in the table
    x <- sub("^ldpe_?/?_?lldpe$", "ldpe_and_lldpe", x)
    x
  }
  
  # map table or user tokens to canonical keys
  canon_pl_keys <- function(nm) switch(nm,
                                       "ldpe_and_lldpe"        = c("ldpe","lldpe"),
                                       "average_plastics"      = "average",
                                       "average_plastic"       = "average",
                                       "average_plastic_film"  = "average_film",
                                       "average_plastic_rigid" = "average_rigid",
                                       nm # default: pass through
  )
  
  # expand & validate user input
  expand_vec <- function(x) {
    if (length(x) == 0) return(stats::setNames(numeric(length(pl_names)), pl_names))
    checkmate::assert_numeric(x, lower = 0, any.missing = FALSE, names = "named")
    raw_names <- names(x)
    names(x) <- norm_pl(names(x))
    keys_list <- lapply(names(x), canon_pl_keys)
    
    # unknown if *all* mapped keys are outside pl_names
    unknown_idx <- vapply(keys_list, function(k) all(!(k %in% pl_names)), logical(1))
    if (any(unknown_idx)) {
      warning("Ignoring unknown plastic material name(s): ",
              paste(unique(raw_names[unknown_idx]), collapse = ", "),
              call. = FALSE)
    }
    
    out <- stats::setNames(numeric(length(pl_names)), pl_names)
    for (i in seq_along(x)) {
      ks <- keys_list[[i]]
      for (k in ks) if (k %in% pl_names) out[k] <- out[k] + x[[i]]
    }
    out
  }
  
  # build factor vectors from the table for MU / WD
  make_factor_vec <- function(level1, column_text) {
    out <- stats::setNames(rep(NA_real_, length(pl_names)), pl_names)
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == level1,
                    .data[["Level 2"]] == "Plastic",
                    .data[["Column Text"]] == column_text) |>
      dplyr::transmute(name = norm_pl(.data[["Level 3"]]),
                       val  = .data[[value_col]])
    # assign table rows to canonical keys (handling ldpe/ll dpe split)
    for (i in seq_len(nrow(tbl))) {
      keys <- canon_pl_keys(tbl$name[i])
      for (k in keys) if (k %in% pl_names && is.na(out[k])) out[k] <- tbl$val[i]
    }
    out
  }
  
  use_vec   <- expand_vec(use)
  waste_vec <- if (isTRUE(waste)) use_vec else stats::setNames(numeric(length(pl_names)), pl_names)
  
  ef_use   <- make_factor_vec("Material use",  "Primary material production")
  ef_waste <- make_factor_vec("Waste disposal", waste_disposal)
  
  # strict checks (before zero-fill)
  miss_use   <- names(use_vec)[use_vec > 0 & is.na(ef_use)]
  miss_waste <- names(waste_vec)[waste_vec > 0 & is.na(ef_waste[names(waste_vec)])]
  if (strict && length(miss_use)) {
    stop("No material-use factor for plastics: ", paste(miss_use, collapse = ", "),
         ". Set strict = FALSE to treat as 0.")
  }
  if (strict && length(miss_waste)) {
    stop("No waste-disposal factor (", waste_disposal, ") for plastics: ",
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
