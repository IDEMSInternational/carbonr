#' Office emissions (uses building_emissions + homeworking factors)
#'
#' Computes office emissions either from a per-person average (when `specify = FALSE`)
#' or from specified utilities via [building_emissions()] (when `specify = TRUE`),
#' plus optional **homeworking** emissions (Level 1 = "Homeworking").
#'
#' Factors are assumed **kg CO2e per unit** (e.g., per person-hour for homeworking),
#' and the result is returned in requested `units`.
#'
#' @param specify Logical. If `FALSE`, use an average per person; if `TRUE`, use
#'   the specified utility inputs (water/electricity/heat) via [building_emissions()].
#' @param office_num Number of individuals in the office (only used when `specify = FALSE`).
#'   Uses a constant of **2600 kg CO2e per person-year**.
#' @param WFH_num Number of people working from home.
#' @param WFH_hours Hours worked from home **per person**.
#'   If one of `WFH_num`/`WFH_hours` is zero but the other is > 0, the zero one is treated as 1.
#' @param WFH_type Which homeworking components to include; any of
#'   `c("Office Equipment","Heating")`. Default is both.
#' @param water_supply See [building_emissions()].
#' @param water_trt See [building_emissions()].
#' @param water_unit See [building_emissions()].
#' @param electricity_kWh,electricity_TD,electricity_WTT See [building_emissions()].
#' @param heat_kWh,heat_TD,heat_WTT See [building_emissions()].
#' @param units Output units: `"kg"` (default) or `"tonnes"`.
#' @param value_col Which factor column to use in `uk_gov_data`: `"value"` or `"value_2024"`.
#' @param strict If `TRUE` (default), error when needed factors (e.g., homeworking)
#'   are missing. If `FALSE`, treat missing factors as 0.
#'
#' @return Numeric total emissions in requested `units`.
#' @export
#'
#' @examples
#' # 1) Use specified utilities (building_emissions) + homeworking
#' office_emissions(
#'   specify = TRUE,
#'   electricity_kWh = 200, heat_kWh = 100,
#'   water_supply = 10, water_unit = "cubic metres",
#'   WFH_num = 5, WFH_hours = 8, WFH_type = c("Office Equipment","Heating")
#' )
#'
#' # 2) Use per-person average for 12 staff, with WFH equipment only
#' office_emissions(
#'   specify = FALSE, office_num = 12,
#'   WFH_num = 6, WFH_hours = 4, WFH_type = "Office Equipment",
#'   units = "tonnes"
#' )
office_emissions <- function(
    specify = FALSE, office_num = 1,
    WFH_num = 0, WFH_hours = 0,
    WFH_type = c("Office Equipment", "Heating"),
    water_supply = 0, water_trt = TRUE,
    water_unit = c("cubic metres", "million litres"),
    electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
    heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE,
    units = c("kg","tonnes"),
    value_col = c("value","value_2024"),
    strict = TRUE
){
  # args & checks
  units     <- match.arg(units)
  value_col <- match.arg(value_col)
  water_unit <- match.arg(water_unit)
  WFH_type  <- match.arg(WFH_type, choices = c("Office Equipment","Heating"), several.ok = TRUE)
  
  checkmate::assert_flag(specify)
  checkmate::assert_number(office_num, lower = 0)
  checkmate::assert_number(WFH_num, lower = 0)
  checkmate::assert_number(WFH_hours, lower = 0)
  
  # --- Homeworking (Level 1 == "Homeworking"; Level 2 in WFH_type) ---
  wfh_kg <- 0
  if (WFH_num > 0 || WFH_hours > 0) {
    # if user only set one, treat the other as 1
    if (WFH_num == 0)   WFH_num   <- 1
    if (WFH_hours == 0) WFH_hours <- 1
    
    wfh_tbl <- uk_gov_data |>
      dplyr::filter(.data[["Level 1"]] == "Homeworking",
                    .data[["Level 2"]] %in% WFH_type)
    
    # sum chosen components
    if (nrow(wfh_tbl) == 0) {
      if (strict) stop("Missing homeworking factor(s) for: ",
                       paste(WFH_type, collapse = ", "),
                       call. = FALSE)
      hw_fac <- 0
    } else {
      hw_fac <- sum(wfh_tbl[[value_col]], na.rm = TRUE)
      if (is.na(hw_fac)) {
        if (strict) stop("Homeworking factor is NA for selected components.", call. = FALSE)
        hw_fac <- 0
      }
    }
    wfh_kg <- hw_fac * WFH_num * WFH_hours
  }
  
  # --- Base office (either average-per-person OR building_emissions) ---
  if (!isTRUE(specify)) {
    # 2600 kg CO2e / person-year (constant)
    base_kg <- 2600 * office_num
  } else {
    base_kg <- building_emissions(
      water_supply = water_supply, water_trt = water_trt, water_unit = water_unit,
      electricity_kWh = electricity_kWh, electricity_TD = electricity_TD, electricity_WTT = electricity_WTT,
      heat_kWh = heat_kWh, heat_TD = heat_TD, heat_WTT = heat_WTT,
      units = "kg", value_col = value_col, strict = strict
    )
  }
  
  total_kg <- base_kg + wfh_kg
  if (units == "tonnes") total_kg <- total_kg * 0.001
  total_kg
}
