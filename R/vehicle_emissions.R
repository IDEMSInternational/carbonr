#' Calculate CO2e emissions from land-travel journeys
#' 
#' @description A function that calculates CO2e emissions on a journey on land. 
#'
#' @param distance Distance in km or miles of the journey made (this can be calculated with other tools, such as google maps.). 
#' @param units Units for the distance travelled. Options are `"km"` or `"miles"`.
#' @param num Number of passengers if `vehicle` is one of `coach`, `tram`, or `tube`. Otherwise, number of vehicles used.
#' @param vehicle Vehicle used for the journey. Options are `"car"`, `"motorbike"`, `"taxi"`, `"van"`, `"bus"`, `"coach"`, `"tram"`, `"tube"`. Note: bus, coach, tram, tube, are all per passenger 
#' @param fuel Fuel type used for the journey. For car, `"petrol"`, `"diesel"`, `"hybrid"`, `"unknown"`, `"hybrid electric"`, `"battery electric"` are options. For van, `"petrol"`, `"diesel"`, and `"battery electric"` are options.
#' `"hybrid electric"` and `"battery electric"` account for electricity kWh emissions. 
#' @param size Size of vehicle for car, motorbike, and van.
#' Options are `"small"`, `"medium"`, `"large"`, or `"average"`.
#' For car: small denotes up to a 1.4L engine, unless diesel which is up to 1.7L engine. Medium denotes 1.4-2.0L for petrol cars, 1.7-2.0L for diesel cars. Large denotes 2.0L+ engine.
#' For motorbike, sizes denote upto 125cc, 125cc-500cc, 500cc+ respectively.
#' @param bus_type Options are `"local_nL"`, `"local_L"`, `"local"`, or `"average"`. These denote whether the bus is local but outside of London, local in London, local, or average.
#' @param taxi_type Whether a taxi is regular or black cab. Options are `"regular"`, `"black cab"`.
#' @param owned_by_org logical. Whether the vehicle used is owned by the organisation or not (only for `car`, `motorbike`).
#' @param WTT logical. Well-to-tank (WTT) - whether to account for emissions associated with extraction, refining and transportation of the fuels (... in electric vehicles case)
#' @param include_electricity logical. Whether to account for ... for electric vehicles (car and van).
#' @param TD logical.Whether to account for transmission and distribution (TD) for electric vehicles  (only `car` and `van`)
#'
#' @return Tonnes of CO2e emissions per mile travelled.
#' @export
#'
#' @examples # Emissions for a 100 mile car journey
#'  vehicle_emissions(distance = 100)
#' @examples # Emissions for a 100 mile motorbike journey where the motorbike is 500+cc
#'  vehicle_emissions(distance = 100, vehicle = "motorbike", size = "large")

vehicle_emissions <- function(distance, units = c("miles", "km"), num = 1, vehicle = c("car", "motorbike", "taxi", "van", "bus", "coach", "tram", "tube"),
                              fuel = c("petrol", "diesel", "hybrid", "unknown", "hybrid electric", "battery electric"),
                              size = c("average", "small", "medium", "large"),
                              bus_type = c("local not London", "local London", "average"), taxi_type = c("regular", "black cab"),
                              TD = TRUE, WTT = TRUE, include_electricity = TRUE, owned_by_org = TRUE){
  
  checkmate::assert_numeric(distance, lower = 0)
  checkmate::assert_logical(TD)
  checkmate::assert_logical(WTT)
  checkmate::assert_logical(include_electricity)
  checkmate::assert_logical(owned_by_org)
  units <- match.arg(units)
  vehicle <- match.arg(vehicle)
  fuel <- match.arg(fuel)
  size <- match.arg(size)
  bus_type <- match.arg(bus_type)
  taxi_type <- match.arg(taxi_type)
  
  if (units == "km") {
    distance <- distance * 0.621371
  }
  
  if (vehicle == "taxi"){
    size <- taxi_type
    fuel <- 1
  } else if (vehicle == "bus"){
    size <- bus_type
    fuel <- 1
  } else if (vehicle == "motorbike"){
    fuel <- 1
  } else if (vehicle == "coach" | vehicle == "tram" | vehicle == "tube"){
    size <- 1
    fuel <- 1
  } else if (vehicle == "van" & fuel %in% c("hybrid", "unknown", "hybrid electric")){
    warning("van can currently only take fuel options `petrol`, `diesel`, or `battery electric`. Changing fuel type to `petrol`.")
    fuel <- "petrol"
  }
  
  t_mile <- (vehicles %>%
    dplyr::filter(vehicle == {{ vehicle }}) %>%
    dplyr::filter(size == {{ size }}) %>%
    dplyr::filter(fuel == {{ fuel }}))
  
  # All of the vehicles and options have WTT
  if (WTT == FALSE){
    t_mile <- t_mile %>% dplyr::filter(WTT == FALSE)
  }
  
  # only car and motorbike have an option for owned_by_org to be TRUE
  if (!vehicle %in% c("car", "motorbike")){ # van has values the same regardless
    owned_by_org = FALSE
  }
  t_mile <- t_mile %>% dplyr::filter(.data$`Owned/controlled by reporting org` %in% c("both", {{ owned_by_org }}))
  if (fuel %in% c("hybrid electric", "battery electric")){
    if (include_electricity == FALSE){
      t_mile <- t_mile %>% dplyr::filter(.data$`include electricity` == FALSE)
    }
    if (TD == FALSE){
      t_mile <- t_mile %>% dplyr::filter(TD == FALSE)
    }
  }

  t_mile_sum <- sum(t_mile$CO2e)

  emissions <- distance * t_mile_sum * num
  return(emissions)
}
