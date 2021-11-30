#' Calculate Emissions from a hotel stay
#' 
#' @description Indirect emissions from a stay at a hotel. Values to calculate emissions are from UK government 2021 report.
#'
#' @param location Location of the hotel stay. Current accepted locations are UK, Argentina, Australia, Austria, Belgium, Brazil, Canada, Chile, China, Columbia, Costa Rica, Czechia, Egypt, Fiji, France, Germany, Greece, Hong Kong, India, Indonesia, Ireland, Israel, Italy, Japan, Jordan, Korea, Macau, Malaysia, Maldives, Mexico, Netherlands, New Zealand, Panama, Peru, Philippines, Poland, Portugal, Qatar, Romania, Russia, Saudi Arabia, Singapore, Slovakia, South Africa, Spain, Switzerland, Taiwan, Thailand, Turkey, United Arab Emirates, United States, Vietnam, Average.
#' @param nights Number of nights stayed in the hotel.
#' @param rooms Number of rooms used in the hotel.
#'
#' @return Tonnes of CO2 emissions for a stay in a hotel.
#' @export
#'
#' @examples # Emissions for a two night stay in Fiji.
#' hotel_emissions(location = "Fiji", nights = 2)
hotel_emissions <- function(location = "UK", nights = 1, rooms = 1){
  if (!is.numeric(nights) || nights %% 1 != 0 || nights < 0){
    stop("`nights` should be a postive integer")
  }
  if (!is.numeric(rooms) || rooms %% 1 != 0 || rooms < 0){
    stop("`rooms` should be a postive integer")
  }
  row <- which(hotel_df$Country == location)
  if (length(row) == 0) {
    hotel_names <- agrep(data.frame(location), hotel_df$Country, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
    stop("location not recognised. Did you mean: ", print(hotel_names), ". Consider using 'Average'.")
    # row <- which(hotel_df$Country == "Average")
  }
  emissions <- hotel_df$CO2e[row]
  emissions <- emissions * nights * rooms
  return(emissions)
}
