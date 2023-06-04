#' Calculate Electrical Emissions
#' 
#' This function calculates the emissions produced from different electrical items and their waste disposal based on the specified inputs. It considers emissions from primary material production and waste disposal of electrical items.
#'
#' @param fridges Numeric value indicating the weight of fridges. Default is `0`.
#' @param freezers Numeric value indicating the weight of freezers. Default is `0`.
#' @param large Numeric value indicating the weight of large electrical items. Default is `0`.
#' @param IT Numeric value indicating the weight of IT (Information Technology) equipment. Default is `0`.
#' @param small Numeric value indicating the weight of small electrical items. Default is `0`.
#' @param alkaline_batteries Numeric value indicating the weight of alkaline batteries. Default is `0`.
#' @param LiIon_batteries Numeric value indicating the weight of Lithium-ion batteries. Default is `0`.
#' @param NiMh_batteries Numeric value indicating the weight of Nickel Metal Hydride batteries. Default is `0`.
#' @param fridges_WD Numeric value indicating the weight of fridges disposed of using waste disposal methods. Default is `0`.
#' @param freezers_WD Numeric value indicating the weight of freezers disposed of using waste disposal methods. Default is `0`.
#' @param large_WD Numeric value indicating the weight of large electrical items disposed of using waste disposal methods. Default is `0`.
#' @param IT_WD Numeric value indicating the weight of IT equipment disposed of using waste disposal methods. Default is `0`.
#' @param small_WD Numeric value indicating the weight of small electrical items disposed of using waste disposal methods. Default is `0`.
#' @param alkaline_batteries_WD Numeric value indicating the weight of alkaline batteries disposed of using waste disposal methods. Default is `0`.
#' @param LiIon_batteries_WD Numeric value indicating the weight of Lithium-ion batteries disposed of using waste disposal methods. Default is `0`.
#' @param NiMh_batteries_WD Numeric value indicating the weight of Nickel Metal Hydride batteries disposed of using waste disposal methods. Default is `0`.
#' @param waste_disposal Character vector specifying the waste disposal method to use for calculating emissions. Possible values: `"Landfill"`, `"Open-loop"`. Default is `"Landfill"`.
#' `"Open-loop"` is the process of recycling material into other products.
#' `"Landfill"` the product goes to landfill after use.
#' @param units Character vector specifying the units of the emissions output. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#'
#' @return The calculated electrical emissions as a numeric value in tonnes.
#'
#' @export
#'
#' @examples
#' # Calculate electrical emissions using default values
#' electrical_emissions()
#'
#' # Calculate electrical emissions with specific quantities and waste disposal method
#' electrical_emissions(fridges = 10, IT = 5, alkaline_batteries = 100, waste_disposal = "Open-loop", units = "tonnes")
electrical_emissions <- function(fridges = 0, freezers = 0, large = 0, IT = 0, small = 0,
                                alkaline_batteries = 0, LiIon_batteries = 0, NiMh_batteries = 0,
                                fridges_WD = 0, freezers_WD = 0, large_WD = 0, IT_WD = 0,
                                small_WD = 0, alkaline_batteries_WD = 0, LiIon_batteries_WD = 0,
                                NiMh_batteries_WD = 0, waste_disposal = c("Landfill", "Open-loop"),
                                units = c("kg", "tonnes")){
  waste_disposal <- match.arg(waste_disposal)
  units <- match.arg(units)
  checkmate::assert_numeric(fridges, lower = 0)
  checkmate::assert_numeric(freezers, lower = 0)
  checkmate::assert_numeric(large, lower = 0)
  checkmate::assert_numeric(IT, lower = 0)
  checkmate::assert_numeric(small, lower = 0)
  checkmate::assert_numeric(alkaline_batteries, lower = 0)
  checkmate::assert_numeric(LiIon_batteries, lower = 0)
  checkmate::assert_numeric(NiMh_batteries, lower = 0)
  checkmate::assert_numeric(fridges_WD, lower = 0)
  checkmate::assert_numeric(freezers_WD, lower = 0)
  checkmate::assert_numeric(large_WD, lower = 0)
  checkmate::assert_numeric(IT_WD, lower = 0)
  checkmate::assert_numeric(small_WD, lower = 0)
  checkmate::assert_numeric(alkaline_batteries_WD, lower = 0)
  checkmate::assert_numeric(LiIon_batteries_WD, lower = 0)
  checkmate::assert_numeric(NiMh_batteries_WD, lower = 0)  
  MU <- uk_gov_data %>%
    dplyr::filter(`Level 2` == "Electrical items") %>%
    dplyr::filter(`Column Text` == "Primary material production") %>%
    dplyr::mutate(`Level 3` = ifelse(`Level 2` == "Electrical items",
                                gsub(".*- ", "", `Level 3`),
                                `Level 3`))
  
  WD <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Waste disposal") %>%
    dplyr::filter(`Level 2` == "Electrical items") %>%
    dplyr::filter(`Column Text` == waste_disposal)
  emission_values <- MU$`GHG Conversion Factor 2022`
  WD_values <- WD$`GHG Conversion Factor 2022`
  electrical_emissions <- fridges*emission_values[1] + freezers*emission_values[1] + large*emission_values[2] +
    IT*emission_values[3] + small*emission_values[4] + alkaline_batteries*emission_values[5] +
    LiIon_batteries*emission_values[6] + NiMh_batteries*emission_values[7] +
    fridges_WD*WD_values[1] + freezers_WD*WD_values[1] + large_WD*WD_values[2] +
    IT_WD*WD_values[3] + small_WD*WD_values[4] + alkaline_batteries_WD*WD_values[5] +
    LiIon_batteries_WD*WD_values[5] + NiMh_batteries_WD*WD_values[5]
  if (units == "kg") electrical_emissions <- electrical_emissions/1000
  return(electrical_emissions)
}
