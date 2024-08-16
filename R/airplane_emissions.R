#' Calculate CO2e emissions from an airplane journey
#'
#' This function calculates the CO2e emissions between airports based on the provided parameters. The distances are calculated using the "airport_distance" function from the "airportr" package.
#'
#' @param from Three-letter IATA code corresponding to the departure airport. You can check the IATA code using the "airport_finder" function.
#' @param to Three-letter IATA code corresponding to the destination airport. You can check the IATA code using the "airport_finder" function.
#' @param via Optional. Vector of three-letter IATA codes corresponding to airports for any layovers or stops along the route.
#' @param num_people Number of people taking the flight. Must be a single numerical value.
#' @param radiative_force Logical. Determines whether radiative forcing should be taken into account. It is recommended to set this parameter as TRUE since emissions from airplanes at higher altitudes have a greater impact on climate change than those at ground level.
#' @param include_WTT Logical. Determines whether emissions associated with extracting, refining, and transporting fuels should be included. It is recommended to set this parameter as TRUE.
#' @param round_trip Logical. Determines if the flight is round trip (return) or one-way. Default is FALSE (one-way).
#' @param class Class flown in. Options include "Average passenger", "Economy class", "Business class", "Premium economy class", and "First class".
#' @return Returns CO2e emissions in tonnes.
#' @export 
#' @details The distances are calculated using the "airport_distance" function from the "airportr" package. This means that the distances between locations uses the Haversine formula. This is calculated as the crow flies.
#' @examples # Calculate emissions for a flight between Vancouver (YVR) and Toronto (YYZ)
#' airplane_emissions("YVR", "YYZ")
#' @examples # Calculate emissions for a flight between London Heathrow (LHR)
#' # and Kisumu Airport (KIS), with layovers in Amsterdam (AMS) and Nairobi
#' # (NBO), flying in Economy class.
#' airplane_emissions("LHR", "KIS", via = c("AMS", "NBO"),
#'                    class = "Economy class")
airplane_emissions <- function(from, to, via = NULL, num_people = 1, radiative_force = TRUE, include_WTT = TRUE, round_trip = FALSE, class = c("Average passenger", "Economy class", "Business class", "Premium economy class", "First class")) {
  checkmate::assert_string(from)
  checkmate::assert_string(to)
  if (!is.null(via)) { checkmate::assert_character(via) }
  checkmate::assert_count(num_people)
  checkmate::assert_logical(radiative_force)
  checkmate::assert_logical(round_trip)
  checkmate::assert_logical(include_WTT)
  class <- match.arg(class)
  
  # Retrieve airport data
  airport_filter <- airports %>% dplyr::select(Name, City, IATA)
  
  # Check if from, to, and via airports are valid
  check_valid_airport <- function(airport_code) {
    if (!(airport_code) %in% airport_filter$IATA) {
      airport_names <- agrep(data.frame(airport_code), airport_filter$IATA, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
      stop(paste(airport_code, "is not a valid IATA code. Did you mean:", paste0(data.frame(airport_filter %>% dplyr::filter(IATA %in% airport_names))$IATA, collapse = ", ")))
    }
  }
  
  check_valid_airport(from)
  check_valid_airport(to)
  if (!is.null(via)) {
    sapply(via, check_valid_airport)
  }
  
  # Calculate the distance flown in kilometers
  airports <- c(from, via, to)
  if (length(airports) == 2) {
    km <- airportr::airport_distance(airports[1], airports[2])  # returns distance in km
  } else {
    km1 <- NULL
    for (m in 2:length(airports)-1){
      km1[m] <- airportr::airport_distance(airports[m], airports[m+1])
    }
    km <- sum(km1)
  }
  
  # Retrieve relevant data
  uk_gov_data_air <- uk_gov_data %>%
    # 2022 report says (air), 2023 says - air
    dplyr::filter(`Level 1` %in% c("Business travel- air", "WTT- business travel (air)", "WTT- business travel- air")) %>%
    dplyr::filter(`Column Text` == "With RF")
  uk_gov_data_air_WTT <-  uk_gov_data_air %>%
    dplyr::filter(`Level 2` == "WTT- flights")
  uk_gov_data_air <-  uk_gov_data_air %>%
    dplyr::filter(`Level 2` == "Flights")
  
  # Determine flight category based on distance (short-haul or long-haul)
  if (km < 2050) {
    uk_gov_data_air <- uk_gov_data_air %>% dplyr::filter(`Level 3` == "Short-haul, to/from UK")
    uk_gov_data_air_WTT <- uk_gov_data_air_WTT %>% dplyr::filter(`Level 3` == "Short-haul, to/from UK")
  } else {
    uk_gov_data_air <- uk_gov_data_air %>% dplyr::filter(`Level 3` == "Long-haul, to/from UK")
    uk_gov_data_air_WTT <- uk_gov_data_air_WTT %>% dplyr::filter(`Level 3` == "Long-haul, to/from UK")
  }
  
  uk_gov_data_air <- uk_gov_data_air %>% dplyr::filter(`Level 4` %in% class)
  uk_gov_data_air_WTT <- uk_gov_data_air_WTT %>% dplyr::filter(`Level 4` %in% class)
  
  # Perform emissions calculation
  co2_emitted <- km * uk_gov_data_air$`value`
  if (!radiative_force) co2_emitted <- co2_emitted * 0.5286915
  if (include_WTT) co2_emitted <- co2_emitted + (km * num_people * uk_gov_data_air_WTT$`value`)
  if (round_trip) co2_emitted <- co2_emitted * 2
  
  return(co2_emitted * 0.001)  # Convert to tonnes and return CO2e emissions
}
