#' Metal Emissions
#' 
#' @description This function calculates the emissions produced from different metal sources based on the specified inputs. It considers emissions from primary material production and waste disposal of various metal types.
#'
#' @param aluminuim_cans Numeric value indicating the weight of aluminum cans purchased. Default is `0`.
#' @param aluminuim_foil Numeric value indicating the weight of aluminum foil purchased. Default is `0`.
#' @param mixed_cans Numeric value indicating the weight of mixed metal cans purchased. Default is `0`.
#' @param scrap Numeric value indicating the weight of metal scrap purchased. Default is `0`.
#' @param steel_cans Numeric value indicating the weight of steel cans purchased. Default is `0`.
#' @param aluminuim_cans_WD Numeric value indicating the weight of aluminum cans disposed of using the waste disposal method in `metal_waste_disposal`. Default is `0`.
#' @param aluminuim_foil_WD Numeric value indicating the weight of aluminum foil disposed of using the waste disposal method in `metal_waste_disposal`. Default is `0`.
#' @param mixed_cans_WD Numeric value indicating the weight of mixed metal cans disposed of using the waste disposal method in `metal_waste_disposal`. Default is `0`.
#' @param scrap_WD Numeric value indicating the weight of metal scrap disposed of using the waste disposal method in `metal_waste_disposal`. Default is `0`.
#' @param steel_cans_WD Numeric value indicating the weight of steel cans disposed of using the waste disposal method in `metal_waste_disposal`. Default is `0`.
#' @param metal_waste_disposal Character vector specifying the waste disposal method to use for calculating emissions. Possible values: "Closed-loop", "Combustion", "Landfill", "Open-loop". Default is "Closed-loop". See details for more information on the different methods.
#' `"Open-loop"` is the process of recycling material into other products.
#' `"Closed-loop"` is the process of recycling material back into the same product.
#' `"Combustion"` energy is recovered from the waste through incineration and subsequent generation of electricity.
#' `"Landfill"` the product goes to landfill after use.
#' @param units  Character vector specifying the units of the emissions. Possible values: "kg", "tonnes". Default is "kg".
#'
#' @details `metal_waste_disposal` methods:
#' `"Open-loop"` is the process of recycling material into other products.
#' `"Closed-loop"` is the process of recycling material back into the same product (often this value is the same as that of `Open-loop`.)
#' `"Combustion"` energy is recovered from the waste through incineration and subsequent generation of electricity.
#' `"Landfill"` the product goes to landfill after use.
#' 
#' Note on the Material Use and Waste Disposal from the Government UK Report 2024:
#' "Material use conversion factors should be used only to report on procured products and materials based on their origin (that is, comprised of primary material or recycled materials). The factors are not suitable for quantifying the benefits of collecting products or materials for recycling."
#' "The conversion factors presented for material consumption cover [...] emissions from the point of raw material extraction through to the point at which a finished good is manufactured and provided for sale. Therefore, commercial enterprises may use these factors to estimate the impact of goods they procure. Organisations involved in manufacturing goods using these materials should note that if they separately report emissions associated with their energy use in forming products with these materials, there is potential for double counting. As many of the data sources used in preparing the tables are confidential, we cannot publish a more detailed breakdown."
#' 
#' "Waste-disposal figures should be used for Greenhouse Gas Protocol reporting of Scope 3 emissions associated with end-of-life disposal of different materials. With the exception of landfill, these figures only cover emissions from the collection of materials and delivery to the point of treatment or disposal. They do not cover the environmental impact of different waste management options."
#' 
#' @return The function returns the calculated CO2-equivalent emissions as a numeric value in tonnes.
#' @export
#'
#' @examples
#' metal_emissions(aluminuim_cans = 1.4, units = "tonnes")
metal_emissions <- function(aluminuim_cans = 0, aluminuim_foil = 0, mixed_cans = 0, scrap = 0, steel_cans = 0,
                            aluminuim_cans_WD = 0, aluminuim_foil_WD = 0,
                            mixed_cans_WD = 0, scrap_WD = 0, steel_cans_WD = 0,
                            metal_waste_disposal = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
                            units = c("kg", "tonnes")){
  
  metal_waste_disposal <- match.arg(metal_waste_disposal)
  units <- match.arg(units)
  checkmate::assert_numeric(aluminuim_cans, lower = 0)
  checkmate::assert_numeric(aluminuim_foil, lower = 0)
  checkmate::assert_numeric(mixed_cans, lower = 0)
  checkmate::assert_numeric(scrap, lower = 0)
  checkmate::assert_numeric(steel_cans, lower = 0)
  checkmate::assert_numeric(aluminuim_cans_WD, lower = 0)
  checkmate::assert_numeric(aluminuim_foil_WD, lower = 0)
  checkmate::assert_numeric(mixed_cans_WD, lower = 0)
  checkmate::assert_numeric(scrap_WD, lower = 0)
  checkmate::assert_numeric(steel_cans_WD, lower = 0)
  
  MU <- uk_gov_data %>%
    dplyr::filter(`Level 2` == "Metal") %>%
    dplyr::filter(`Column Text` == "Primary material production") %>%
    dplyr::mutate(`Level 3` = ifelse(`Level 2` == "Metal",
                              gsub(".*: ", "", `Level 3`),
                              `Level 3`))
  WD <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Waste disposal") %>%
    dplyr::filter(`Level 2` == "Metal") %>%
    dplyr::filter(`Column Text` == metal_waste_disposal) %>%
    dplyr::mutate(`Level 3` = ifelse(`Level 2` == "Metal",
                              gsub(".*: ", "", `Level 3`),
                              `Level 3`))
  emission_values <- MU$value
  WD_values <- WD$value
  metal_emissions <- aluminuim_cans*emission_values[1] + aluminuim_foil*emission_values[1] + mixed_cans*emission_values[2] +
    scrap*emission_values[3] + steel_cans*emission_values[4] +
    aluminuim_cans_WD*WD_values[1] + aluminuim_foil_WD*WD_values[1] + mixed_cans_WD*WD_values[2] +
    scrap_WD*WD_values[3] + steel_cans_WD*WD_values[4]
  if (units == "kg") metal_emissions <- metal_emissions * 0.001
  return(metal_emissions)
}
