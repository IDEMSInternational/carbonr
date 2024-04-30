#' Calculate CO2e emissions from a train journey
#' @description A function that calculates CO2e emissions between train stations in the UK.
#' @param from Station departing from.
#' @param to Station arriving to
#' @param via Optional. Takes a vector containing the stations the train travels via.
#' @param num_people Number of people taking the journey. Takes a single numerical value.
#' @param times_journey Number of times the journey is taken.
#' @param include_WTT logical. Recommended \code{TRUE}. Whether to include emissions associated with extracting, refining, and transporting fuels.
#' @param round_trip Whether the journey is one-way or return.
# @param class Class travelled in. Options are ...
#' @return Returns CO2e emissions in tonnes for the train journey.
#' @details The distances are calculated using the Haversine formula. This is calculated as the crow flies. As a result, inputting the "via" journeys will make for a more reliable function.
#' @export
#' @examples # Emissions for a train journey between Southampton Central and Manchester Piccadilly Station
#' @examples rail_emissions("Southampton Central", "Manchester Piccadilly")
#' @examples # Emissions for a train journey between Bristol Temple Meads and London Paddington
#' @examples # via Bath, Swindon, and Reading
#' # Use the \code{rail_finder} function to find the name of London Paddington
#' rail_finder(region = "London")
#' # Then calculate emissions
#' @examples rail_emissions("Bristol Temple Meads", "Paddington", via = c("Bath Spa",
#' "Swindon", "Reading"))
rail_emissions <- function(from, to, via = NULL, num_people = 1, times_journey = 1, include_WTT = TRUE, round_trip = FALSE){
  data("stations", envir = environment())
  
  checkmate::assert_string(from)
  checkmate::assert_string(to)
  if (!is.null(via)) { checkmate::assert_character(via) }
  checkmate::assert_count(num_people)
  checkmate::assert_count(times_journey)
  checkmate::assert_logical(include_WTT)
  checkmate::assert_logical(round_trip)
  
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
  
  latitude_from <- stations$latitude[i]
  longitude_from <- stations$longitude[i]
  latitude_to <- stations$latitude[j]
  longitude_to <- stations$longitude[j]
  latitude_via <- stations$latitude[k]
  longitude_via <- stations$longitude[k]
  
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
  distance <- distance * 1.609 # convert to KM
  uk_gov_data_rail <- uk_gov_data %>% dplyr::filter(`Level 3` == "National rail")
  
  emissions <- (uk_gov_data_rail %>% dplyr::filter(`Level 2` == "Rail"))$value
  if (include_WTT){ emissions <- emissions + (uk_gov_data_rail %>% dplyr::filter(`Level 2` == "WTT- rail"))$value }
  emissions <- emissions*distance*num_people*times_journey
  if (round_trip){
    emissions <- 2*emissions
  }
  return(emissions * 0.001) # give in tonnes
}
