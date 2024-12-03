#' Calculate Plastic Emissions
#'
#' This function calculates the emissions produced from different plastic sources based on the specified inputs. It considers emissions from primary material production and waste disposal of plastic materials.
#'
#' @param average Numeric value indicating the weight of an overall average plastic purchased. Default is `0`.
#' @param average_film Numeric value indicating the weight of average film plastic purchased. Default is `0`.
#' @param average_rigid Numeric value indicating the weight of average rigid plastic purchased. Default is `0`.
#' @param HDPE Numeric value indicating the weight of HDPE plastic purchased. Default is `0`.
#' @param LDPE Numeric value indicating the weight of LDPE plastic purchased. Default is `0`.
#' @param LLDPE Numeric value indicating the weight of LLDPE plastic purchased. Default is `0`.
#' @param PET Numeric value indicating the weight of PET plastic purchased. Default is `0`.
#' @param PP Numeric value indicating the weight of PP plastic purchased. Default is `0`.
#' @param PS Numeric value indicating the weight of PS plastic purchased. Default is `0`.
#' @param PVC Numeric value indicating the weight of PVC plastic purchased. Default is `0`.
#' @param average_WD Numeric value indicating the weight of average plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param average_film_WD Numeric value indicating the weight of average film plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param average_rigid_WD Numeric value indicating the weight of average rigid plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param HDPE_WD Numeric value indicating the weight of HDPE plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param LDPE_WD Numeric value indicating the weight of LDPE plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param LLDPE_WD Numeric value indicating the weight of LLDPE plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param PET_WD Numeric value indicating the weight of PET plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param PP_WD Numeric value indicating the weight of PP plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param PS_WD Numeric value indicating the weight of PS plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param PVC_WD Numeric value indicating the weight of PVC plastic disposed of using the waste disposal methods given in `plastic_waste_disposal`. Default is `0`.
#' @param plastic_waste_disposal Character vector specifying the waste disposal method to use for calculating emissions. Possible values: "Landfill", "Open-loop", "Closed-loop", "Combustion". Default is "Landfill". More information is given under details.
#' @param units Character vector specifying the units of the emissions output. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#'
#' @return The calculated plastic emissions as a numeric value in tonnes.
#'
#' @export
#' 
#' @details The different `plastic_waste_disposal` methods are:
#' `"Landfill"` the product goes to landfill after use.
#' `"Open-loop"` is the process of recycling material into other products.
#' `"Closed-loop"` is the process of recycling material back into the same product.
#' `"Combustion"` energy is recovered from the waste through incineration and subsequent generation of electricity.
#' 
#'
#' @examples
#' # Calculate plastic emissions using default values
#' plastic_emissions()
#'
#' # Calculate plastic emissions with specific quantities and waste disposal
#' # method
#' plastic_emissions(average = 100, HDPE = 50, PET = 25, units = "tonnes")
plastic_emissions <- function(average = 0, average_film = 0, average_rigid = 0, HDPE = 0,
                               LDPE = 0, LLDPE = 0, PET = 0, PP = 0, PS = 0, PVC = 0,
                              average_WD = 0, average_film_WD = 0, average_rigid_WD = 0, HDPE_WD = 0,
                              LDPE_WD = 0, LLDPE_WD = 0, PET_WD = 0, PP_WD = 0, PS_WD = 0, PVC_WD = 0,
                              plastic_waste_disposal = c("Landfill", "Open-loop", "Closed-loop", "Combustion"),
                              units = c("kg", "tonnes")){
  plastic_waste_disposal <- match.arg(plastic_waste_disposal)
  units <- match.arg(units)
  checkmate::assert_numeric(average, lower = 0)
  checkmate::assert_numeric(average_film, lower = 0)
  checkmate::assert_numeric(average_rigid, lower = 0)
  checkmate::assert_numeric(HDPE, lower = 0)
  checkmate::assert_numeric(LDPE, lower = 0)
  checkmate::assert_numeric(LLDPE, lower = 0)
  checkmate::assert_numeric(PET, lower = 0)
  checkmate::assert_numeric(PP, lower = 0)
  checkmate::assert_numeric(PS, lower = 0)
  checkmate::assert_numeric(PVC, lower = 0)
  checkmate::assert_numeric(average_WD, lower = 0)
  checkmate::assert_numeric(average_film_WD, lower = 0)
  checkmate::assert_numeric(average_rigid_WD, lower = 0)
  checkmate::assert_numeric(HDPE_WD, lower = 0)
  checkmate::assert_numeric(LDPE_WD, lower = 0)
  checkmate::assert_numeric(LLDPE_WD, lower = 0)
  checkmate::assert_numeric(PET_WD, lower = 0)
  checkmate::assert_numeric(PP_WD, lower = 0)
  checkmate::assert_numeric(PS_WD, lower = 0)
  checkmate::assert_numeric(PVC_WD, lower = 0)
  
  # set as kg not tonnes
  uk_gov_data <- uk_gov_data %>% dplyr::mutate(value = value/1000)
  MU <- uk_gov_data %>%
    dplyr::filter(`Level 2` == "Plastic") %>%
    dplyr::filter(`Column Text` == "Primary material production") %>%
    dplyr::mutate(`Level 3` = ifelse(`Level 2` %in% c("Plastic"),
                              gsub(".*: ", "", `Level 3`),
                              `Level 3`)) %>%
    dplyr::mutate(`Level 3` = ifelse(`Level 2` == "Plastic",
                              gsub("\\ \\(.*", "", `Level 3`),
                              `Level 3`))
  
  WD <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Waste disposal") %>%
    dplyr::filter(`Level 2` == "Plastic") %>%
    dplyr::filter(`Column Text` == plastic_waste_disposal)
  emission_values <- MU$value
  WD_values <- WD$value
  
  plastic_emissions <- average*emission_values[1] + average_film*emission_values[2] + average_rigid*emission_values[3] +
    HDPE*emission_values[4] + LDPE*emission_values[5] + LLDPE*emission_values[5] + PET*emission_values[6] +
    PP*emission_values[7] + PS*emission_values[8] + PVC*emission_values[9] +
    average_WD*WD_values[1] + average_film_WD*WD_values[2] + average_rigid_WD*WD_values[3] +
    HDPE_WD*WD_values[4] + LDPE_WD*WD_values[5] + LLDPE_WD*WD_values[5] + PET_WD*WD_values[6] +
    PP_WD*WD_values[7] + PS_WD*WD_values[8] + PVC_WD*WD_values[9]
  if (units == "kg") plastic_emissions <- plastic_emissions * 0.001
  return(plastic_emissions)
}
