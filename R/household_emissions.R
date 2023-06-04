#' Calculate household material emissions
#'
#' @inheritParams paper_emissions
#' @inheritParams plastic_emissions
#' @inheritParams metal_emissions
#' @inheritParams electrical_emissions
#' @param glass Numeric value representing the amount of glass. Default is `0`.
#' @param clothing Numeric value representing the amount of clothing. Default is `0`.
#' @param food Numeric value representing the amount of food. Default is `0`.
#' @param drink Numeric value representing the amount of drink. Default is `0`.
#' @param compost_from_garden Numeric value representing the amount of compost from garden waste. Default is `0`.
#' @param compost_from_food_and_garden Numeric value representing the amount of compost from food and garden waste. Default is `0`.
#' @param glass_WD Numeric value representing the amount of glass waste with disposal. Default is `0`.
#' @param books_WD Numeric value representing the amount of books waste with disposal. Default is `0`.
#' @param clothing_WD Numeric value representing the amount of clothing waste with disposal. Default is `0`.
#' @param gcb_waste_disposal Character value specifying the waste disposal method for glass, clothing, and books waste (options: `"Closed-loop"`, `"Combustion"`, `"Landfill"`). Default is `"Closed-loop"`. See `details` for more information.
#' @param household_residual_waste Numeric value representing the amount of household residual waste. Default is `0`.
#' @param hh_waste_disposal Character value specifying the waste disposal method for  waste (options: `"Combustion"`, `"Landfill"`). Default is `"Combustion"`. See `details` for more information.
#' @param food_WD Numeric value indicating the weight of food disposed of using waste disposal methods. Default is `0`.
#' @param drink_WD Numeric value indicating the weight of drink disposed of using waste disposal methods. Default is `0`.
#' @param compost_from_garden_WD Numeric value indicating the weight of compost from garden waste disposed of using waste disposal methods. Default is `0`.
#' @param compost_from_food_and_garden_WD Numeric value indicating the weight of compost from garden and food waste disposed of using waste disposal methods. Default is `0`.
#' @param large_electrical Numeric value indicating the weight of large electrical items. Default is `0`.
#' @param small_electrical Numeric value indicating the weight of small electrical items. Default is `0`.
#' @param large_electrical_WD Numeric value indicating the weight of large electrical items disposed of using waste disposal methods. Default is `0`.
#' @param small_electrical_WD Numeric value indicating the weight of small electrical items disposed of using waste disposal methods. Default is `0`.
#' @param compost_waste_disposal Character value specifying the waste disposal method for compost waste (options: `"Anaerobic digestion"`, `"Combustion"`, `"Composting"`, `"Landfill"`). Default is `"Anaerobic digestion"`. See `details` for more information.
#' @param metal_waste_disposal Character vector specifying the waste disposal method to use for metal for calculating emissions. Possible values: "Closed-loop", "Combustion", "Landfill", "Open-loop". Default is "Closed-loop". See `details` for more information.
#' @param paper_waste_disposal Character vector specifying the waste disposal method for paper to use for calculating emissions. Possible values: `"Closed-loop"`, `"Combustion"`, `"Composting"`, `"Landfill"`. Default is `"Closed-loop"`. See `details` for more information.
#' @param plastic_waste_disposal Character vector specifying the waste disposal method for plastic to use for calculating emissions. Possible values: `"Closed-loop"`, `"Combustion"`, `"Landfill"`, `"Open-loop"`. Default is `"Closed-loop"`. See `details` for more information.
#' @param electric_waste_disposal Character vector specifying the waste disposal method for electrical items to use for calculating emissions. Possible values: `"Landfill"`, `"Open-loop"`. Default is `"Landfill"`. See `details` for more information.
#' @param units Character vector specifying the units of the emissions output. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
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
#' household_emissions(glass = 100, clothing = 10, glass_WD = 10, units = "kg")
household_emissions <- function(glass = 0, clothing = 0, food = 0, drink = 0, compost_from_garden = 0,
                                compost_from_food_and_garden = 0, board = 0, mixed = 0, paper = 0,
                                fridges = 0, freezers = 0, large_electrical = 0, IT = 0, small_electrical = 0,
                                alkaline_batteries = 0, LiIon_batteries = 0, NiMh_batteries = 0,
                                aluminuim_cans = 0, aluminuim_foil = 0, mixed_cans = 0, scrap = 0, steel_cans = 0,
                                average = 0, average_film = 0, average_rigid = 0, HDPE = 0,
                                LDPE = 0, LLDPE = 0, PET = 0, PP = 0, PS = 0, PVC = 0,
                                glass_WD = 0, books_WD = 0, clothing_WD = 0,
                                gcb_waste_disposal = c("Closed-loop", "Combustion", "Landfill"),
                                household_residual_waste = 0, hh_waste_disposal = c("Combustion", "Landfill"),
                                food_WD = 0, drink_WD = 0,
                                compost_from_garden_WD = 0,
                                compost_from_food_and_garden_WD = 0, compost_waste_disposal = c("Anaerobic digestion", "Combustion", "Composting", "Landfill"),
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
                                units = c("kg", "tonnes")){
  
  gcb_waste_disposal <- match.arg(gcb_waste_disposal)
  hh_waste_disposal <- match.arg(hh_waste_disposal)
  compost_waste_disposal <- match.arg(compost_waste_disposal)
  units <- match.arg(units)
  checkmate::assert_numeric(glass, lower = 0)
  checkmate::assert_numeric(clothing, lower = 0)
  checkmate::assert_numeric(food, lower = 0)
  checkmate::assert_numeric(drink, lower = 0)
  checkmate::assert_numeric(compost_from_garden, lower = 0)
  checkmate::assert_numeric(compost_from_food_and_garden, lower = 0)
  checkmate::assert_numeric(glass_WD, lower = 0)
  checkmate::assert_numeric(books_WD, lower = 0)
  checkmate::assert_numeric(clothing_WD, lower = 0)
  checkmate::assert_numeric(food_WD, lower = 0)
  checkmate::assert_numeric(drink_WD, lower = 0)
  checkmate::assert_numeric(compost_from_garden_WD, lower = 0)
  checkmate::assert_numeric(compost_from_food_and_garden_WD, lower = 0)
  checkmate::assert_numeric(household_residual_waste, lower = 0)
  
  metal_emissions <- metal_emissions(aluminuim_cans = aluminuim_cans, aluminuim_foil = aluminuim_foil,
                                     mixed_cans = mixed_cans, scrap = scrap, steel_cans = steel_cans,
                                     aluminuim_cans_WD = aluminuim_cans_WD, aluminuim_foil_WD = aluminuim_foil_WD,
                                     mixed_cans_WD = mixed_cans_WD, scrap_WD = scrap_WD, steel_cans_WD = steel_cans_WD,
                                     waste_disposal = metal_waste_disposal, units = units)
  paper_emissions <- paper_emissions(board = board, mixed = mixed, paper = paper,
                                     board_WD = board_WD, mixed_WD = mixed_WD, paper_WD = paper_WD,
                                     waste_disposal = paper_waste_disposal, units = units)
  plastic_emissions <- plastic_emissions(average = average, average_film = average_film, average_rigid = average_rigid,
                                         HDPE = HDPE, LDPE = LDPE, LLDPE = LLDPE, PET = PET, PP = PP, PS = PS, PVC = PVC,
                                         average_WD = average_WD, average_film_WD = average_film_WD, average_rigid_WD = average_rigid_WD,
                                         HDPE_WD = HDPE_WD, LDPE_WD = LDPE_WD, LLDPE_WD = LLDPE_WD, PET_WD = PET_WD, PP_WD = PP_WD,
                                         PS_WD = PS_WD, PVC_WD = PVC_WD, waste_disposal = plastic_waste_disposal, units = units)
  electrical_emissions <- electrical_emissions(fridges = fridges, freezers = freezers, large = large_electrical, IT = IT,
                                               small = small_electrical, alkaline_batteries = alkaline_batteries,
                                               LiIon_batteries = LiIon_batteries, NiMh_batteries = NiMh_batteries,
                                               fridges_WD = fridges_WD, freezers_WD = freezers_WD, large_WD = large_electrical_WD, IT_WD = IT_WD,
                                               small_WD = small_electrical_WD, alkaline_batteries_WD = alkaline_batteries_WD, LiIon_batteries_WD = LiIon_batteries_WD,
                                               NiMh_batteries_WD = NiMh_batteries_WD, waste_disposal = electric_waste_disposal, units = units)
  emission_values <- uk_gov_data %>%
    dplyr::filter(`Level 2` %in% c("Organic", "Other")) %>%
    dplyr::filter(`Column Text` == "Primary material production") %>%
    dplyr::pull(`GHG Conversion Factor 2022`)
  WD_compost_values <- uk_gov_data %>%
    dplyr::filter(`Level 2` %in% c("Refuse")) %>%
    dplyr::filter(`Column Text` == compost_waste_disposal) %>%
    dplyr::pull(`GHG Conversion Factor 2022`)
  WD_hh_values <- uk_gov_data %>%
    dplyr::filter(`Level 3` == c("Household residual waste")) %>%
    dplyr::filter(`Column Text` == hh_waste_disposal) %>%
    dplyr::pull(`GHG Conversion Factor 2022`)
  WD_gcb_values <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Waste disposal") %>%
    dplyr::filter(`Level 2` == c("Other")) %>%
    dplyr::filter(`Column Text` == gcb_waste_disposal) %>%
    dplyr::pull(`GHG Conversion Factor 2022`)
    hh_emissions <- glass*emission_values[2] + clothing*emission_values[3] + food*emission_values[4] +
      books_WD*WD_gcb_values[1] + glass_WD*WD_gcb_values[2] +  clothing_WD*WD_gcb_values[3] +
    drink*emission_values[4] + compost_from_garden*emission_values[5] +
    compost_from_food_and_garden*emission_values[6] +
    food_WD*WD_compost_values[2] + 
    drink_WD*WD_compost_values[2] + 
    compost_from_garden_WD*WD_compost_values[3] +
      compost_from_food_and_garden_WD*WD_compost_values[4] +
      household_residual_waste*WD_hh_values[1]
    if (units == "kg") hh_emissions <- hh_emissions/1000
  return(paper_emissions + metal_emissions + plastic_emissions + electrical_emissions + hh_emissions)
}
