#' Office emissions
#' 
#' Further options are given in the `raw_fuels` function.
#' 
#' @param specify logical. Whether an average should be used, or if the amount of energy used will be specified.
#' @param num_people Number of people in the office.
#' @param num_wfh Number of people working from home.
#' @param electricity_kwh Electricity used in kWh.
#' @param heat_kwh Amount of heat/steam used for heating purposes in kWh.
#' @param water_m3 Amount of water used in cubic-metres.
#' @param include_TD logical. Recommended \code{TRUE}. Whether to include emissions associated with grid losses.
#' @param include_WTT logical. Recommended \code{TRUE}. Whether to include emissions associated with extracting, refining, and transporting fuels.
#' @param water_trt logical. Recommended \code{TRUE}. Whether to include emissions associated with water treatment for used water.
#' @param natural_gas amount used. Standard natural gas received through the gas mains grid network in the UK.
#' @param burning_oil amount used. Main purpose is for heating/lighting on a domestic scale (also known as kerosene).
#' @param coal_domestic amount used. Coal used domestically.
#' @param wood_log amount used. 
#' @param wood_chips amount used. 
#' @param natural_gas_units units that the gas is given in. Options are `"tonnes"`, `"cubic metres"`, `"kwh"`.
#' @param burning_oil_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param coal_domestic_units units that the fuel is given in. Options are `"kwh"`, `"tonnes"`.
#' @param wood_log_units units that the biomass is given in. Options are `"kwh"`, `"tonnes"`.
#' @param wood_chips_units units that the biomass is given in. Options are `"kwh"`, `"tonnes"`.
#' 
#' @return Returns CO2e emissions in tonnes.
#' @export
#'
#' @examples # specify emissions in an office
#' office_emissions(specify = TRUE, electricity_kwh = 200,
#'                  heat_kwh = 100, water_m3 = 100, include_TD = FALSE)
#' 
#' @references Descriptions from 2021 UK Government Report: https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021

office_emissions <- function(specify = FALSE, num_people = 1, num_wfh = 0,
                             electricity_kwh = 0, heat_kwh = 0, water_m3 = 0, include_TD = TRUE, include_WTT = TRUE, water_trt = TRUE,
                             natural_gas = 0, burning_oil = 0, coal_domestic = 0, wood_log = 0, wood_chips = 0, natural_gas_units = c("kwh", "cubic metres", "tonnes"),
                             burning_oil_units = c("kwh", "litres", "tonnes"), coal_domestic_units = c("kwh", "tonnes"), wood_log_units = c("kwh", "tonnes"), 
                             wood_chips_units = c("kwh", "tonnes")){
  
  checkmate::assert_logical(specify)
  checkmate::assert_numeric(num_wfh, lower = 0)
  
  if (specify == FALSE){
    # 2.60 Tonnes CO2e as average for a year - https://www.carbonfootprint.com/businesscalculator.aspx?c=BusBasic&t=b
    # which is 2600kg
    total_emissions <- 2.6 * num_people
  } else {
    electricity_emissions <- electricity_kwh * 0.21233
    heating_emissions <- heat_kwh * 0.17073
    water_emissions <- water_m3 * 0.149
    if (include_TD){
      electricity_emissions <- electricity_emissions + (electricity_kwh * 0.01879)
      heating_emissions <- heating_emissions + (heat_kwh * 0.00899)
    }
    if (include_WTT){
      electricity_emissions <- electricity_emissions + (electricity_kwh * 0.05529)
      heating_emissions <- heating_emissions + (heat_kwh * 0.03153)
    }
    if (include_TD & include_WTT){
      electricity_emissions <- electricity_emissions + (electricity_kwh * 0.00489) # WTT T+D emissions for UK electricity
    }
    if (water_trt){
      water_emissions <- water_emissions + water_m3 * 0.272
    }
    
    raw_emissions <- raw_fuels(natural_gas = natural_gas, burning_oil = burning_oil,
                               coal_domestic = coal_domestic, wood_log = wood_log, wood_chips = wood_chips, natural_gas_units = natural_gas_units,
                               burning_oil_units = burning_oil_units, coal_domestic_units = coal_domestic_units, wood_log_units = wood_log_units, 
                               wood_chips_units = wood_chips_units, num_people = num_people)
    
    specified_emissions <- (electricity_emissions + heating_emissions + water_emissions) * 0.001
    
    total_emissions = specified_emissions + raw_emissions
    
  }
  
  wfh <- 0.50*num_wfh # from https://www.carbonfootprint.com/
  
  overall_emissions <- total_emissions + wfh
  return(overall_emissions) 
}