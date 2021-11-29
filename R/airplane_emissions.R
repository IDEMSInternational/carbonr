#' Calculate Airplane Emissions
#' @description A function that calculates CO2 emissions between airports. Distances are calculated using the airport_distance function in the airportr package.
#' @param departing_airport_code Takes a three-letter IATA code corresponding to an airport. Can check 
#' @param arriving_airport_code Takes a three-letter IATA code corresponding to an airport.
#' @param via Optional. Takes a vector containing three-letter IATA codes corresponding to airports.
#' @param num_people Number of people taking the flight. Takes a single numerical value.
#' @param radiative_force Whether radiative force should be taken into account. Emissions from airplanes at higher altitudes impact climate change more than at ground level, radiative forcing accounts for this. Recommended. 
#' @param round_trip Whether the flight is one-way or return.
#' @param class Class flown in. Options are "economy", "premium economy", "business", and "first".
#'
#' @return Returns CO2 emissions in tonnes.
#' @export 
#'
#' @examples airplane_emissions("YVR","YYZ")
#' @examples airplane_emissions("LHR", "KIS", via = c("AMS", "NBO"))
airplane_emissions <- function(departing_airport_code, arriving_airport_code, via = NULL, num_people = 1, radiative_force = TRUE, round_trip = FALSE, class = "economy") {

  # check num_people
  if (!is.numeric(num_people) | num_people < 1){
    stop("`num_people` must be a positive integer")
  }
  
  if (!is.logical(radiative_force)){
    stop("`radiative_force` can only take values TRUE or FALSE")
  }
  if (!is.logical(round_trip)){
    stop("`round_trip` can only take values TRUE or FALSE")
  }
  

  if (!(class) %in% c("economy", "premium economy", "business", "first")){
    stop("`class` can only take values 'economy', 'premium economy', 'business', or 'first'")
  }
  
  airport_filter <- airports %>% dplyr::select(c(Name, City, IATA))
  
  if (!(departing_airport_code) %in% c(airport_filter$IATA)){
    airport_names <- agrep(data.frame(departing_airport_code), airport_filter$IATA, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
    stop(print(departing_airport_code), " is not a name in the data frame. Try `airport_lookup` function in `airportr`. Did you mean: ",
         paste0(data.frame(airport_filter %>% dplyr::filter(IATA %in% airport_names))$IATA, sep = ", ")
    )
  }
  
  if (!(arriving_airport_code) %in% c(airport_filter$IATA)){
    airport_names <- agrep(data.frame(arriving_airport_code), airport_filter$IATA, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
    stop(print(arriving_airport_code), " is not a name in the data frame. Try `airport_lookup` function in `airportr`. Did you mean: ",
         paste0(data.frame(airport_filter %>% dplyr::filter(IATA %in% airport_names))$IATA, sep = ", ")
    )
  }
  
  for (i in 1:length(via)){
    via_x <- via[i]
    if (!(via_x) %in% c(airport_filter$IATA)){
      airport_names <- agrep(data.frame(via_x), airport_filter$IATA, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
      stop(print(via_x), " is not a name in the data frame. Try `airport_lookup` function in `airportr`. Did you mean: ",
           paste0(data.frame(airport_filter %>% dplyr::filter(IATA %in% airport_names))$IATA, sep = ", ")
      )
    }
  }
  
  
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
