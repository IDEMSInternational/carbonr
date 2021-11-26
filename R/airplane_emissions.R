airplane_emissions <- function(departing_airport_code, arriving_airport_code, via = NULL, num_people, radiative_force = TRUE, round_trip = FALSE, class = "economy") {
  # departing_airport_code and arriving_airport code are three letter airport codes
  # radiative_force = TRUE (default) will use radiative forcing in the calculation
  # set to FALSE to avoid using radiative forcing
  # round_trip = FALSE (default) will double the cost calculation if set to TRUE
  
  # calculate miles flown
  airports <- c(departing_airport_code, via, arriving_airport_code)
  
  if (length(airports) == 2) {
    miles <- airportr::airport_distance(airports[1], airports[2]) * 0.621371
  } else {
    miles1 <- NULL
    for (m in 2:length(airports)-1){
      miles1[m] <- airportr::airport_distance(airports[m], airports[m+1])
    }
    miles <- sum(miles1) * 0.621371
  }
  
  # times by 0.621371 to give in miles not kms.
  
  co2_emitted <- miles * num_people * 0.24 * 0.000453592
  # 0.24lbs per person on average: https://blueskymodel.org/air-mile
  # note: https://carbonfund.org/how-we-calculate/ - they use 0.2kg per mile, kg in tonnes in 0.001
  # convert to metric tonne; 0.000453592
  
  if (radiative_force == TRUE) {
    co2_emitted <- co2_emitted * 1.891
    # radiative forcing: 1.891 carbonfund.org
  }
  
  if (round_trip == TRUE) {
    co2_emitted <- co2_emitted * 2
  }
  
  # these are taken from calculating differences in DEFRA/conversation 2021 UK file (https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021)
  if (class == "premium economy") {
    co2_emitted <- co2_emitted * 1.6
  } else if (class == "business") {
    co2_emitted <- co2_emitted * 2.9
  } else if (class == "first") {
    co2_emitted <- co2_emitted * 4
  }
  
  return(co2_emitted)
}
