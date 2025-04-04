#' Find the airport code for an airport
#' @description Find the name, city, country, and IATA code of an airport. For use in the `airplane_emissions` function.
#' @param name Name of the airport.
#' @param city City that the airport is in.
#' @param country Country that the airport is in.
#' @param IATA_code The IATA code.
#' @param distance Maximum distance allowed for a match between the name/country/city given, and that of the value in the data set.
#' @param ignore.case If `FALSE`, the check for is case-sensitive. If `TRUE`, case is ignored.
#' 
#' @return Data frame containing the name, city, country, and IATA code of an airport.
#' @export
#'
#' @examples # Can get the IATA code from the name of an airport. Gets similar matches.
#' airport_finder(name = "Bristo")
#' 
#' # Can get the IATA code from the name and city of an airport
#' airport_finder(name = "Bristo", country = "United Kingdom")
#' 
#' # Can find the name and city of an airport given the IATA code
#' airport_finder(IATA_code = "BRS")
airport_finder <- function(name, city, country, IATA_code, distance = 0.1, ignore.case = FALSE){
  if (!missing(name)){ checkmate::assert_string(name) }
  if (!missing(city)){ checkmate::assert_string(city) }
  if (!missing(country)){ checkmate::assert_string(country) }
  if (!missing(IATA_code)){ checkmate::assert_string(IATA_code) }
  checkmate::assert_numeric(distance, lower = 0)
  checkmate::assert_logical(ignore.case)
  airport_filter <- airportr::airports %>% dplyr::select(c(Name, City, Country, IATA))

  if (!missing(name)){
    airport_names <- agrep(data.frame(name), airport_filter$Name, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    airport_filter <- airport_filter %>% dplyr::filter(Name %in% airport_names)
  }
  if (!missing(city)){
    airport_city <- agrep(data.frame(city), airport_filter$City, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    airport_filter <- airport_filter %>% dplyr::filter(City %in% airport_city)
  }
  if (!missing(country)){
    airport_country <- agrep(data.frame(country), airport_filter$Country, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    airport_filter <- airport_filter %>% dplyr::filter(Country %in% airport_country)
  }
  if(!missing(IATA_code)){
    airport_IATA <- agrep(data.frame(IATA_code), airport_filter$IATA, ignore.case = ignore.case, max.distance = 0, value = TRUE)
    airport_filter <- airport_filter %>% dplyr::filter(IATA %in% airport_IATA)
  }
  return(airport_filter)
}