#' Calculate CO2e emissions from land-travel journeys
#' 
#' @description A function that calculates CO2e emissions on a journey on land. 
#'
#' @param distance Distance in km or miles of the journey made (this can be calculated with other tools, such as google maps.). 
#' @param units Units for the distance travelled. Options are `"km"` or `"miles"`.
#' @param num Number of vehicles used.
#' @param vehicle Vehicle used for the journey. Options are `"Cars"`, `"Motorbike"`.
#' @param fuel Fuel type used for the journey. For car, `"Petrol"`, `"Diesel"`, `"Unknown"`, `"Battery Electric Vehicle"`, `"Plug-in Hybrid Electric Vehicle"` are options. ##' `"hybrid electric"` and `"battery electric"` account for electricity kWh emissions. 
#' @param car_type Size/type of vehicle for car.
#' Options are `c("Average car", "Small car", "Medium car", "Large car",`
#' `"Mini", "Supermini", "Lower medium", "Upper medium", "Executive",`
#' `"Luxury", "Sports", "Dual purpose 4X4", "MPV"),`.
#' Small denotes up to a 1.4L engine, unless diesel which is up to 1.7L engine. Medium denotes 1.4-2.0L for petrol cars, 1.7-2.0L for diesel cars. Large denotes 2.0L+ engine.
#' @param bike_type Size of vehicle for motorbike.
#' Options are `"Small"`, `"Medium"`, `"Large"`, or `"Average"`.
#' Sizes denote upto 125cc, 125cc-500cc, 500cc+ respectively.
#' @param owned_by_org logical. Whether the vehicle used is owned by the organisation or not (only for `car`, `motorbike`).
#' @param include_WTT logical. Well-to-tank (include_WTT) - whether to account for emissions associated with extraction, refining and transportation of the fuels (for non-electric vehicles).
#' @param include_electricity logical. Whether to account for ... for electric vehicles (car and van).
#' @param TD logical.Whether to account for transmission and distribution (TD) for electric vehicles  (only `car` and `van`)
#'
#' @return Tonnes of CO2e emissions per mile travelled.
#' @export
#'
#' @examples # Emissions for a 100 mile car journey
#'  vehicle_emissions(distance = 100)
#'
#' # Emissions for a 100 mile motorbike journey where the motorbike is 500+cc
#'  vehicle_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Large")

vehicle_emissions <- function(distance, units = c("miles", "km"), num = 1,
                              vehicle = c("Cars", "Motorbike"),
                              fuel = c("Petrol", "Diesel", "Unknown", "Battery Electric Vehicle", "Plug-in Hybrid Electric Vehicle"),
                              # TODO Hybrid is also allowed if car size is given (not car type)
                              car_type = c("Average car", "Small car", "Medium car", "Large car",
                                           "Mini", "Supermini", "Lower medium", "Upper medium", "Executive",
                                           "Luxury", "Sports", "Dual purpose 4X4", "MPV"),
                              bike_type = c("Average", "Small", "Medium", "Large"),
                              TD = TRUE, include_WTT = TRUE, include_electricity = TRUE, owned_by_org = TRUE){
  
  checkmate::assert_numeric(distance, lower = 0)
  checkmate::assert_logical(TD)
  checkmate::assert_logical(include_WTT)
  checkmate::assert_logical(include_electricity)
  checkmate::assert_logical(owned_by_org)
  units <- match.arg(units)
  vehicle <- match.arg(vehicle)
  fuel <- match.arg(fuel)
  car_type <- match.arg(car_type)
  bike_type <- match.arg(bike_type)
  
  uk_gov_data_cars <- uk_gov_data %>%
    dplyr::filter(`Level 1` %in% c("Business travel- land",
                                   "UK electricity for EVs",
                                   "UK electricity T&D for EVs",
                                   "WTT- pass vehs & travel (land)",
                                   "WTT- pass vehs & travel- land"))
  
  uk_gov_data_cars <- uk_gov_data_cars %>%
    dplyr::mutate(`Level 2` = ifelse(`Level 2` %in% c("Cars (by size)", "Cars (by market segment)"),
                                     "Cars",
                                     `Level 2`)) %>%
    dplyr::mutate(`Level 2` = ifelse(`Level 2` %in% c("WTT- cars (by size)", "WTT- cars (by market segment)"),
                                     "WTT- cars",
                                     `Level 2`)) %>%
    dplyr::mutate(`Level 3` = ifelse(`Level 2` == `Level 3`, NA, `Level 3`)) %>%
    dplyr::filter(UOM != "km") %>%
    dplyr::mutate(`Level 2` = stringr::str_remove(`Level 2`, "WTT- ")) %>%
    dplyr::mutate(`Level 2` = stringr::str_to_title(`Level 2`, locale = "en"))
  
  
  if (units == "km") {
    distance <- distance * 0.621371
  }
  
  if (vehicle == "Cars") {
    size <- car_type
  } else if (vehicle == "Motorbike"){
    size <- bike_type
  } else {
    size <- NA
  }
  
  #else if (vehicle == "van" & fuel %in% c("hybrid", "unknown", "hybrid electric")){
  #warning("van can currently only take fuel options `petrol`, `diesel`, or `battery electric`. Changing fuel type to `petrol`.")
  t_mile <- (uk_gov_data_cars %>%
               dplyr::filter(`Level 2` == {{ vehicle }}) %>%
               dplyr::filter(`Level 3` == {{ size }}))
  
  if (vehicle == "Cars") {
    t_mile <- t_mile %>% dplyr::filter(`Column Text` == {{ fuel }})
  }
  
  base_emission <- (t_mile %>% dplyr::filter(`Level 1` == "Business travel- land"))$`value`
  
  if (include_WTT){
    base_emission <- base_emission + (t_mile %>% dplyr::filter(`Level 1` %in% c("WTT- pass vehs & travel (land)", "WTT- pass vehs & travel- land")))$`value`
  }
  
  # TODO: car and motorbike have an option for owned_by_org to be TRUE 
  #if (!vehicle %in% c("car", "motorbike")){ 
  #  owned_by_org = FALSE
  #}
  if (fuel %in% c("Plug-in Hybrid Electric Vehicle", "Battery Electric Vehicle")){
    if (include_electricity){
      base_emission <- base_emission + (t_mile %>% dplyr::filter(`Level 1` == "UK electricity for EVs"))$`value`
    }
    if (TD){
      base_emission <- base_emission + (t_mile %>% dplyr::filter(`Level 1` == "UK electricity T&D for EVs"))$`value`
    }
  }
  emissions <- distance * base_emission * num
  return(emissions * 0.001)
}
