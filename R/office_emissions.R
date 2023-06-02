#' Office emissions
#' 
#' Further options are given in the `raw_fuels` function.
#' 
#' @param specify logical. Whether an average should be used, or if the amount of energy used will be specified.
#' @param office_num If `specify = FALSE`, the number of individuals.
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
  checkmate::assert_logical(water_trt)
  checkmate::assert_logical(electricity_TD)
  checkmate::assert_logical(electricity_WTT)
  checkmate::assert_logical(heat_TD)
  checkmate::assert_logical(heat_WTT)
  checkmate::assert_numeric(office_num, lower = 0)
  checkmate::assert_numeric(WFH_num, lower = 0)
  checkmate::assert_numeric(WFH_hours, lower = 0)
  checkmate::assert_numeric(water_supply, lower = 0)
  checkmate::assert_numeric(electricity_kWh, lower = 0)
  checkmate::assert_numeric(heat_kWh, lower = 0)
  WFH_type <- match.arg(WFH_type, several.ok = TRUE)
  water_unit <- match.arg(water_unit)
  
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
    # Water supply and treatment
    if (water_supply > 0){
      uk_office_water <- uk_gov_data %>% dplyr::filter(`Level 1` %in% c("Water supply", "Water treatment"))
      uk_office_water <- (uk_office_water %>% dplyr::filter(UOM == {{ water_unit }}))$`GHG Conversion Factor 2022`
      if (!water_trt) {
        water_emissions <- uk_office_water[1] * water_supply
      } else {
        water_emissions <- sum(uk_office_water) * water_supply
      }
    } else {
      water_emissions <- 0
    }
    
    # Electricity
    if (electricity_kWh > 0){
      uk_office_electricity <- uk_gov_data %>%
        dplyr::filter(`Level 1` %in% c("Transmission and distribution", "UK electricity", "WTT- UK & overseas elec"))
      if (electricity_TD) {
        if (electricity_WTT){
          uk_office_electricity_TD <- sum((uk_office_electricity %>%
                                             dplyr::filter(`Level 2` %in% c("T&D- UK electricity", "WTT- UK electricity (T&D)")))$`GHG Conversion Factor 2022`)
        } else {
          uk_office_electricity_TD <- (uk_office_electricity %>%
            dplyr::filter(`Level 2` %in% c("T&D- UK electricity")))$`GHG Conversion Factor 2022`
        }
      } else {
        uk_office_electricity_TD <- 0
      }
      if (electricity_WTT){
        uk_office_electricity_WTT <- (uk_office_electricity %>%
                                        dplyr::filter(`Level 2` %in% c("WTT- UK electricity (generation)")))$`GHG Conversion Factor 2022`
      } else {
        uk_office_electricity_WTT <- 0
      }
      electricity_emissions <- electricity_kWh*((uk_office_electricity %>% dplyr::filter(`Level 1` == c("UK electricity")))$`GHG Conversion Factor 2022` +
                                                  uk_office_electricity_TD + uk_office_electricity_WTT)  
    } else {
      electricity_emissions <- 0
    }
    
    # Heat and steam
    if (heat_kWh > 0){
      uk_office_heat <- uk_gov_data %>%
        dplyr::filter(`Level 1` %in% c("Heat and steam", "WTT- heat and steam", "Transmission and distribution")) %>%
        dplyr::filter(!`Level 3` %in% c("District heat and steam"))
      if (heat_TD) {
        if (heat_WTT){
          uk_office_heat_TD <- sum((uk_office_heat %>%
                                      dplyr::filter(`Level 2` %in% c("Distribution - district heat & steam", "WTT- heat and steam")))$`GHG Conversion Factor 2022`)
        } else {
          uk_office_heat_TD <- (uk_office_heat %>%
            dplyr::filter(`Level 2` %in% c("Distribution - district heat & steam")))$`GHG Conversion Factor 2022`
        }
      } else {
        uk_office_heat_TD <- 0
      }
      if (heat_WTT){
        uk_office_heat_WTT <- (uk_office_heat %>%
                                 dplyr::filter(`Level 2` %in% c("WTT- heat and steam")))$`GHG Conversion Factor 2022`
      } else {
        uk_office_heat_WTT <- 0
      }
      heat_emissions <- heat_kWh*((uk_office_heat %>% dplyr::filter(`Level 1` == c("Heat and steam")))$`GHG Conversion Factor 2022` +
                                    uk_office_heat_TD + uk_office_heat_WTT)  
    } else {
      heat_emissions <- 0
    }
    office_emissions <- (water_emissions + electricity_emissions + heat_emissions)
  }
  office_emissions <- office_emissions + WFH_emissions
  return(office_emissions * 0.001) 
}
