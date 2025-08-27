#' Building emissions (UK govt schema; table-driven)
#'
#' @param water_supply numeric, amount of water in the given unit.
#' @param water_trt logical, include treatment emissions (default TRUE).
#' @param water_unit "cubic metres" or "million litres".
#' @param electricity_kWh numeric kWh consumed.
#' @param electricity_TD logical, include T&D losses (default TRUE).
#' @param electricity_WTT logical, include WTT for electricity (default TRUE).
#' @param heat_kWh numeric kWh of heat/steam (onsite; excludes district).
#' @param heat_TD logical, include district heat distribution losses (default TRUE).
#' @param heat_WTT logical, include WTT for heat/steam (default TRUE).
#' @param units "kg" or "tonnes" for the result (default "kg").
#' @param value_col which factor column to use: "value" or "value_2024" (default "value").
#' @param strict logical, error if a required factor is missing (default TRUE).
#' @return numeric total CO2e in requested units.
#' @export
#'
#' @examples # specify emissions in an office
#' # Basic office: include water treatment, electricity TD+WTT, and heat TD+WTT
#' building_emissions(
#'   water_supply = 10, water_unit = "cubic metres", water_trt = TRUE,
#'   electricity_kWh = 100, electricity_TD = TRUE, electricity_WTT = TRUE,
#'   heat_kWh = 50, heat_TD = TRUE, heat_WTT = TRUE,
#'   units = "kg"
#' )
#' 
#' # Water only, in million litres, reported in tonnes, using 2024 factors
#' building_emissions(
#'   water_supply = 0.002, water_unit = "million litres", water_trt = TRUE,
#'   electricity_kWh = 0, heat_kWh = 0,
#'   value_col = "value_2024", units = "tonnes"
#' )
#' 
#' # Electricity without TD (but with WTT generation)
#' building_emissions(
#'   electricity_kWh = 10, electricity_TD = FALSE, electricity_WTT = TRUE,
#'   heat_kWh = 0, water_supply = 0
#' )
#' 
#' # Heat only, include WTT but exclude distribution
#' building_emissions(
#'   heat_kWh = 20, heat_TD = FALSE, heat_WTT = TRUE,
#'   water_supply = 0, electricity_kWh = 0
#' )
#' 
building_emissions <- function(
    water_supply = 0, water_trt = TRUE,
    water_unit = c("cubic metres","million litres"),
    electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
    heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE,
    units = c("kg","tonnes"),
    value_col = c("value","value_2024"),
    strict = TRUE
){
  # args
  water_unit  <- match.arg(water_unit)
  units       <- match.arg(units)
  value_col   <- match.arg(value_col)
  
  # validators
  checkmate::assert_number(water_supply, lower = 0)
  checkmate::assert_number(electricity_kWh, lower = 0)
  checkmate::assert_number(heat_kWh, lower = 0)
  
  # helper to extract a single (summed) scalar factor; returns NA if absent
  pull_sum <- function(df) {
    if (nrow(df) == 0) return(NA_real_)
    sum(df[[value_col]], na.rm = TRUE)
  }
  need_or_zero <- function(val, label) {
    if (is.na(val)) {
      if (strict) stop("Missing factor: ", label, call. = FALSE)
      return(0)
    }
    val
  }
  
  # ---- Water (supply + optional treatment), factors per chosen UOM ----
  water_supply_fac <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Water supply",
                  .data[["UOM"]] == water_unit) |>
    pull_sum() |>
    need_or_zero(paste0("Water supply (", water_unit, ")"))
  
  water_trt_fac <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Water treatment",
                  .data[["UOM"]] == water_unit) |>
    pull_sum()
  water_trt_fac <- if (isTRUE(water_trt))
    need_or_zero(water_trt_fac, paste0("Water treatment (", water_unit, ")"))
  else 0
  
  water_kg <- water_supply * (water_supply_fac + water_trt_fac)
  
  # ---- Electricity (generation + optional T&D + optional WTT) ----
  elec_gen <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "UK electricity") |>
    pull_sum() |>
    need_or_zero("UK electricity (generation)")
  
  elec_td <- 0
  if (isTRUE(electricity_TD)) {
    elec_td <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Transmission and distribution",
                    .data[["Level 2"]] == "T&D- UK electricity") |>
      pull_sum() |>
      need_or_zero("Electricity T&D")
    if (isTRUE(electricity_WTT)) {
      # add WTT for T&D if present
      td_wtt <- uk_gov_data |>
        dplyr::filter(.data[["Level 1"]] %in% c("WTT- UK electricity","WTT- UK & overseas elec"),
                      .data[["Level 2"]] == "WTT- UK electricity (T&D)") |>
        pull_sum()
      elec_td <- elec_td + (if (is.na(td_wtt) && strict) stop("Missing factor: Electricity WTT (T&D)", call. = FALSE)
                            else if (is.na(td_wtt)) 0 else td_wtt)
    }
  }
  
  elec_wtt_gen <- 0
  if (isTRUE(electricity_WTT)) {
    elec_wtt_gen <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] %in% c("WTT- UK electricity","WTT- UK & overseas elec"),
                    .data[["Level 2"]] == "WTT- UK electricity (generation)") |>
      pull_sum()
    elec_wtt_gen <- if (is.na(elec_wtt_gen) && strict) stop("Missing factor: Electricity WTT (generation)", call. = FALSE)
    else if (is.na(elec_wtt_gen)) 0 else elec_wtt_gen
  }
  
  elec_kg <- electricity_kWh * (elec_gen + elec_td + elec_wtt_gen)
  
  # ---- Heat & steam (onsite only; exclude district heat base factor) ----
  heat_base <- uk_gov_data |>
    dplyr::filter(.data[["Level 1"]] == "Heat and steam",
                  !.data[["Level 3"]] %in% c("District heat and steam")) |>
    pull_sum() |>
    need_or_zero("Heat and steam (onsite)")
  
  heat_td <- 0
  if (isTRUE(heat_TD)) {
    heat_td <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Transmission and distribution",
                    .data[["Level 2"]] == "Distribution - district heat & steam") |>
      pull_sum()
    heat_td <- if (is.na(heat_td) && strict) stop("Missing factor: Heat T&D (district distribution)", call. = FALSE)
    else if (is.na(heat_td)) 0 else heat_td
  }
  
  heat_wtt <- 0
  if (isTRUE(heat_WTT)) {
    heat_wtt <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "WTT- heat and steam",
                    .data[["Level 2"]] == "WTT- heat and steam") |>
      pull_sum()
    heat_wtt <- if (is.na(heat_wtt) && strict) stop("Missing factor: Heat WTT", call. = FALSE)
    else if (is.na(heat_wtt)) 0 else heat_wtt
  }
  
  heat_kg <- heat_kWh * (heat_base + heat_td + heat_wtt)
  
  total_kg <- water_kg + elec_kg + heat_kg
  if (units == "tonnes") total_kg <- total_kg * 0.001
  total_kg
}
