#' Building emissions
#' 
#' Further options are given in the `raw_fuels` function.
#' 
#' @param water_supply Amount of water used in the building.
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
#' building_emissions(electricity_kWh = 200,
#'                  heat_kWh = 100, water_supply = 100, water_trt = FALSE)
#' 
#' @references Descriptions from 2022 UK Government Report: https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2022

building_emissions <- function(water_supply = 0, water_trt = TRUE,
                               water_unit = c("cubic metres", "million litres"),
                               electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
                               heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE){
  
  checkmate::assert_logical(water_trt)
  checkmate::assert_logical(electricity_TD)
  checkmate::assert_logical(electricity_WTT)
  checkmate::assert_logical(heat_TD)
  checkmate::assert_logical(heat_WTT)
  checkmate::assert_numeric(water_supply, lower = 0)
  checkmate::assert_numeric(electricity_kWh, lower = 0)
  checkmate::assert_numeric(heat_kWh, lower = 0)
  water_unit <- match.arg(water_unit)
  
  # Water supply and treatment
  if (water_supply > 0){
    uk_water <- uk_gov_data %>% dplyr::filter(`Level 1` %in% c("Water supply", "Water treatment"))
    uk_water <- (uk_water %>% dplyr::filter(UOM == {{ water_unit }}))$`GHG Conversion Factor 2022`
    if (!water_trt) {
      water_emissions <- uk_water[1] * water_supply
    } else {
      water_emissions <- sum(uk_water) * water_supply
    }
  } else {
    water_emissions <- 0
  }
  
  # Electricity
  if (electricity_kWh > 0){
    uk_electricity <- uk_gov_data %>%
      dplyr::filter(`Level 1` %in% c("Transmission and distribution", "UK electricity", "WTT- UK & overseas elec"))
    if (electricity_TD) {
      if (electricity_WTT){
        uk_electricity_TD <- sum((uk_electricity %>%
                                           dplyr::filter(`Level 2` %in% c("T&D- UK electricity", "WTT- UK electricity (T&D)")))$`GHG Conversion Factor 2022`)
      } else {
        uk_electricity_TD <- (uk_electricity %>%
                                       dplyr::filter(`Level 2` %in% c("T&D- UK electricity")))$`GHG Conversion Factor 2022`
      }
    } else {
      uk_electricity_TD <- 0
    }
    if (electricity_WTT){
      uk_electricity_WTT <- (uk_electricity %>%
                                      dplyr::filter(`Level 2` %in% c("WTT- UK electricity (generation)")))$`GHG Conversion Factor 2022`
    } else {
      uk_electricity_WTT <- 0
    }
    electricity_emissions <- electricity_kWh*((uk_electricity %>% dplyr::filter(`Level 1` == c("UK electricity")))$`GHG Conversion Factor 2022` +
                                                uk_electricity_TD + uk_electricity_WTT)  
  } else {
    electricity_emissions <- 0
  }
  
  # Heat and steam
  if (heat_kWh > 0){
    uk_heat <- uk_gov_data %>%
      dplyr::filter(`Level 1` %in% c("Heat and steam", "WTT- heat and steam", "Transmission and distribution")) %>%
      dplyr::filter(!`Level 3` %in% c("District heat and steam"))
    if (heat_TD) {
      if (heat_WTT){
        uk_heat_TD <- sum((uk_heat %>%
                                    dplyr::filter(`Level 2` %in% c("Distribution - district heat & steam", "WTT- heat and steam")))$`GHG Conversion Factor 2022`)
      } else {
        uk_heat_TD <- (uk_heat %>%
                                dplyr::filter(`Level 2` %in% c("Distribution - district heat & steam")))$`GHG Conversion Factor 2022`
      }
    } else {
      uk_heat_TD <- 0
    }
    if (heat_WTT){
      uk_heat_WTT <- (uk_heat %>%
                               dplyr::filter(`Level 2` %in% c("WTT- heat and steam")))$`GHG Conversion Factor 2022`
    } else {
      uk_heat_WTT <- 0
    }
    heat_emissions <- heat_kWh*((uk_heat %>% dplyr::filter(`Level 1` == c("Heat and steam")))$`GHG Conversion Factor 2022` +
                                  uk_heat_TD + uk_heat_WTT)  
  } else {
    heat_emissions <- 0
  }
  building_emissions <- (water_emissions + electricity_emissions + heat_emissions)
  return(building_emissions * 0.001) 
}
