#' Calculate CO2e emissions from a airplane journey
#' @description A function that calculates CO2e emissions between airports. Distances are calculated using the airport_distance function in the airportr package.
#' @param from Takes a three-letter IATA code corresponding to an airport. Can check the IATA code by the `airport_finder` function.
#' @param to Takes a three-letter IATA code corresponding to an airport. Can check the IATA code by the `airport_finder` function.
#' @param via Optional. Takes a vector containing three-letter IATA codes corresponding to airports.
#' @param num_people Number of people taking the flight. Takes a single numerical value.
#' @param radiative_force logical. Whether radiative force should be taken into account. Recommended \code{TRUE}. Emissions from airplanes at higher altitudes impact climate change more than at ground level, radiative forcing accounts for this. 
#' @param round_trip logical. Whether the flight is one-way or return.
#' @param class Class flown in. Options are \code{c("economy", "premium economy", "business", "first")}.
#'
#' @return Returns CO2e emissions in tonnes.
#' @export 
#' @examples # Emissions for a flight between Vancouver and Toronto
#' airplane_emissions("YVR","YYZ")
#' @examples # Emissions for a flight between London Heathrow and Kisumu Airport, via Amsterdam and Nairobi
#' airplane_emissions("LHR", "KIS", via = c("AMS", "NBO"))

airplane_emissions <- function(from, to, via = NULL, num_people = 1, radiative_force = TRUE, round_trip = FALSE, class = c("economy", "premium economy", "business", "first")) {

  checkmate::assert_string(from)
  checkmate::assert_string(to)
  if (!is.null(via)) { checkmate::assert_character(via) }
  checkmate::assert_count(num_people)
  checkmate::assert_logical(radiative_force)
  checkmate::assert_logical(round_trip)
  class <- match.arg(class)
  
  airport_filter <- airportr::airports %>% dplyr::select(c(Name, City, IATA))
  if (!(from) %in% c(airport_filter$IATA)){
    airport_names <- agrep(data.frame(from), airport_filter$IATA, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
    stop(print(from), " is not a name in the data frame. Try `airport_finder` function. Did you mean: ",
         paste0(data.frame(airport_filter %>% dplyr::filter(IATA %in% airport_names))$IATA, sep = ", ")
    )
  }
  if (!(to) %in% c(airport_filter$IATA)){
    airport_names <- agrep(data.frame(to), airport_filter$IATA, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
    stop(print(to), " is not a name in the data frame. Try `airport_finder` function. Did you mean: ",
         paste0(data.frame(airport_filter %>% dplyr::filter(IATA %in% airport_names))$IATA, sep = ", ")
    )
  }
  if (!is.null(via)){
    for (i in 1:length(via)){
      via_x <- via[i]
      if (!(via_x) %in% c(airport_filter$IATA)){
        airport_names <- agrep(data.frame(via_x), airport_filter$IATA, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
        stop(print(via_x), " is not a name in the data frame. Try `airport_finder` function. Did you mean: ",
             paste0(data.frame(airport_filter %>% dplyr::filter(IATA %in% airport_names))$IATA, sep = ", ")
        )
      }
    }
  }
  
  # calculate miles flown
  airports <- c(from, via, to)
  
  if (length(airports) == 2) {
    miles <- airportr::airport_distance(airports[1], airports[2]) * 0.621371
  } else {
    miles1 <- NULL
    for (m in 2:length(airports)-1){
      miles1[m] <- airportr::airport_distance(airports[m], airports[m+1])
    }
    miles <- sum(miles1) * 0.621371
  }
  
  if (miles < 2300){
    co2_emitted <- miles * num_people * 0.000128489706
  } else {
    co2_emitted <- miles * num_people * 0.000125818201
  }
  
  if (radiative_force == TRUE) {
    co2_emitted <- co2_emitted * 1.891
  }
  
  if (round_trip == TRUE) {
    co2_emitted <- co2_emitted * 2
  }
  
  if (class == "premium economy") {
    co2_emitted <- co2_emitted * 1.6
  } else if (class == "business") {
    co2_emitted <- co2_emitted * 2.9
  } else if (class == "first") {
    co2_emitted <- co2_emitted * 4
  }
  
  return(co2_emitted)
}
