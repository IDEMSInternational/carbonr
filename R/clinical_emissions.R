#' Clinical Emissions
#' 
#' @description Calculate carbon-equivalent emissions following an operating theatre
#'
#' @param wet_clinical_waste Amount of (wet) clinical waste that is usually incinerated.
#' @param wet_clinical_waste_unit Unit for `wet_clinical_waste` variable. Options are `"tonnes"` or `"kg"`.
#' @param water_supply Amount of water used in the operating theatre.
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
#' @examples
#' clinical_emissions(wet_clinical_waste = 100)
clinical_emissions <- function(wet_clinical_waste, wet_clinical_waste_unit = c("tonnes", "kg"),
                               water_supply = 0, water_trt = TRUE, water_unit = c("cubic metres", "million litres"),
                               electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
                               heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE){
  
  checkmate::assert_numeric(wet_clinical_waste, lower = 0)
  wet_clinical_waste_unit <- match.arg(wet_clinical_waste_unit)
  
  clinical_emission_factor <- 0.879 # requested by genghiskhanofnz in issue #16, from p32 of Australian greenhouse 2022 document https://www.dcceew.gov.au/climate-change/publications/national-greenhouse-accounts-factors-2022.
  if (wet_clinical_waste_unit == "kg"){
    wet_clinical_waste <- wet_clinical_waste*0.001  # convert to tonnes if clinical waste is given in kg
  }
  wet_clinical_waste <- wet_clinical_waste*clinical_emission_factor
  theatre_emissions <- building_emissions(water_supply = water_supply, water_trt = water_trt,
                                          water_unit = water_unit, electricity_kWh = electricity_kWh,
                                          electricity_TD = electricity_TD, electricity_WTT = electricity_WTT,
                                          heat_kWh = heat_kWh, heat_TD = heat_TD, heat_WTT = heat_WTT)
  
  clinical_emissions <- theatre_emissions + wet_clinical_waste
  return(clinical_emissions * 0.001) 
}