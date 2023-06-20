#' Material (and waste) emissions
#'
#' @inheritParams paper_emissions
#' @inheritParams plastic_emissions
#' @inheritParams metal_emissions
#' @inheritParams electrical_emissions
#' @inheritParams construction_emissions
#' @param glass Numeric value representing the amount of glass. Default is `0`.
#' @param glass_WD Numeric value representing the amount of glass waste with disposal. Default is `0`.
#' @param industrial_waste Numeric value representing the amount of household residual waste. Default is `0`.
#' @param large_electrical Numeric value indicating the weight of large electrical items. Default is `0`.
#' @param small_electrical Numeric value indicating the weight of small electrical items. Default is `0`.
#' @param large_electrical_WD Numeric value indicating the weight of large electrical items disposed of using waste disposal methods. Default is `0`.
#' @param small_electrical_WD Numeric value indicating the weight of small electrical items disposed of using waste disposal methods. Default is `0`.
#' @param construction_average The weight of average material used in construction. Default is `0`.
#' @param construction_average_WD The weight of average material disposed of as waste. Default is `0`.
#' @param industrial_waste_disposal Character vector specifying the waste disposal method to use for metal for calculating emissions. Possible values: `"Combustion"`, `"Landfill"`. Default is `"Combustion"`. See `details` for more information.
#' @param metal_waste_disposal Character vector specifying the waste disposal method to use for metal for calculating emissions. Possible values: `"Closed-loop"`, `"Combustion"`, `"Landfill"`, `"Open-loop"`. Default is "Closed-loop". See `details` for more information.
#' @param glass_waste_disposal Character vector specifying the waste disposal method to use for metal for calculating emissions. Possible values: `"Closed-loop"`, `"Combustion"`, `"Landfill"`, `"Open-loop"`. Default is "Closed-loop". See `details` for more information.
#' @param paper_waste_disposal Character vector specifying the waste disposal method for paper to use for calculating emissions. Possible values: `"Closed-loop"`, `"Combustion"`, `"Composting"`, `"Landfill"`. Default is `"Closed-loop"`. See `details` for more information.
#' @param plastic_waste_disposal Character vector specifying the waste disposal method for plastic to use for calculating emissions. Possible values: `"Closed-loop"`, `"Combustion"`, `"Landfill"`, `"Open-loop"`. Default is `"Closed-loop"`. See `details` for more information.
#' @param electric_waste_disposal Character vector specifying the waste disposal method for electrical items to use for calculating emissions. Possible values: `"Landfill"`, `"Open-loop"`. Default is `"Landfill"`. See `details` for more information.
#' @param construction_waste_disposal Character vector specifying the waste disposal method for electrical items to use for calculating emissions. Options are, `"Closed-loop"`, `"Combustion"`, `"Composting"`, `"Landfill"`,
#' `"Open-loop"`. Default is `"Closed-loop"`.
#' Note that: `"Closed-loop"` is valid for aggregates, average, asphalt, concrete, insulation,
#' metal, soils, mineral oil, plasterboard, tyres, and wood.
#' `"Combustion"` is valid for average, mineral oil, and wood.
#' `"Composting"` is valid for wood only.
#' `"Landfill"` is valid for everything except average, mineral oil, and tyres.
#' `"Open-loop"` is valid for aggregates, average, asphalt, bricks, concrete, 
#' If one of these is used for a value that does not provide it, then an `"NA"` is given.
#' @param construction_units Character vector specifying the units of the emissions related to construction. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#' @param metal_units Character vector specifying the units of the emissions  related to metal. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#' @param glass_units Character vector specifying the units of the emissions related to glass. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#' @param paper_units Character vector specifying the units of the emissions related to paper. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#' @param plastic_units Character vector specifying the units of the emissions related to plastic materials. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#' @param electrical_units Character vector specifying the units of the emissions related to electrical materials. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#'
#' @return The calculated household emissions as a numeric value in tonnes.
#' @export
#' 
#' @details `*_waste_disposal` methods:
#' `"Open-loop"` is the process of recycling material into other products.
#' `"Closed-loop"` is the process of recycling material back into the same product.
#' `"Combustion"` energy is recovered from the waste through incineration and subsequent generation of electricity.
#' `"Compost"` CO2e emitted as a result of composting a waste stream.
#' `"Landfill"` the product goes to landfill after use.
#' `"Anaerobic digestion"` energy is recovered from the waste through anaerobic digestion.
#'
#' @examples
#' material_emissions(glass = 100, glass_WD = 10, glass_units = "kg")
material_emissions <- function(glass = 0, board = 0, mixed = 0, paper = 0,
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
                               aggregates = 0, construction_average = 0, asbestos = 0, asphalt = 0, bricks = 0,
                               concrete = 0, insulation = 0, metals = 0, soils = 0, mineral_oil = 0,
                               plasterboard = 0, tyres = 0, wood = 0,
                               aggregates_WD = 0, construction_average_WD = 0, asbestos_WD = 0, asphalt_WD = 0, bricks_WD = 0,
                               concrete_WD = 0, insulation_WD = 0, metals_WD = 0, soils_WD = 0, mineral_oil_WD = 0,
                               plasterboard_WD = 0, tyres_WD = 0, wood_WD = 0,
                               construction_waste_disposal = c("Closed-loop", "Combustion", "Composting", "Landfill",
                                                               "Open-loop"), 
                               construction_units = c("kg", "tonnes"), metal_units = c("kg", "tonnes"), glass_units = c("kg", "tonnes"),
                               paper_units = c("kg", "tonnes"), plastic_units = c("kg", "tonnes"), electrical_units = c("kg", "tonnes")){
  
  glass_waste_disposal <- match.arg(glass_waste_disposal)
  industrial_waste_disposal <- match.arg(industrial_waste_disposal)
  glass_units <- match.arg(glass_units)
  checkmate::assert_numeric(glass, lower = 0)
  checkmate::assert_numeric(glass_WD, lower = 0)
  checkmate::assert_numeric(industrial_waste, lower = 0)
  
  metal_emissions <- metal_emissions(aluminuim_cans = aluminuim_cans, aluminuim_foil = aluminuim_foil,
                                     mixed_cans = mixed_cans, scrap = scrap, steel_cans = steel_cans,
                                     aluminuim_cans_WD = aluminuim_cans_WD, aluminuim_foil_WD = aluminuim_foil_WD,
                                     mixed_cans_WD = mixed_cans_WD, scrap_WD = scrap_WD, steel_cans_WD = steel_cans_WD,
                                     waste_disposal = metal_waste_disposal, units = metal_units)
  paper_emissions <- paper_emissions(board = board, mixed = mixed, paper = paper,
                                     board_WD = board_WD, mixed_WD = mixed_WD, paper_WD = paper_WD,
                                     waste_disposal = paper_waste_disposal, units = paper_units)
  plastic_emissions <- plastic_emissions(average = average, average_film = average_film, average_rigid = average_rigid,
                                         HDPE = HDPE, LDPE = LDPE, LLDPE = LLDPE, PET = PET, PP = PP, PS = PS, PVC = PVC,
                                         average_WD = average_WD, average_film_WD = average_film_WD, average_rigid_WD = average_rigid_WD,
                                         HDPE_WD = HDPE_WD, LDPE_WD = LDPE_WD, LLDPE_WD = LLDPE_WD, PET_WD = PET_WD, PP_WD = PP_WD,
                                         PS_WD = PS_WD, PVC_WD = PVC_WD, waste_disposal = plastic_waste_disposal, units = plastic_units)
  electrical_emissions <- electrical_emissions(fridges = fridges, freezers = freezers, large = large_electrical, IT = IT,
                                               small = small_electrical, alkaline_batteries = alkaline_batteries,
                                               LiIon_batteries = LiIon_batteries, NiMh_batteries = NiMh_batteries,
                                               fridges_WD = fridges_WD, freezers_WD = freezers_WD, large_WD = large_electrical_WD, IT_WD = IT_WD,
                                               small_WD = small_electrical_WD, alkaline_batteries_WD = alkaline_batteries_WD, LiIon_batteries_WD = LiIon_batteries_WD,
                                               NiMh_batteries_WD = NiMh_batteries_WD, waste_disposal = electric_waste_disposal, units = electrical_units)
  construction_emissions <- construction_emissions(aggregates = aggregates, average = construction_average, asbestos = asbestos, asphalt = asphalt, 
                                                   bricks = bricks, concrete = concrete, insulation = insulation, metals = metals, soils = soils,
                                                   mineral_oil = mineral_oil, plasterboard = plasterboard, tyres = tyres, wood = wood,
                                                   aggregates_WD = aggregates_WD, average_WD = construction_average_WD, asbestos_WD = asbestos_WD, asphalt_WD = asphalt_WD, 
                                                   bricks_WD = bricks_WD, concrete_WD = concrete_WD, insulation_WD = insulation_WD, metals_WD = metals_WD, soils_WD = soils_WD,
                                                   mineral_oil_WD = mineral_oil_WD, plasterboard_WD = plasterboard_WD, tyres_WD = tyres_WD, wood_WD = wood_WD,
                                                   units = construction_units,
                                                   waste_disposal = construction_waste_disposal)
  # above are all already in tonnes
  
  WD_ind_values <- uk_gov_data %>%
    dplyr::filter(`Level 3` == c("Commercial and industrial waste")) %>%
    dplyr::filter(`Column Text` == industrial_waste_disposal) %>%
    dplyr::pull(`GHG Conversion Factor 2022`)
  MU_glass_values <- uk_gov_data %>%
    dplyr::filter(`Level 3` == "Glass") %>%
    dplyr::filter(`Column Text` %in% c("Primary material production")) %>%
    dplyr::pull(`GHG Conversion Factor 2022`)
  WD_glass_values <- uk_gov_data %>%
    dplyr::filter(`Level 3` == "Glass") %>%
    dplyr::filter(`Column Text`== glass_waste_disposal) %>%
    dplyr::pull(`GHG Conversion Factor 2022`)
  material_emissions <- glass*MU_glass_values[1] + glass_WD*WD_glass_values[2] +
    industrial_waste*WD_ind_values[1]
  if (glass_units == "kg") material_emissions <- material_emissions * 0.001
  return(paper_emissions + metal_emissions + plastic_emissions + electrical_emissions + construction_emissions + material_emissions)
}