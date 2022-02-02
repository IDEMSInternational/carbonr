#' Distance calculator
#' 
#' @description Calculate distances between locations in miles using the Haversine formula. This is calculated as the crow flies.
#'
#' @param lat1 Latitude of the first location.
#' @param lat2 Latitude of the second location.
#' @param long1 Longitude of the first location.
#' @param long2 Longitude of the second location.
#'
#' @return Distance between locations in miles
#' @export
#'
#' @examples # Distance between the London Eye and the Eiffel Tower in miles
#' distance_calc(51.5033, 48.8584, 0.1196, 2.2945)
distance_calc <- function(lat1, lat2, long1, long2) {
  checkmate::assert_numeric(lat1)
  checkmate::assert_numeric(lat2)
  checkmate::assert_numeric(long1)
  checkmate::assert_numeric(long2)
  acos(cos(degree_conversion(90-lat1)) * cos(degree_conversion(90-lat2)) + sin(degree_conversion(90-lat1)) * sin(degree_conversion(90-lat2)) * cos(degree_conversion(long1 - long2))) * 3958.756
}
