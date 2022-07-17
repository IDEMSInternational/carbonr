#' Calculate CO2e emissions from a hotel stay
#' 
#' @description Indirect emissions from a stay at a hotel. Values to calculate emissions are from UK government 2022 report.
#'
#' @param location Location of the hotel stay. Current accepted locations are `"UK"`, `"UK (London)"` `"Argentina"`, `"Australia"`, `"Austria"`, `"Belgium"`, `"Brazil"`, `"Canada"`, `"Chile"`, `"China"`, `"Colombia"`, `"Costa Rica"`, `"Czechia"`, `"Egypt"`, `"Fiji"`, `"France"`, `"Germany"`,  `"Greece"`, `"Hong Kong, China"`, `"India"`, `"Indonesia"`, `"Ireland"`, `"Israel"`, `"Italy"`, `"Japan"`, `"Jordan"`, `"Korea"`, `"Macau"`, `"Malaysia"`, `"Maldives"`, `"Mexico"`, `"Netherlands"`, `"New Zealand"`, `"Oman"`, `"Panama"`, `"Peru"`, `"Philippines"`, `"Poland"`, `"Portugal"`, `"Qatar"`, `"Romania"`, `"Russia"`, `"Saudi Arabia"`, `"Singapore"`, `"Slovakia"`, `"South Africa"`, `"Spain"`, `"Switzerland"`, `"Taiwan"`, `"Thailand"`, `"Turkey"`, `"United Arab Emirates"`, `"United States"`, `"Vietnam"`.
#' @param nights Number of nights stayed in the hotel.
#' @param rooms Number of rooms used in the hotel.
#'
#' @return Tonnes of CO2e emissions for a stay in a hotel.
#' @export
#'
#' @examples # Emissions for a two night stay in Fiji.
#' hotel_emissions(location = "Fiji", nights = 2)
hotel_emissions <- function(location = "UK", nights = 1, rooms = 1){
  checkmate::assert_count(nights)
  checkmate::assert_count(rooms)
  
  uk_gov_data_hotel <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Hotel stay") %>%
    dplyr::filter(!is.na(`GHG Conversion Factor 2022`))
  
  row <- which(uk_gov_data_hotel$`Level 3` == location)
  if (length(row) == 0) {
    row <- which(hotel_df$Country == location)
    if (length(row) == 0) {
      hotel_names <- agrep(data.frame(location), uk_gov_data_hotel$`Level 3`, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
      hotel_names_1 <- agrep(data.frame(location), hotel_df$Country, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
      stop("location not recognised. Did you mean: ", paste(hotel_names, hotel_names_1, ", "), ". Consider using 'Average'.")
    } else {
      emissions <- hotel_df$CO2e[row]
    } 
  } else {
    emissions <- uk_gov_data_hotel$`GHG Conversion Factor 2022`[row]
  }
emissions <- emissions * nights * rooms
return(emissions)
}
