#' Clinical Emissions
#' 
#' @description Calculate carbon-equivalent emissions following an operating theatre
#'
#' @inheritParams material_emissions
#' @inheritParams building_emissions
#' @inheritParams anaesthetic_emissions
#'
#' @param wet_clinical_waste Amount of (wet) clinical waste that is usually incinerated.
#' @param wet_clinical_waste_unit Unit for `wet_clinical_waste` variable. Options are `"tonnes"` or `"kg"`.
#' @return Returns CO2e emissions in tonnes.
#' @export
#'
#' @examples
#' \donttest{
#'  # clinical theatre emissions for the default options, with 100kg of wet clinical waste
#'  clinical_theatre_emissions(wet_clinical_waste = 100, wet_clinical_waste_unit = "kg")
#' }
clinical_theatre_emissions <- function(wet_clinical_waste, wet_clinical_waste_unit = c("tonnes", "kg"),
                                       desflurane = 0, sevoflurane = 0, isoflurane = 0, methoxyflurane = 0, N2O = 0, propofol = 0,
                                       water_supply = 0, water_trt = TRUE, water_unit = c("cubic metres", "million litres"),
                                       electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
                                       heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE,
                                       glass = 0, board = 0, mixed = 0, paper = 0,
                                       average = 0, average_film = 0, average_rigid = 0, HDPE = 0,
                                       LDPE = 0, LLDPE = 0, PET = 0, PP = 0, PS = 0, PVC = 0,
                                       glass_WD = 0, glass_waste_disposal = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
                                       board_WD = 0, mixed_WD = 0, paper_WD = 0,
                                       fridges = 0, freezers = 0, electric_waste_disposal = c("Landfill", "Open-loop"), electrical_units = c("kg", "tonnes"),
                                       paper_waste_disposal = c("Closed-loop", "Combustion", "Composting", "Landfill"),
                                       average_WD = 0, average_film_WD = 0, average_rigid_WD = 0, HDPE_WD = 0,
                                       LDPE_WD = 0, LLDPE_WD = 0, PET_WD = 0, PP_WD = 0, PS_WD = 0, PVC_WD = 0,
                                       glass_units = c("kg", "tonnes"), paper_units = c("kg", "tonnes"), plastic_units = c("kg", "tonnes")){
  
  checkmate::assert_numeric(wet_clinical_waste, lower = 0)
  wet_clinical_waste_unit <- match.arg(wet_clinical_waste_unit)
  
  clinical_emission_factor <- 0.879 # requested by genghiskhanofnz in issue #16, from p32 of Australian greenhouse 2022 document https://www.dcceew.gov.au/climate-change/publications/national-greenhouse-accounts-factors-2022.
  if (wet_clinical_waste_unit == "kg") wet_clinical_waste <- wet_clinical_waste*0.001  # convert to tonnes if clinical waste is given in kg
  wet_clinical_waste <- wet_clinical_waste*clinical_emission_factor # in tonnes
  building_emissions <- building_emissions(water_supply = water_supply, water_trt = water_trt,
                                           water_unit = water_unit, electricity_kWh = electricity_kWh,
                                           electricity_TD = electricity_TD, electricity_WTT = electricity_WTT,
                                           heat_kWh = heat_kWh, heat_TD = heat_TD, heat_WTT = heat_WTT) # in tonnes
  usage_emissions <- material_emissions(glass = glass, glass_WD = glass_WD, glass_waste_disposal = glass_waste_disposal,
                                        board = board, mixed = mixed, paper = paper,
                                        board_WD = board_WD, mixed_WD = mixed_WD, paper_WD = paper_WD,
                                        paper_waste_disposal = paper_waste_disposal, paper_units = paper_units,
                                        average = average, average_film = average_film, average_rigid = average_rigid,
                                        HDPE = HDPE, LDPE = LDPE, LLDPE = LLDPE, PET = PET, PP = PP, PS = PS, PVC = PVC,
                                        average_WD = average_WD, average_film_WD = average_film_WD, average_rigid_WD = average_rigid_WD,
                                        HDPE_WD = HDPE_WD, LDPE_WD = LDPE_WD, LLDPE_WD = LLDPE_WD, PET_WD = PET_WD, PP_WD = PP_WD,
                                        PS_WD = PS_WD, PVC_WD = PVC_WD, plastic_units = plastic_units,
                                        fridges = fridges, freezers = freezers,
                                        electric_waste_disposal = electric_waste_disposal, electrical_units = electrical_units) # in tonnes
  
  anaes_emissions <- anaesthetic_emissions(desflurane = desflurane, sevoflurane = sevoflurane, isoflurane = isoflurane,
                                           methoxyflurane = methoxyflurane, N2O = N2O, propofol = propofol) # in tonnes
  
  clinical_theatre_emissions <- building_emissions + wet_clinical_waste + usage_emissions + anaes_emissions
  return(clinical_theatre_emissions) # all already in tonnes
}