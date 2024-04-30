#' Calculate emissions from construction
#' 
#' @description: This function calculates the construction emissions based on the input parameters.
#' 
#' @param aggregates The weight of aggregates used in construction. Default is `0`.
#' @param average The weight of average material used in construction. Default is `0`.
#' @param asbestos The weight of asbestos used in construction. Default is `0`.
#' @param asphalt The weight of asphalt used in construction. Default is `0`.
#' @param bricks The weight of bricks used in construction. Default is `0`.
#' @param concrete The weight of concrete used in construction. Default is `0`.
#' @param insulation The weight of insulation material used in construction. Default is `0`.
#' @param metals The weight of metals used in construction. Default is `0`.
#' @param soils The weight of soils used in construction. Default is `0`.
#' @param mineral_oil The weight of mineral oil used in construction. Default is `0`.
#' @param plasterboard The weight of plasterboard used in construction. Default is `0`.
#' @param tyres The weight of tyres used in construction. Default is `0`.
#' @param wood The weight of wood used in construction. Default is `0`.
#' @param aggregates_WD The weight of aggregates disposed of as waste. Default is `0`.
#' @param average_WD The weight of average material disposed of as waste. Default is `0`.
#' @param asbestos_WD The weight of asbestos disposed of as waste. Default is `0`.
#' @param asphalt_WD The weight of asphalt disposed of as waste. Default is `0`.
#' @param bricks_WD The weight of bricks disposed of as waste. Default is `0`.
#' @param concrete_WD The weight of concrete disposed of as waste. Default is `0`.
#' @param insulation_WD The weight of insulation material disposed of as waste. Default is `0`.
#' @param metals_WD The weight of metals disposed of as waste. Default is `0`.
#' @param soils_WD The weight of soils disposed of as waste. Default is `0`.
#' @param mineral_oil_WD The weight of mineral oil disposed of as waste. Default is `0`.
#' @param plasterboard_WD The weight of plasterboard disposed of as waste. Default is `0`.
#' @param tyres_WD The weight of tyres disposed of as waste. Default is `0`.
#' @param wood_WD The weight of wood disposed of as waste. Default is `0`.
#' @param units The units in which the emissions should be returned (`"kg"` or `"tonnes"`). Default is `0`.
#' @param waste_disposal The method of waste disposal. Options are, `"Closed-loop"`, `"Combustion"`, `"Composting"`, `"Landfill"`,
#' `"Open-loop"`. Default is `"Closed-loop"`. See `details` for more information on this. 

#' @details The function calculates the construction emissions based on the input quantities of
#' different materials used in construction and the quantities of those materials disposed of
#' as waste.
#' The emissions values are obtained from a data source and are multiplied by the
#' corresponding quantities to calculate the total emissions. The units of emissions can
#' be specified as either kilograms (kg) or tonnes.
#' 
#' All assume `Primary material production` for the material used in construction, except soils which assumes `Closed-loop`
#' 
#' The waste disposal method can be selected from the options: `"Closed-loop"`, `"Combustion"`,
#' `"Composting"`, `"Landfill"`, or `"Open-loop"`.
#' Note that: `"Closed-loop"` is valid for aggregates, average, asphalt, concrete, insulation,
#' metal, soils, mineral oil, plasterboard, tyres, and wood.
#' `"Combustion"` is valid for average, mineral oil, and wood.
#' `"Composting"` is valid for wood only.
#' `"Landfill"` is valid for everything except average, mineral oil, and tyres.
#' `"Open-loop"` is valid for aggregates, average, asphalt, bricks, concrete, 
#' If one of these is used for a value that does not provide it, then an `"NA"` is given.
#' 
#' @return The calculated construction emissions as a numeric value in tonnes.
#' @export
#'
#' @examples
#' #Calculate construction emissions with default values
#' construction_emissions()
#' 
#' #Calculate construction emissions with specified quantities
#' construction_emissions(aggregates = 1000, concrete = 500, wood = 2000, units = "kg", waste_disposal = "Landfill")
construction_emissions <- function(aggregates = 0, average = 0, asbestos = 0, asphalt = 0, bricks = 0,
                                   concrete = 0, insulation = 0, metals = 0, soils = 0, mineral_oil = 0,
                                   plasterboard = 0, tyres = 0, wood = 0,
                                   aggregates_WD = 0, average_WD = 0, asbestos_WD = 0, asphalt_WD = 0, bricks_WD = 0,
                                   concrete_WD = 0, insulation_WD = 0, metals_WD = 0, soils_WD = 0, mineral_oil_WD = 0,
                                   plasterboard_WD = 0, tyres_WD = 0, wood_WD = 0,
                                   units = c("kg", "tonnes"),
                                   waste_disposal = c("Closed-loop", "Combustion", "Composting", "Landfill",
                                                      "Open-loop")){
  waste_disposal <- match.arg(waste_disposal)
  units <- match.arg(units)
  checkmate::assert_numeric(aggregates, lower = 0)
  checkmate::assert_numeric(average, lower = 0)
  checkmate::assert_numeric(asbestos, lower = 0)
  checkmate::assert_numeric(asphalt, lower = 0)
  checkmate::assert_numeric(bricks, lower = 0)
  checkmate::assert_numeric(concrete, lower = 0)
  checkmate::assert_numeric(insulation, lower = 0)
  checkmate::assert_numeric(metals, lower = 0)
  checkmate::assert_numeric(soils, lower = 0)
  checkmate::assert_numeric(mineral_oil, lower = 0)
  checkmate::assert_numeric(plasterboard, lower = 0)
  checkmate::assert_numeric(tyres, lower = 0)
  checkmate::assert_numeric(wood, lower = 0)
  checkmate::assert_numeric(aggregates_WD, lower = 0)
  checkmate::assert_numeric(average_WD, lower = 0)
  checkmate::assert_numeric(asbestos_WD, lower = 0)
  checkmate::assert_numeric(asphalt_WD, lower = 0)
  checkmate::assert_numeric(bricks_WD, lower = 0)
  checkmate::assert_numeric(concrete_WD, lower = 0)
  checkmate::assert_numeric(insulation_WD, lower = 0)
  checkmate::assert_numeric(metals_WD, lower = 0)
  checkmate::assert_numeric(soils_WD, lower = 0)
  checkmate::assert_numeric(mineral_oil_WD, lower = 0)
  checkmate::assert_numeric(plasterboard_WD, lower = 0)
  checkmate::assert_numeric(tyres_WD, lower = 0)
  checkmate::assert_numeric(wood_WD, lower = 0)

  emission_values <- uk_gov_data %>%
    dplyr::filter(`Level 2` == "Construction") %>%
    dplyr::mutate(value = ifelse(`Level 3` == "Soils", 0.9847084, value)) %>%
    dplyr::filter(`Column Text` == "Primary material production") %>%
    dplyr::pull(value)
  WD_values <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Waste disposal") %>%
    dplyr::filter(`Level 2` == "Construction") %>%
    dplyr::filter(`Column Text` == waste_disposal) %>%
    dplyr::pull(value) %>%
    tidyr::replace_na(0)
  
  construction_emissions <- aggregates*emission_values[1] + average*emission_values[2] + asbestos*emission_values[3] +
    asphalt*emission_values[4] + bricks*emission_values[5] + concrete*emission_values[6] +
    insulation*emission_values[7] + metals*emission_values[8] + soils*emission_values[9] +
    mineral_oil*emission_values[10] + plasterboard*emission_values[11] + tyres*emission_values[12] +
    wood*emission_values[13] +
    aggregates_WD*WD_values[1] + average_WD*WD_values[2] + asbestos_WD*WD_values[3] +
    asphalt_WD*WD_values[4] + bricks_WD*WD_values[5] + concrete_WD*WD_values[6] +
    insulation_WD*WD_values[7] + metals_WD*WD_values[8] + soils_WD*WD_values[9] +
    mineral_oil_WD*WD_values[10] + plasterboard_WD*WD_values[11] + tyres_WD*WD_values[12] +
    wood_WD*WD_values[13]
  
  if (units == "kg") construction_emissions <- construction_emissions * 0.001
  return(construction_emissions)
}
