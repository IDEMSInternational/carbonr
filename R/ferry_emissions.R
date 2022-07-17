#' Calculate CO2e emissions from ferry journeys
#' @description A function that calculates CO2e emissions between ferry ports.
#' @param from Port code for the port departing from. Use `seaport_finder` to find port code.
#' @param to Port code for the port arriving from. Use `seaport_finder` to find port code.
#' @param via Optional. Takes a vector containing the port code that the ferry travels through. Use `seaport_finder` to find port code.
#' @param type Whether the journey is taken on foot or by car. Options are `"Foot"`, `"Car"`, `"Average"`.
#' @param num_people Number of people taking the journey. Takes a single numerical value.
#' @param times_journey Number of times the journey is taken.
#' @param include_WTT logical. Recommended \code{TRUE}. Whether to include emissions associated with extracting, refining, and transporting fuels.
#' @param round_trip Whether the journey is one-way or return.
#'
#' @return Returns CO2e emissions in tonnes for the ferry journey.
#' @export
#'
#' @examples # Emissions for a ferry journey between Belfast and New York City
#' @examples seaport_finder(city = "Belfast")
#' seaport_finder(city = "New York")
#' ferry_emissions(from = "BEL", to = "BOY")
ferry_emissions <- function(from, to, via = NULL, type = c("Foot", "Car", "Average"), num_people = 1, times_journey = 1, include_WTT = TRUE, round_trip = FALSE){
  data("seaports", envir = environment())
  
  checkmate::assert_string(from)
  checkmate::assert_string(to)
  if (!is.null(via)) { checkmate::assert_character(via) }
  checkmate::assert_count(num_people)
  checkmate::assert_count(times_journey)
  checkmate::assert_logical(include_WTT)
  checkmate::assert_logical(round_trip)
  type <- match.arg(type)
  
  if (!(from) %in% c(seaports$port_code)){
    port_codes <- agrep(data.frame(from), seaports$port_code, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(from), " is not a port code in the data frame. Did you mean: ",
         paste0((data.frame(seaports) %>% dplyr::filter(port_code %in% port_codes))$port_code, sep = ", "),
         "\n Otherwise find port code in `seaport_finder` function"
    )
  }
  if (!(to) %in% c(seaports$port_code)){
    port_codes <- agrep(data.frame(to), seaports$port_code, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(to), " is not a port code in the data frame. Did you mean: ",
         paste0((data.frame(seaports) %>% dplyr::filter(port_code %in% port_codes))$port_code, sep = ", "),
         "\n Otherwise find port code in `seaport_finder` function"
    )
  } # mention port_codes data set to check station names
  if (!is.null(via)){
    for (i in 1:length(via)){
      via_x <- via[i]
      if (!(via_x) %in% c(seaports$port_code)){
        port_codes <- agrep(data.frame(via_x), seaports$port_code, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
        stop(print(via_x), " is not a port code in the data frame. Did you mean: ",
             paste0((data.frame(seaports) %>% dplyr::filter(port_code %in% port_codes))$port_code, sep = ", "),
             "\n Otherwise find port code in `seaport_finder` function"
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
  
  # distance_calc gives distance in miles.
  if (length(lats) == 2) {
    distance <- mapply(FUN = distance_calc, lat1 = lats[1], lat2 = lats[2], long1 = longs[1], long2 = longs[2])
  } else {
    distance1 <- NULL
    for (m in 2:length(lats)-1){
      distance1[m] <- mapply(FUN = distance_calc, lat1 = lats[m], lat2 = lats[m+1], long1 = longs[m], long2 = longs[m+1])
    }
    distance <- sum(distance1)
  }
  
  # convert to km
  distance <- distance * 1.609
  
  uk_gov_data_ferry <- uk_gov_data %>% dplyr::filter(`Level 1` %in% c("Business travel- sea", "WTT- business travel (sea)"))
  uk_gov_data_ferry_WTT <- uk_gov_data_ferry %>% dplyr::filter(`Level 2` == "WTT- ferry")
  uk_gov_data_ferry <- uk_gov_data_ferry %>% dplyr::filter(`Level 2` == "Ferry")
  
  uk_gov_data_ferry <- uk_gov_data_ferry %>% dplyr::filter(grepl(type, `Level 3`))
  uk_gov_data_ferry_WTT <- uk_gov_data_ferry_WTT %>% dplyr::filter(grepl(type, `Level 3`))
  
  t_mile <- uk_gov_data_ferry$`GHG Conversion Factor 2022`
  if (include_WTT) t_mile <- t_mile + uk_gov_data_ferry_WTT$`GHG Conversion Factor 2022`
  
  emissions <- distance*t_mile*num_people*times_journey
  
  if (round_trip) emissions <- 2*emissions
  return(emissions * 0.001) # to give in tonnes
}
