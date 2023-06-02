#' Calculate CO2e emissions from land-travel journeys
#' 
#' @description A function that calculates CO2e emissions on a journey on land. 
#'
#' @param distance Distance in km or miles of the journey made (this can be calculated with other tools, such as google maps.). 
#' @param units Units for the distance travelled. Options are `"km"` or `"miles"`.
#' @param num Number of passengers if `vehicle` is one of `coach`, `tram`, or `tube`. Otherwise, number of vehicles used.
#' @param vehicle Vehicle used for the journey. Options are `"Cars"`, `"Motorbike"`, `"Taxis"`, `"Bus"`, `"National rail"`, `"International rail`, `"Coach"`, `"Light rail and tram"`, `"London Underground"`. Note: car, taxi, motorbike is per vehicle. 
#' @param fuel Fuel type used for the journey. For car, `"Petrol"`, `"Diesel"`, `"Unknown"`, `"Battery Electric Vehicle"`, `"Plug-in Hybrid Electric Vehicle"` are options. ##' `"hybrid electric"` and `"battery electric"` account for electricity kWh emissions. 
#' @param car_type Size/type of vehicle for car.
#' Options are `c("Average car", "Small car", "Medium car", "Large car",`
#' `"Mini", "Supermini", "Lower medium", "Upper medium", "Executive",`
#' `"Luxury", "Sports", "Dual purpose 4X4", "MPV"),`.
#' Small denotes up to a 1.4L engine, unless diesel which is up to 1.7L engine. Medium denotes 1.4-2.0L for petrol cars, 1.7-2.0L for diesel cars. Large denotes 2.0L+ engine.
#' @param bike_type Size of vehicle for motorbike.
#' Options are `"Small"`, `"Medium"`, `"Large"`, or `"Average"`.
#' Sizes denote upto 125cc, 125cc-500cc, 500cc+ respectively.
#' @param bus_type Options are `"local_nL"`, `"local_L"`, `"local"`, or `"average"`. These denote whether the bus is local but outside of London, local in London, local, or average.
#' @param taxi_type Whether a taxi is regular or black cab. Options are `"Regular taxi"`, `"Black cab"`.
#' @param owned_by_org logical. Whether the vehicle used is owned by the organisation or not (only for `car`, `motorbike`).
#' @param include_WTT logical. Well-to-tank (include_WTT) - whether to account for emissions associated with extraction, refining and transportation of the fuels (for non-electric vehicles).
#' @param include_electricity logical. Whether to account for ... for electric vehicles (car and van).
#' @param TD logical.Whether to account for transmission and distribution (TD) for electric vehicles  (only `car` and `van`)
#'
#' @return Tonnes of CO2e emissions per mile travelled.
#' @export
#'
#' @examples # Emissions for a 100 mile car journey
#'  land_emissions(distance = 100)
#' @examples # Emissions for a 100 mile motorbike journey where the motorbike is 500+cc
#'  land_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Large")

land_emissions <- function(distance, units = c("miles", "km"), num = 1,
                           vehicle = c("Cars", "Motorbike", "Taxis", "Bus", "National rail", "International rail",
                                       "Light rail and tram", "London Underground", "Coach"),
                           fuel = c("Petrol", "Diesel", "Unknown", "Battery Electric Vehicle", "Plug-in Hybrid Electric Vehicle"),
                           # TODO Hybrid is also allowed if car size is given (not car type)
                           car_type = c("Average car", "Small car", "Medium car", "Large car",
                                        "Mini", "Supermini", "Lower medium", "Upper medium", "Executive",
                                        "Luxury", "Sports", "Dual purpose 4X4", "MPV"),
                           bike_type = c("Average", "Small", "Medium", "Large"),
                           bus_type = c("Local bus (not London)", "Local London bus", "Average local bus"),
                           taxi_type = c("Regular taxi", "Black cab"),
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
  bus_type <- match.arg(bus_type)
  taxi_type <- match.arg(taxi_type)
  
  if (vehicle %in% c("Cars", "Motorbike")){
    return(vehicle_emissions(distance = distance, units = units, num = num, vehicle = vehicle,
                             fuel = fuel, car_type = car_type, bike_type = bike_type, TD = TD, include_WTT = include_WTT,
                             include_electricity = include_electricity, owned_by_org = owned_by_org))
  } else {
    uk_gov_data_cars <- uk_gov_data %>%
      dplyr::filter(`Level 1` %in% c("Business travel- land",
                                     "UK electricity for EVs",
                                     "UK electricity T&D for EVs",
                                     "WTT- pass vehs & travel (land)"))
    
    uk_gov_data_cars <- uk_gov_data_cars %>%
      dplyr::mutate(`Level 2` = ifelse(`Level 2` == "Rail", `Level 3`, `Level 2`)) %>%
      dplyr::mutate(`Level 2` = ifelse(`Level 3` == "Coach", "Coach", `Level 2`)) %>%
      dplyr::mutate(`Level 3` = ifelse(`Level 2` == `Level 3`, NA, `Level 3`)) %>%
      dplyr::filter(UOM != "km") %>%
      dplyr::mutate(`Level 2` = stringr::str_remove(`Level 2`, "WTT- ")) %>%
      dplyr::mutate(`Level 2` = stringr::str_to_title(`Level 2`, locale = "en"))
    
    
    if (units == "km") {
      distance <- distance * 0.621371
    }
    
    if (vehicle == "Taxis"){
      size <- taxi_type
    } else if (vehicle == "Bus"){
      size <- bus_type
    } else {
      size <- NA
    }
    #else if (vehicle == "van" & fuel %in% c("hybrid", "unknown", "hybrid electric")){
    #warning("van can currently only take fuel options `petrol`, `diesel`, or `battery electric`. Changing fuel type to `petrol`.")
    t_mile <- (uk_gov_data_cars %>%
                 dplyr::filter(`Level 2` == {{ vehicle }}) %>%
                 dplyr::filter(`Level 3` == {{ size }}))
    
    base_emission <- (t_mile %>% dplyr::filter(`Level 1` == "Business travel- land"))$`GHG Conversion Factor 2022`
    
    if (include_WTT){
      base_emission <- base_emission + (t_mile %>% dplyr::filter(`Level 1` == "WTT- pass vehs & travel (land)"))$`GHG Conversion Factor 2022`
    }
    emissions <- distance * base_emission * num
    return(emissions * 0.001)
  }
}
