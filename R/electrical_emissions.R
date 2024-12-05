#' Calculate Electrical Emissions
#' 
#' This function calculates the emissions produced from different electrical items and their waste disposal based on the specified inputs. It considers emissions from primary material production and waste disposal of electrical items.
#'
#' @param fridges Numeric value indicating the weight of fridges purchased. Default is `0`.
#' @param freezers Numeric value indicating the weight of freezers purchased. Default is `0`.
#' @param large_electrical Numeric value indicating the weight of large electrical items purchased. Default is `0`.
#' @param IT Numeric value indicating the weight of IT (Information Technology) equipment purchased. Default is `0`.
#' @param small_electrical Numeric value indicating the weight of small electrical items purchased. Default is `0`.
#' @param alkaline_batteries Numeric value indicating the weight of alkaline batteries purchased. Default is `0`. An alkaline AA battery typically weighs around 23 grams (0.023kg).
#' These are non-rechargeable batteries, used in:
#' * Day-to-day gadgets: Such as alarm clocks, electric shavers, remote controls, and radios 
#' * Low-drain applications: Such as flashlights, portable radios, alarm clocks, remote controls, and toys 
#' * Audiovisual equipment: Such as still digital cameras, strobe cameras, and portable liquid crystal TVs 
#' * Game equipment: Such as game controllers and walkie talkies 
#' * Other: Such as hearing aids and mosquito repellant devices
#' @param NiMh_batteries Numeric value indicating the weight of Nickel Metal Hydride batteries purchased. Default is `0`. A Nickel Metal Hydride AA battery typically weighs around 31 grams (0.031kg). 
#' These tend to be rechargeable and found in:
#' * Portable devices: digital cameras, MP3 players, and GPS units.
#' * Vehicles: Hybrid and electric vehicles
#' * Power tools
#' * Other: medical instruments, toothbrushes, electric razors, and mobile phones. 
#' @param LiIon_batteries Numeric value indicating the weight of Lithium-ion batteries purchased. Default is `0`.
#' Lithium-Ion batteries are often rechargeable and found in:
#' * Electronics: Cell phones, tablets, laptops, digital cameras, watches, and personal digital assistants 
#' * Vehicles: Electric vehicles, E-bikes, hoverboards, and scooters 
#' * Tools: Electric toothbrushes and other tools 
#' * Power backup: Solar power backup storage, uninterrupted power supply (UPS), and emergency power backup 
#' * Other: Pacemakers, toys, and clocks 
#' @param fridges_WD Numeric value indicating the weight of fridges disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param freezers_WD Numeric value indicating the weight of freezers disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param large_electrical_WD Numeric value indicating the weight of large electrical items disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param IT_WD Numeric value indicating the weight of IT equipment disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param small_electrical_WD Numeric value indicating the weight of small electrical items disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param alkaline_batteries_WD Numeric value indicating the weight of alkaline batteries disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param NiMh_batteries_WD Numeric value indicating the weight of Nickel Metal Hydride batteries disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param LiIon_batteries_WD Numeric value indicating the weight of Lithium-ion batteries disposed of using the waste disposal method given in `electric_waste_disposal`. Default is `0`.
#' @param electric_waste_disposal Character vector specifying the waste disposal method to use for calculating emissions. Possible values: `"Landfill"`, `"Open-loop"`. Default is `"Landfill"`.
#' `"Open-loop"` is the process of recycling material into other products.
#' `"Landfill"` the product goes to landfill after use.
#' @param units Character vector specifying the units of the emissions output. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#'
#' @return The calculated electrical emissions as a numeric value in tonnes.
#' 
#' @details 
#' Note on the Material Use and Waste Disposal from the Government UK Report 2024:
#' "Material use conversion factors should be used only to report on procured products and materials based on their origin (that is, comprised of primary material or recycled materials). The factors are not suitable for quantifying the benefits of collecting products or materials for recycling."
#' "The conversion factors presented for material consumption cover [...] emissions from the point of raw material extraction through to the point at which a finished good is manufactured and provided for sale. Therefore, commercial enterprises may use these factors to estimate the impact of goods they procure. Organisations involved in manufacturing goods using these materials should note that if they separately report emissions associated with their energy use in forming products with these materials, there is potential for double counting. As many of the data sources used in preparing the tables are confidential, we cannot publish a more detailed breakdown."
#' 
#' "Waste-disposal figures should be used for Greenhouse Gas Protocol reporting of Scope 3 emissions associated with end-of-life disposal of different materials. With the exception of landfill, these figures only cover emissions from the collection of materials and delivery to the point of treatment or disposal. They do not cover the environmental impact of different waste management options."
#'
#' @export
#'
#' @examples
#' # Calculate electrical emissions using default values
#' electrical_emissions()
#'
#' # Calculate electrical emissions with specific quantities and waste disposal
#' # method
#' electrical_emissions(fridges = 10, IT = 5, alkaline_batteries = 100,
#'                      electric_waste_disposal = "Open-loop", units = "tonnes")
electrical_emissions <- function(fridges = 0, freezers = 0, large_electrical = 0, IT = 0, small_electrical = 0,
                                alkaline_batteries = 0, LiIon_batteries = 0, NiMh_batteries = 0,
                                fridges_WD = 0, freezers_WD = 0, large_electrical_WD = 0, IT_WD = 0,
                                small_electrical_WD = 0, alkaline_batteries_WD = 0, LiIon_batteries_WD = 0,
                                NiMh_batteries_WD = 0, electric_waste_disposal = c("Landfill", "Open-loop"),
                                units = c("kg", "tonnes")){
  electric_waste_disposal <- match.arg(electric_waste_disposal)
  units <- match.arg(units)
  checkmate::assert_numeric(fridges, lower = 0)
  checkmate::assert_numeric(freezers, lower = 0)
  checkmate::assert_numeric(large_electrical, lower = 0)
  checkmate::assert_numeric(IT, lower = 0)
  checkmate::assert_numeric(small_electrical, lower = 0)
  checkmate::assert_numeric(alkaline_batteries, lower = 0)
  checkmate::assert_numeric(LiIon_batteries, lower = 0)
  checkmate::assert_numeric(NiMh_batteries, lower = 0)
  checkmate::assert_numeric(fridges_WD, lower = 0)
  checkmate::assert_numeric(freezers_WD, lower = 0)
  checkmate::assert_numeric(large_electrical_WD, lower = 0)
  checkmate::assert_numeric(IT_WD, lower = 0)
  checkmate::assert_numeric(small_electrical_WD, lower = 0)
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
    dplyr::filter(`Column Text` == electric_waste_disposal)
  emission_values <- MU$value
  WD_values <- WD$value
  electrical_emissions <- fridges*emission_values[1] + freezers*emission_values[1] + large_electrical*emission_values[2] +
    IT*emission_values[3] + small_electrical*emission_values[4] + alkaline_batteries*emission_values[5] +
    LiIon_batteries*emission_values[6] + NiMh_batteries*emission_values[7] +
    fridges_WD*WD_values[1] + freezers_WD*WD_values[1] + large_electrical_WD*WD_values[2] +
    IT_WD*WD_values[3] + small_electrical_WD*WD_values[4] + alkaline_batteries_WD*WD_values[5] +
    LiIon_batteries_WD*WD_values[5] + NiMh_batteries_WD*WD_values[5]
  if (units == "kg") electrical_emissions <- electrical_emissions * 0.001
  return(electrical_emissions)
}

