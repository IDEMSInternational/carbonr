#' Calculate Ferry Journey Emissions
#' @description A function that calculates CO2e emissions between ferry ports.
#' @param from Port code for the port departing from. Use `seaport_lookup` to find port code.
#' @param to Port code for the port arriving from. Use `seaport_lookup` to find port code.
#' @param via Optional. Takes a vector containing the port code that the ferry travels through. Use `seaport_lookup` to find port code.
#' @param type Whether the journey is taken on foot or by car. Options are `"foot"`, `"car"`, `"average"`.
#' @param num_people Number of people taking the journey. Takes a single numerical value.
#' @param times_journey Number of times the journey is taken.
#' @param round_trip Whether the journey is one-way or return.
#'
#' @return Returns CO2e emissions in tonnes for the ferry journey.
#' @export
#'
#' @examples # Emissions for a ferry journey between Belfast and New York City
#' @examples seaport_lookup(city = "Belfast")
#' seaport_lookup(city = "New York")
#' ferry_emissions(from = "BEL", to = "BOY")
ferry_emissions <- function(from, to, via = NULL, type = "foot", num_people = 1, times_journey = 1, round_trip = FALSE){
  data("seaports", envir = environment())
  if (!is.numeric(num_people)| num_people %% 1 != 0 | num_people < 1){
    stop("`num_people` must be a positive integer")
  }
  if (!is.numeric(times_journey)| times_journey %% 1 != 0 | times_journey < 1){
    stop("`times_journey` must be a positive integer")
  }
  if (!is.logical(round_trip)){
    stop("`round_trip` can only take values TRUE or FALSE")
  }
  if (!type %in% c("foot", "car", "average")){
    stop("`type` can only take values 'foot', 'car', or 'average'")
  }
  if (!(from) %in% c(seaports$port_code)){
    port_codes <- agrep(data.frame(from), seaports$port_code, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(from), " is not a port code in the data frame. Did you mean: ",
         paste0((data.frame(seaports) %>% dplyr::filter(port_code %in% port_codes))$port_code, sep = ", "),
         "\n Otherwise find port code in `seaport_lookup` function"
    )
  }
  if (!(to) %in% c(seaports$port_code)){
    port_codes <- agrep(data.frame(to), seaports$port_code, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(to), " is not a port code in the data frame. Did you mean: ",
         paste0((data.frame(seaports) %>% dplyr::filter(port_code %in% port_codes))$port_code, sep = ", "),
         "\n Otherwise find port code in `seaport_lookup` function"
    )
  } # mention port_codes data set to check station names
  if (!is.null(via)){
    for (i in 1:length(via)){
      via_x <- via[i]
      if (!(via_x) %in% c(seaports$port_code)){
        port_codes <- agrep(data.frame(via_x), seaports$port_code, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
        stop(print(via_x), " is not a port code in the data frame. Did you mean: ",
             paste0((data.frame(seaports) %>% dplyr::filter(port_code %in% port_codes))$port_code, sep = ", "),
             "\n Otherwise find port code in `seaport_lookup` function"
        )
      }
    }
  }
  
  seaports$id <- 1:nrow(seaports)
  i <- which(seaports$port_code == {{ from }})
  j <- which(seaports$port_code == {{ to }})
  k <- seaports[match({{ via }}, seaports$port_code), ]$id # to keep order
  
  latitude_from <- seaports$latitude[i]
  longitude_from <- seaports$longitude[i]
  latitude_to <- seaports$latitude[j]
  longitude_to <- seaports$longitude[j]
  latitude_via <- seaports$latitude[k]
  longitude_via <- seaports$longitude[k]
  
  lats <- c(latitude_from, latitude_via, latitude_to)
  longs <- c(longitude_from, longitude_via, longitude_to)
  
  if (length(lats) == 2) {
    distance <- mapply(FUN = distance_calc, lat1 = lats[1], lat2 = lats[2], long1 = longs[1], long2 = longs[2])
  } else {
    distance1 <- NULL
    for (m in 2:length(lats)-1){
      distance1[m] <- mapply(FUN = distance_calc, lat1 = lats[m], lat2 = lats[m+1], long1 = longs[m], long2 = longs[m+1])
    }
    distance <- sum(distance1)
  }
  
  if (type == "foot"){
    t_mile <- 0.00003015581
  } else if (type == "car"){
    t_mile <- 0.0002084369
  } else if (type == "average"){
    t_mile <- 0.0001816333
  }
  
  emissions <- distance*t_mile*num_people*times_journey
  if (round_trip){
    emissions <- 2*emissions
  }
  
  return(emissions)
}
