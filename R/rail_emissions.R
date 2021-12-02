#' Calculate Train Journey Emissions
#' @description A function that calculates CO2 emissions between train stations in the UK.
#' @param from Station departing from.
#' @param to Station arriving to
#' @param via Optional. Takes a vector containing the stations the train travels via.
#' @param num_people Number of people taking the journey. Takes a single numerical value.
#' @param times_journey Number of times the journey is taken.
#' @param round_trip Whether the journey is one-way or return.
# @param class Class travelled in. Options are ... .
#'
#' @return Returns CO2 emissions in tonnes for the train journey.
#' @export
#' @examples # Emissions for a train journey between Southampton Central and Manchester Piccadilly Station
#' @examples rail_emissions("Southampton Central", "Manchester Piccadilly")
#' @examples # Emissions for a train journey between Bristol Temple Meads and London Paddington
#' @examples # via Bath, Swindon, and Reading
#' @examples rail_emissions("Bristol Temple Meads", "London Paddington", via = c("Bath Spa",
#' "Swindon", "Reading"))
rail_emissions <- function(from, to, via = NULL, num_people = 1, times_journey = 1, round_trip = FALSE){
  data("stations", envir = environment())
  if (!is.numeric(num_people)| num_people %% 1 != 0 | num_people < 1){
    stop("`num_people` must be a positive integer")
  }
  if (!is.numeric(times_journey)| times_journey %% 1 != 0 | times_journey < 1){
    stop("`times_journey` must be a positive integer")
  }
  if (!is.logical(round_trip)){
    stop("`round_trip` can only take values TRUE or FALSE")
  }
  if (!(from) %in% c(stations$station)){
    station_names <- agrep(data.frame(from), stations$station, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(from), " is not a name in the data frame. Did you mean: ",
         paste0((data.frame(stations) %>% dplyr::filter(station %in% station_names))$station, sep = ", ")
         )
  }
  if (!(to) %in% c(stations$station)){
    station_names <- agrep(data.frame(to), stations$station, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(to), " is not a name in the data frame. Did you mean: ",
         paste0((data.frame(stations) %>% dplyr::filter(station %in% station_names))$station, sep = ", ")
    )
  } # mention station_names data set to check station names
  if (!is.null(via)){
    for (i in 1:length(via)){
    via_x <- via[i]
    if (!(via_x) %in% c(stations$station)){
      station_names <- agrep(data.frame(via_x), stations$station, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
      stop(print(via_x), " is not a name in the data frame. Did you mean: ",
           paste0((data.frame(stations) %>% dplyr::filter(station %in% station_names))$station, sep = ", ")
      )
    }
    }
  }
  
  stations$id <- 1:nrow(stations)
  i <- which(stations$station == {{ from }})
  j <- which(stations$station == {{ to }})
  k <- stations[match({{ via }}, stations$station), ]$id # to keep order
  
  latitude_from <- stations$Latitude[i]
  longitude_from <- stations$Longitude[i]
  latitude_to <- stations$Latitude[j]
  longitude_to <- stations$Longitude[j]
  latitude_via <- stations$Latitude[k]
  longitude_via <- stations$Longitude[k]
  
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
  
  # "The CO2e emissions for long distance trains (i.e., intercity rail) is 0.114 kgs per passenger mile." - from carbonfund.org
  # 0.000114 tonnes
  # OR: UK defra doco says for national rail:  0.00005711548 tonnes/mile
  emissions <- 0.00005711548*distance*num_people*times_journey
  # for international rail, they say 0.000007177656tonnes CO2e per mile
  if (round_trip){
    emissions <- 2*emissions
  }
  
  return(emissions)
}
