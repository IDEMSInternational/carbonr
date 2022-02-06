#' office emissions
#' 
#' Further options are given in the `raw_fuels` function.
#' 
#' @param specify logical. Whether an average should be used, or if the amount of energy used will be specified.
#' @param num_people Number of people in the office.
#' @param num_wfh Number of people working from home.
#' @param electricity_kwh TODO
#' @param kgco2e TODO
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
#' @return TODO
#' @export
#'
#' @examples # TODO
#' 
#' @references Descriptions from 2021 UK Government Report: https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021

office_emissions <- function(specify = FALSE, num_people = 1, num_wfh = 0, electricity_kwh = 0, kgco2e = 0.21233, natural_gas = 0,
                             burning_oil = 0, coal_domestic = 0, wood_log = 0, wood_chips = 0, natural_gas_units = c("kwh", "cubic metres", "tonnes"),
                             burning_oil_units = c("kwh", "litres", "tonnes"), coal_domestic_units = c("kwh", "tonnes"), wood_log_units = c("kwh", "tonnes"), 
                             wood_chips_units = c("kwh", "tonnes")){
 
  checkmate::assert_logical(specify)
  checkmate::assert_numeric(num_wfh, lower = 0)
  
  if (specify == FALSE){
    #  # 2.60 Tonnes CO2e as average for a year - https://www.carbonfootprint.com/businesscalculator.aspx?c=BusBasic&t=b
    total_emissions <- 2.60 * num_people
  } else {
    total_emissions <- raw_fuels(electricity_kwh = electricity_kwh, kgco2e = kgco2e, natural_gas = natural_gas, burning_oil = burning_oil,
                                 coal_domestic = coal_domestic, wood_log = wood_log, wood_chips = wood_chips, natural_gas_units = natural_gas_units,
                                 burning_oil_units = burning_oil_units, coal_domestic_units = coal_domestic_units, wood_log_units = wood_log_units, 
                                 wood_chips_units = wood_chips_units, num_people = num_people)
  }
  
  wfh <- 0.50*num_wfh # from https://www.carbonfootprint.com/
  
  overall_emissions <- total_emissions + wfh
  return(overall_emissions) 
}
