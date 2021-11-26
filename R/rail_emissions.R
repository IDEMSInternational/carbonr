rail_emissions <- function(from, to, via = NULL, num_people = 1, times_journey = 1, round_trip = FALSE){
  
  if (!(from) %in% c(stations_df$Name)){
    station_names <- agrep(data.frame(from), stations_df$Name, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(from), " is not a name in the data frame. Did you mean: ",
         paste0((data.frame(stations_df) %>% dplyr::filter(Name %in% station_names))$Name, sep = ", ")
         )
  }
  if (!(to) %in% c(stations_df$Name)){
    station_names <- agrep(data.frame(to), stations_df$Name, ignore.case = TRUE, max.distance = 0.15, value = TRUE)
    stop(print(to), " is not a name in the data frame. Did you mean: ",
         paste0((data.frame(stations_df) %>% dplyr::filter(Name %in% station_names))$Name, sep = ", ")
    )
  }
  
  stations_df$id <- 1:nrow(stations_df)
  i <- which(stations_df$Name == {{ from }})
  j <- which(stations_df$Name == {{ to }})
  k <- stations_df[match({{ via }}, stations_df$Name), ]$id # to keep order
  
  latitude_from <- stations_df$Latitude[i]
  longitude_from <- stations_df$Longitude[i]
  latitude_to <- stations_df$Latitude[j]
  longitude_to <- stations_df$Longitude[j]
  latitude_via <- stations_df$Latitude[k]
  longitude_via <- stations_df$Longitude[k]
  
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