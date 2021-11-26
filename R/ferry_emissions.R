ferry_emissions <- function(distance, units = "miles", num_people = 1, times_journey = 1, round_trip = FALSE){ # from, to, via = NULL, num_people = 1, times_journey = 1, round_trip = FALSE){
  
  # TODO: ferry port data set?
  
  # co2e passenger.km
  if (units == "km") {
    distance <- distance * 0.621371
  }
  
  if (type == "foot"){
    t_mile <- 0.00003015581
  } else if (type == "car"){
    t_mile <- 0.0002084369
  } else if (type == "average"){
    t_mile <- 0.0001816333
  }
  
  # "The CO2e emissions for long distance trains (i.e., intercity rail) is 0.114 kgs per passenger mile." - from carbonfund.org
  # 0.000114 tonnes
  # OR: UK defra doco says for national rail:  0.00005711548 tonnes/mile
  emissions <- distance*t_mile*num_people*times_journey
  # for international rail, they say 0.000007177656tonnes CO2e per mile
  if (round_trip){
    emissions <- 2*emissions
  }
  
  return(emissions)
}