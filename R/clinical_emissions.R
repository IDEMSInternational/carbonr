#' Clinical Emissions
#' 
#' @description Calculate carbon-equivalent emissions following an operating theatre
#'
#' @inheritParams material_emissions
#' @inheritParams building_emissions
#'
#' @param wet_clinical_waste Amount of (wet) clinical waste that is usually incinerated.
#' @param wet_clinical_waste_unit Unit for `wet_clinical_waste` variable. Options are `"tonnes"` or `"kg"`.
#' @return Returns CO2e emissions in tonnes.
#' @export
#'
#' @examples
#' clinical_emissions(wet_clinical_waste = 100)
clinical_emissions <- function(wet_clinical_waste, wet_clinical_waste_unit = c("tonnes", "kg"),
                               water_supply = 0, water_trt = TRUE, water_unit = c("cubic metres", "million litres"),
                               electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
                               heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE,
                               glass = 0, board = 0, mixed = 0, paper = 0,
                               fridges = 0, freezers = 0, large_electrical = 0, IT = 0, small_electrical = 0,
                               alkaline_batteries = 0, LiIon_batteries = 0, NiMh_batteries = 0,
                               aluminuim_cans = 0, aluminuim_foil = 0, mixed_cans = 0, scrap = 0, steel_cans = 0,
                               average = 0, average_film = 0, average_rigid = 0, HDPE = 0,
                               LDPE = 0, LLDPE = 0, PET = 0, PP = 0, PS = 0, PVC = 0,
                               glass_WD = 0, glass_waste_disposal = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
                               industrial_waste = 0, industrial_waste_disposal = c("Combustion", "Landfill"),
                               aluminuim_cans_WD = 0, aluminuim_foil_WD = 0,
                               mixed_cans_WD = 0, scrap_WD = 0, steel_cans_WD = 0,
                               metal_waste_disposal = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
                               board_WD = 0, mixed_WD = 0, paper_WD = 0,
                               paper_waste_disposal = c("Closed-loop", "Combustion", "Composting", "Landfill"),
                               average_WD = 0, average_film_WD = 0, average_rigid_WD = 0, HDPE_WD = 0,
                               LDPE_WD = 0, LLDPE_WD = 0, PET_WD = 0, PP_WD = 0, PS_WD = 0, PVC_WD = 0,
                               plastic_waste_disposal = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
                               fridges_WD = 0, freezers_WD = 0, large_electrical_WD = 0, IT_WD = 0,
                               small_electrical_WD = 0, alkaline_batteries_WD = 0, LiIon_batteries_WD = 0,
                               NiMh_batteries_WD = 0, electric_waste_disposal = c("Landfill", "Open-loop"),
                               metal_units = c("kg", "tonnes"), glass_units = c("kg", "tonnes"),
                               paper_units = c("kg", "tonnes"), plastic_units = c("kg", "tonnes"), electrical_units = c("kg", "tonnes")){
  
  checkmate::assert_numeric(wet_clinical_waste, lower = 0)
  wet_clinical_waste_unit <- match.arg(wet_clinical_waste_unit)
  
  clinical_emission_factor <- 0.879 # requested by genghiskhanofnz in issue #16, from p32 of Australian greenhouse 2022 document https://www.dcceew.gov.au/climate-change/publications/national-greenhouse-accounts-factors-2022.
  if (wet_clinical_waste_unit == "kg") wet_clinical_waste <- wet_clinical_waste*0.001  # convert to tonnes if clinical waste is given in kg
  wet_clinical_waste <- wet_clinical_waste*clinical_emission_factor
  theatre_emissions <- building_emissions(water_supply = water_supply, water_trt = water_trt,
                                          water_unit = water_unit, electricity_kWh = electricity_kWh,
                                          electricity_TD = electricity_TD, electricity_WTT = electricity_WTT,
                                          heat_kWh = heat_kWh, heat_TD = heat_TD, heat_WTT = heat_WTT)
  usage_emissions <- material_emissions(glass = glass, glass_WD = glass_WD, glass_waste_disposal = glass_waste_disposal,
                                        aluminuim_cans = aluminuim_cans, aluminuim_foil = aluminuim_foil,
                                        mixed_cans = mixed_cans, scrap = scrap, steel_cans = steel_cans,
                                        aluminuim_cans_WD = aluminuim_cans_WD, aluminuim_foil_WD = aluminuim_foil_WD,
                                        mixed_cans_WD = mixed_cans_WD, scrap_WD = scrap_WD, steel_cans_WD = steel_cans_WD,
                                        metal_waste_disposal = metal_waste_disposal, metal_units = metal_units,
                                        board = board, mixed = mixed, paper = paper,
                                        board_WD = board_WD, mixed_WD = mixed_WD, paper_WD = paper_WD,
                                        paper_waste_disposal = paper_waste_disposal, paper_units = paper_units,
                                        average = average, average_film = average_film, average_rigid = average_rigid,
                                        HDPE = HDPE, LDPE = LDPE, LLDPE = LLDPE, PET = PET, PP = PP, PS = PS, PVC = PVC,
                                        average_WD = average_WD, average_film_WD = average_film_WD, average_rigid_WD = average_rigid_WD,
                                        HDPE_WD = HDPE_WD, LDPE_WD = LDPE_WD, LLDPE_WD = LLDPE_WD, PET_WD = PET_WD, PP_WD = PP_WD,
                                        PS_WD = PS_WD, PVC_WD = PVC_WD, plastic_waste_disposal = plastic_waste_disposal, plastic_units = plastic_units,
                                        fridges = fridges, freezers = freezers, large_electrical = large_electrical, IT = IT,
                                        small_electrical = small_electrical, alkaline_batteries = alkaline_batteries,
                                        LiIon_batteries = LiIon_batteries, NiMh_batteries = NiMh_batteries,
                                        fridges_WD = fridges_WD, freezers_WD = freezers_WD, large_electrical_WD = large_electrical_WD, IT_WD = IT_WD,
                                        small_electrical_WD = small_electrical_WD, alkaline_batteries_WD = alkaline_batteries_WD, LiIon_batteries_WD = LiIon_batteries_WD,
                                        NiMh_batteries_WD = NiMh_batteries_WD, electric_waste_disposal = electric_waste_disposal, electrical_units = electrical_units)
  
  clinical_emissions <- theatre_emissions + wet_clinical_waste + usage_emissions
  return(clinical_emissions * 0.001) 
}
