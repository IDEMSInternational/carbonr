#' Calculate CO2e emissions from a hotel stay
#' 
#' @description Indirect emissions from a stay at a hotel. Values to calculate emissions are from UK government 2024 report.
#'
#' @param location Location of the hotel stay. Current accepted locations are `"UK"`, `"UK (London)"`, `"Australia"`, `"Belgium"`, `"Brazil"`, `"Canada"`, `"Chile"`, `"China"`, `"Colombia"`, `"Costa Rica"`, `"Egypt"`, `"France"`, `"Germany"`, `"Hong Kong, China"`, `"India"`, `"Indonesia"`, `"Italy"`, `"Japan"`, `"Jordan"`, `"Korea"`, `"Malaysia"`, `"Maldives"`, `"Mexico"`, `"Netherlands"`, `"Oman"`, `"Philippines"`, `"Portugal"`, `"Qatar"`, `"Russia"`, `"Saudi Arabia"`, `"Singapore"`, `"South Africa"`, `"Spain"`, `"Switzerland"`, `"Thailand"`, `"Turkey"`, `"United Arab Emirates"`, `"United States"`, `"Vietnam"`.
#' @param nights Number of nights stayed in the hotel.
#' @param rooms Number of rooms used in the hotel.
#'
#' @return Tonnes of CO2e emissions for a stay in a hotel.
#' @export
#'
#' @examples # Emissions for a two night stay in Australia.
#' hotel_emissions(location = "Australia", nights = 2)
hotel_emissions <- function(location = "UK", nights = 1, rooms = 1){
  checkmate::assert_count(nights)
  checkmate::assert_count(rooms)
  
  uk_gov_data_hotel <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Hotel stay") %>%
    dplyr::filter(!is.na(value))
  
  row <- which(uk_gov_data_hotel$`Level 3` == location)
  if (length(row) == 0) {
      hotel_names <- agrep(data.frame(location), uk_gov_data_hotel$`Level 3`, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
      if (length(hotel_names) == 0) {
        stop("location not recognised. Available options are: ", paste0(uk_gov_data_hotel$`Level 3`, ", "))
      } else {
        stop("location not recognised. Did you mean: ", paste0(hotel_names, ", "), "?")
      }
  } else {
    emissions <- uk_gov_data_hotel$value[row] * 0.001
  }
emissions <- emissions * nights * rooms
return(emissions)
}
