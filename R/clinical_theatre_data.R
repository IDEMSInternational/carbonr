#' Clinical Emissions: Data Frame and Plot
#' 
#' @description Get the clinical theatre emissions after a data frame is inputted into the function.
#'
#' @inheritParams clinical_theatre_emissions
#' @param data Data frame containing all data to be used in the emissions calculation.
#' @param time Variable in `data` that corresponds to the time.
#' @param date_format The date format for the time variable (optional, default: c("%d/%m/%Y")).
#' @param name Variable in `data` that corresponds to the theatre name.
#' @param include_cpi Logical. Whether to calculate carbon price credit as well as emissions.
#' @param jurisdiction Jurisdiction for CPI.
#' @param year Year for CPI.
#' @param period Period for CPI.
#' @param manual_price Manually override CPI value.
#' @param gti_by Grouping type for GTI ("default", "month", "year").
#' @param overall_by Grouping type for overall plot ("default", "month", "year").
#' @param single_sheet Options are `NULL`, `TRUE` or `FALSE`. Whether to give summaries in one sheet, or a list.
#'
#' @return List with table of emissions (and CPI if requested), and plot object if `single_sheet` is not `NULL`.
#' @export
clinical_theatre_data <- function(
    data, time, date_format = "%d/%m/%Y", name,
    wet_clinical_waste, wet_clinical_waste_unit = c("tonnes", "kg"),
    desflurane = 0, sevoflurane = 0, isoflurane = 0, methoxyflurane = 0, N2O = 0, propofol = 0,
    water_supply = NULL, water_trt = TRUE, water_unit = c("cubic metres", "million litres"),
    electricity_kWh = NULL, electricity_TD = TRUE, electricity_WTT = TRUE,
    heat_kWh = NULL, heat_TD = TRUE, heat_WTT = TRUE,
    
    # *** NEW: map columns -> canonical material keys (names must be canonical) ***
    paper_vars        = NULL,  # e.g. c(board="board_col", mixed="mixed_col", paper="paper_col")
    plastic_vars      = NULL,  # e.g. c(average="general_waste", pet="pet_col", pp="pp_col")
    metal_vars        = NULL,  # e.g. c(aluminium="alu_col", steel="steel_col", ...)
    electrical_vars   = NULL,  # e.g. c(alkaline_batteries="aa_col", it="it_col", ...)
    construction_vars = NULL,  # e.g. c(concrete="conc_col", wood="wood_col", ...)
    
    # waste toggles (applied as in your new API)
    paper_waste = TRUE, plastic_waste = TRUE, metal_waste = TRUE,
    electrical_waste = TRUE, construction_waste = TRUE,
    
    # material production (use) choices for specific families
    paper_material_production        = "Primary material production",
    metal_material_production        = "Primary material production",
    construction_material_production = "Primary material production",
    
    # disposal routes
    paper_waste_disposal        = c("Closed-loop","Combustion","Composting","Landfill"),
    plastic_waste_disposal      = c("Landfill","Open-loop","Closed-loop","Combustion"),
    metal_waste_disposal        = c("Closed-loop","Combustion","Landfill","Open-loop"),
    electrical_waste_disposal   = c("Landfill","Open-loop"),
    construction_waste_disposal = c("Closed-loop","Combustion","Composting","Landfill","Open-loop"),
    
    # factor column + behaviour
    units = "kg", value_col = c("value","value_2024"), strict = TRUE,
    
    # CPI / plotting bits
    include_cpi = FALSE, jurisdiction = NULL, year = NULL, period = 0, manual_price = NULL,
    gti_by = c("default","month","year"), overall_by = c("default","month","year"),
    single_sheet = FALSE
){
  # args
  wet_clinical_waste_unit        <- match.arg(wet_clinical_waste_unit)
  paper_waste_disposal           <- match.arg(paper_waste_disposal)
  plastic_waste_disposal         <- match.arg(plastic_waste_disposal)
  metal_waste_disposal           <- match.arg(metal_waste_disposal)
  electrical_waste_disposal      <- match.arg(electrical_waste_disposal)
  construction_waste_disposal    <- match.arg(construction_waste_disposal)
  value_col                      <- match.arg(value_col)
  gti_by                         <- match.arg(gti_by)
  overall_by                     <- match.arg(overall_by)
  
  # capture core columns (as quos) and then pull numeric vectors (or zero if missing optional)
  qq <- rlang::enquo
  time_q   <- qq(time)
  name_q   <- qq(name)
  wcw_q    <- qq(wet_clinical_waste)
  desf_q   <- qq(desflurane)
  sevo_q   <- qq(sevoflurane)
  iso_q    <- qq(isoflurane)
  meth_q   <- qq(methoxyflurane)
  n2o_q    <- qq(N2O)
  prop_q   <- qq(propofol)
  water_q  <- qq(water_supply)
  elec_q   <- qq(electricity_kWh)
  heat_q   <- qq(heat_kWh)
  
  n <- nrow(data)
  pull_or_zero <- function(df, quo) {
    # returns numeric vector length n (0s if column not supplied)
    out <- tryCatch(dplyr::pull(df, !!quo), error = function(e) NULL)
    if (is.null(out)) rep(0, n) else as.numeric(out)
  }
  
  wcw  <- dplyr::pull(data, !!wcw_q)
  desf <- pull_or_zero(data, desf_q)
  sevo <- pull_or_zero(data, sevo_q)
  iso  <- pull_or_zero(data, iso_q)
  meth <- pull_or_zero(data, meth_q)
  n2o  <- pull_or_zero(data, n2o_q)
  prop <- pull_or_zero(data, prop_q)
  ws   <- pull_or_zero(data, water_q)
  e_kW <- pull_or_zero(data, elec_q)
  h_kW <- pull_or_zero(data, heat_q)
  
  # helper: build per-row named vectors from column-name mappings
  make_vecs <- function(df, mapping) {
    if (is.null(mapping) || length(mapping) == 0) {
      return(rep(list(stats::setNames(numeric(0), character(0))), nrow(df)))
    }
    if (is.null(names(mapping)) || any(!nzchar(names(mapping)))) {
      stop("All entries in *_vars must be a named character vector: names = canonical keys, values = column names.")
    }
    missing_cols <- setdiff(unname(mapping), names(df))
    if (length(missing_cols)) {
      stop("Column(s) not found in `data`: ", paste(missing_cols, collapse = ", "))
    }
    # build list of named vectors, one per row
    lapply(seq_len(nrow(df)), function(i) {
      vals <- vapply(mapping, function(col) as.numeric(df[[col]][i]), numeric(1))
      vals[is.na(vals)] <- 0
      stats::setNames(as.numeric(vals), names(mapping))
    })
  }
  
  paper_vecs        <- make_vecs(data, paper_vars)
  plastic_vecs      <- make_vecs(data, plastic_vars)
  metal_vecs        <- make_vecs(data, metal_vars)
  electrical_vecs   <- make_vecs(data, electrical_vars)
  construction_vecs <- make_vecs(data, construction_vars)
  
  # pmap over scalars + list-columns of vectors
  summary_emissions <- dplyr::tibble(
    !!rlang::as_name(time_q) := dplyr::pull(data, !!time_q),
    !!rlang::as_name(name_q) := dplyr::pull(data, !!name_q),
    emissions = purrr::pmap_dbl(
      list(wcw, desf, sevo, iso, meth, n2o, prop, ws, e_kW, h_kW,
           paper_vecs, plastic_vecs, metal_vecs, electrical_vecs, construction_vecs),
      ~ clinical_theatre_emissions(
        wet_clinical_waste = ..1,
        wet_clinical_waste_unit = wet_clinical_waste_unit,
        desflurane = ..2, sevoflurane = ..3, isoflurane = ..4,
        methoxyflurane = ..5, N2O = ..6, propofol = ..7,
        water_supply = ..8, electricity_kWh = ..9, heat_kWh = ..10,
        # pass the per-row named vectors:
        paper_use        = ..11,
        plastic_use      = ..12,
        metal_use        = ..13,
        electrical_use   = ..14,
        construction_use = ..15,
        # waste toggles + routes + options:
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
        units = units, value_col = value_col, strict = strict
      )
    )
  )
  
  # CPI / plotting branches (unchanged from your pattern)
  if (include_cpi) {
    summary_emissions <- summary_emissions |>
      dplyr::mutate(carbon_price_credit = carbon_price_credit(jurisdiction, year, period, manual_price, emissions))
    if (!is.null(single_sheet)) {
      out <- list()
      out[[1]] <- summary_emissions
      out[[2]] <- output_display(
        data = summary_emissions, time = !!time_q, date_format = date_format,
        name = !!name_q, relative_gpi_val = emissions, gti_by = gti_by,
        plot_val = carbon_price_credit, plot_by = overall_by, pdf = single_sheet
      )
      return(out)
    }
    return(summary_emissions)
  } else {
    if (!is.null(single_sheet)) {
      out <- list()
      out[[1]] <- summary_emissions
      out[[2]] <- output_display(
        data = summary_emissions, time = !!time_q, date_format = date_format,
        name = !!name_q, relative_gpi_val = emissions, gti_by = gti_by,
        plot_val = emissions, plot_by = overall_by, pdf = single_sheet
      )
      return(out)
    }
    return(summary_emissions)
  }
}