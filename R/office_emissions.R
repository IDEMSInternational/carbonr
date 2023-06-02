#' Office emissions
#' 
#' 
#' @param specify logical. Whether an average should be used, or if the amount of energy used will be specified.
#' @param office_num If `specify = FALSE`, the number of individuals in the office. 
#' @param WFH_num Number of people working from home.
#' @param WFH_hours Number of hours working from home (per individual).
#' @param WFH_type Whether to account for `"Office Equipment"` and/or `"Heating"`. Default is both.
#' @param water_supply Amount of water used in the office.
#' @param water_trt logical. Default \code{TRUE}. Whether to include emissions associated with water treatment for used water.
#' @param water_unit Unit for `water_supply` variable. Options are `"cubic metres"` or `"million litres"`.
#' @param electricity_kWh Electricity used in kWh.
#' @param electricity_TD logical. Default \code{TRUE}. Whether to include emissions associated with grid losses.
#' @param electricity_WTT logical. Default \code{TRUE}. Whether to include emissions associated with extracting, refining, and transporting fuels.
#' @param heat_kWh heat and steam used in kWh.
#' @param heat_TD logical. Default \code{TRUE}. Whether to include emissions associated with grid losses.
#' @param heat_WTT logical. Default \code{TRUE}. Whether to include emissions associated with extracting, refining, and transporting fuels.
#' @return Returns CO2e emissions in tonnes.
#' @export
#'
#' @examples # specify emissions in an office
#' office_emissions(specify = TRUE, electricity_kWh = 200,
#'                  heat_kWh = 100, water_supply = 100, water_trt = FALSE)
#' 
#' @references Descriptions from 2022 UK Government Report: https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2022

office_emissions <- function(specify = FALSE, office_num = 1, WFH_num = 0, WFH_hours = 0,
                             WFH_type = c("Office Equipment", "Heating"), 
                             water_supply = 0, water_trt = TRUE, water_unit = c("cubic metres", "million litres"),
                             electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
                             heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE){
  
  checkmate::assert_logical(specify)
  checkmate::assert_numeric(office_num, lower = 0)
  checkmate::assert_numeric(WFH_num, lower = 0)
  checkmate::assert_numeric(WFH_hours, lower = 0)
  WFH_type <- match.arg(WFH_type, several.ok = TRUE)
  
  # Working from home
  if (WFH_num > 0 | WFH_hours > 0){
    if (WFH_num == 0){ WFH_num = 1 }
    if (WFH_hours == 0){ WFH_hours = 1 }
    uk_office_WFH <- uk_gov_data %>% dplyr::filter(`Level 1` %in% c("Homeworking"))
    WFH_emissions <- (uk_office_WFH %>% dplyr::filter(`Level 2` %in% WFH_type))$`GHG Conversion Factor 2022`
    if (length(WFH_type) > 1) { WFH_emissions <- sum(WFH_emissions) }
    WFH_emissions <- WFH_emissions*WFH_num*WFH_hours
  } else {
    WFH_emissions <- 0
  }
  
  if (specify == FALSE){
    # https://www.carbonfootprint.com/businesscalculator.aspx?c=BusBasic&t=b
    # 2600kg Co2e per person on average a year
    office_emissions <- 2600 * office_num
  } else {
    office_emissions <- building_emissions(water_supply = water_supply, water_trt = water_trt,
                                           water_unit = water_unit, electricity_kWh = electricity_kWh,
                                           electricity_TD = electricity_TD, electricity_WTT = electricity_WTT,
                                           heat_kWh = heat_kWh, heat_TD = heat_TD, heat_WTT = heat_WTT)
  }
  office_emissions <- office_emissions + WFH_emissions
  return(office_emissions * 0.001) 
}