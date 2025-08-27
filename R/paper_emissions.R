#' Paper emissions
#'
#' Computes embodied GHG emissions for paper using `uk_gov_data` rows with
#' Level 2 = "Paper". Material-use factors come from
#' `Level 1 = "Material use", Column Text = material_production`.
#' Waste factors come from `Level 1 = "Waste disposal", Column Text = waste_disposal`.
#' Factors are kg CO2e per tonne.
#'
#' @param use Named numeric vector of paper quantities in tonnes.
#'   Names matched case/space/punctuation-insensitively to `Level 3`
#'   (drops a leading `"Paper: "` prefix and trailing parentheses).
#'   Canonical names: `board`, `mixed`, `paper`. Unknown names warn and are ignored.
#' @param waste Logical. If `TRUE`, waste tonnages are the same as `use`.
#'   If `FALSE`, no waste is applied.
#' @param material_production Either a single string applied to all paper types
#'   (e.g., `"Primary material production"` or `"Closed-loop source"`),
#'   or a named vector per paper type, e.g.
#'   `c(board = "Closed-loop source", mixed = "Primary material production")`.
#'   If you provide a per-material vector for a subset, unspecified types default to
#'   `"Primary material production"`.
#' @param waste_disposal One of `"Closed-loop"`, `"Combustion"`, `"Composting"`, `"Landfill"`.
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param value_col Which numeric column in `uk_gov_data` to use: `"value"` or `"value_2024"`.
#' @param strict If `TRUE` (default), error when any nonzero `use`/waste needs a
#'   factor that is absent in the table. If `FALSE`, treat missing factors as 0.
#'
#' @return Numeric total emissions in requested `units`.
#'
#' @examples
#' # Closed-loop source for all paper types; landfill; waste = use
#' paper_emissions(
#'   use = c(board = 10, paper = 100),
#'   material_production = "Closed-loop source",
#'   waste_disposal = "Landfill",
#'   waste = TRUE
#' )
#'
#' # Per-material: board closed-loop, mixed primary (default), no waste
#' paper_emissions(
#'   use = c(board = 5, mixed = 2),
#'   material_production = c(board = "closed loop"),
#'   waste = FALSE,
#'   value_col = "value_2024",
#'   units = "tonnes"
#' )
paper_emissions <- function(
    use                 = setNames(numeric(), character()),
    waste               = TRUE,
    material_production = "Primary material production",
    waste_disposal      = c("Closed-loop", "Combustion", "Composting", "Landfill"),
    units               = c("kg", "tonnes"),
    value_col           = c("value", "value_2024"),
    strict              = TRUE
) {
  waste_disposal <- match.arg(waste_disposal)
  units          <- match.arg(units)
  value_col      <- match.arg(value_col)
  
  # Canonical set we support
  pa_names <- c("board","mixed","paper")
  
  # Robust normaliser for names
  norm_pa <- function(x){
    x <- tolower(trimws(x))
    x <- sub(".*?:\\s*", "", x)        # drop "Paper: "
    x <- sub("\\s*\\(.*\\)$", "", x)   # drop "(...)"
    x <- gsub("[^a-z0-9]+", "_", x)
    x <- gsub("^_+|_+$", "", x)
    x <- gsub("_+", "_", x)
    x
  }
  
  # Map variants to canonical
  canon_paper_keys <- function(nm) switch(nm,
                                          "paper_board"   = "board",
                                          "cardboard"     = "board",
                                          "board"         = "board",
                                          "paper_mixed"   = "mixed",
                                          "mixed_paper"   = "mixed",
                                          "mixed"         = "mixed",
                                          "paper"         = "paper",
                                          nm
  )
  
  # Expand user input to canonical set, warn on unknowns
  expand_vec <- function(x) {
    if (length(x) == 0) return(stats::setNames(numeric(length(pa_names)), pa_names))
    checkmate::assert_numeric(x, lower = 0, any.missing = FALSE, names = "named")
    
    raw_names  <- names(x)
    norm_names <- norm_pa(raw_names)
    keys_list  <- lapply(norm_names, canon_paper_keys)
    
    unknown_idx <- vapply(keys_list, function(k) all(!(k %in% pa_names)), logical(1))
    if (any(unknown_idx)) {
      warning(
        "Ignoring unknown paper material name(s): ",
        paste(unique(raw_names[unknown_idx]), collapse = ", "),
        call. = FALSE
      )
    }
    
    out <- stats::setNames(numeric(length(pa_names)), pa_names)
    for (i in seq_along(x)) {
      k <- canon_paper_keys(norm_names[i])
      if (k %in% pa_names) out[k] <- out[k] + x[[i]]
    }
    out
  }
  
  use_vec   <- expand_vec(use)
  waste_vec <- if (isTRUE(waste)) use_vec else stats::setNames(numeric(length(pa_names)), pa_names)
  
  # ----- material_production resolution (scalar or per-material) -----
  # available Column Text choices in table for Material use / Paper
  # ----- material_production resolution (scalar or per-material) -----
  choices_use <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Material use",
                  .data[["Level 2"]] == "Paper") |>
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
      closed_loop      = "Closed-loop source"
    )
    if (d %in% names(syn)) desired <- syn[[d]]
    cn <- norm_ct(choices_use)
    hit <- which(cn == norm_ct(desired))
    if (length(hit) >= 1) return(choices_use[hit][1])
    hit2 <- which(grepl(norm_ct(desired), cn, fixed = TRUE))
    if (length(hit2) >= 1) return(choices_use[hit2][1])
    NA_character_
  }
  
  # Decide mode correctly even for length-1 named vectors
  is_per_material <- (length(material_production) >= 1 &&
                        !is.null(names(material_production)) &&
                        any(nzchar(names(material_production))))
  
  if (!is_per_material) {
    # scalar mode
    default_ct <- resolve_ct(material_production[[1]])
    mp_vec <- stats::setNames(rep(default_ct, length(pa_names)), pa_names)
  } else {
    # per-material mode (supports single named element too)
    checkmate::assert_character(material_production, any.missing = FALSE, names = "named")
    mp_vec <- stats::setNames(rep(resolve_ct("Primary material production"), length(pa_names)), pa_names)
    nm <- names(material_production)
    nm <- norm_pa(nm)
    nm <- vapply(nm, canon_paper_keys, character(1))
    for (i in seq_along(material_production)) {
      k <- nm[i]
      if (k %in% pa_names) mp_vec[k] <- resolve_ct(material_production[[i]])
    }
  }
  
  # Factor builders (use material + chosen Column Text; waste is simple route)
  # Material use factors (respect per-material Column Text)
  ef_use <- {
    out <- stats::setNames(rep(NA_real_, length(pa_names)), pa_names)
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Material use",
                    .data[["Level 2"]] == "Paper") |>
      dplyr::transmute(key = vapply(norm_pa(.data[["Level 3"]]), canon_paper_keys, character(1)),
                       ct  = .data[["Column Text"]],
                       val = .data[[value_col]])
    # for each canonical key, pick value where ct == mp_vec[key]
    for (k in pa_names) {
      sel <- tbl$key == k & tbl$ct == mp_vec[[k]]
      if (any(sel)) out[k] <- tbl$val[which(sel)[1]]
    }
    out
  }
  
  # Waste factors (single route for all)
  ef_waste <- {
    out <- stats::setNames(rep(NA_real_, length(pa_names)), pa_names)
    tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Waste disposal",
                    .data[["Level 2"]] == "Paper",
                    .data[["Column Text"]] == waste_disposal) |>
      dplyr::transmute(key = vapply(norm_pa(.data[["Level 3"]]), canon_paper_keys, character(1)),
                       val = .data[[value_col]])
    for (k in pa_names) {
      sel <- tbl$key == k
      if (any(sel)) out[k] <- tbl$val[which(sel)[1]]
    }
    out
  }
  
  # Validate BEFORE zero-fill
  miss_use   <- names(use_vec)[use_vec > 0 & is.na(ef_use)]
  miss_waste <- names(waste_vec)[waste_vec > 0 & is.na(ef_waste[names(waste_vec)])]
  if (strict && length(miss_use)) {
    stop("No material-use factor for paper (", paste(miss_use, collapse = ", "),
         ") with material_production; set strict = FALSE to treat as 0.")
  }
  if (strict && length(miss_waste)) {
    stop("No waste-disposal factor (", waste_disposal, ") for paper: ",
         paste(miss_waste, collapse = ", "),
         ". Set strict = FALSE to treat as 0.")
  }
  
  # zero-fill
  ef_use[is.na(ef_use)]     <- 0
  ef_waste[is.na(ef_waste)] <- 0
  
  total_kg <- sum(use_vec * ef_use) + sum(waste_vec * ef_waste)
  if (units == "tonnes") total_kg <- total_kg * 0.001
  total_kg
}
