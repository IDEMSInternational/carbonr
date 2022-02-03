#' Check the code or name of a seaport
#' @description Given a country and/or city, find the name and/or code of a seaport for use in the `ferry_emissions` function.
#'
#' @param country Name of the country.
#' @param city Name of the city.
#' @param port_code Name of the port.
#' @param distance Maximum distance allowed for a match between the country/city given, and that of the value in the data set.
#' @param ignore.case If `FALSE`, the check is case-sensitive. If `TRUE`, case is ignored.
#'
#' @return Data frame containing the country, city, country code, port code, latitude, and longitude.
#' @export
#'
#' @examples # Look up the city of Aberdeen to find the port_code for it
#' seaport_finder(city = "Aberdeen")
#' # Search for a country and city and it finds matches
#' seaport_finder(country = "United", city = "borunemouth", ignore.case = TRUE)

seaport_finder <- function(city, country, port_code, distance = 0.1, ignore.case = FALSE){
  if (!missing(city)){ checkmate::assert_string(city) }
  if (!missing(country)){ checkmate::assert_string(country) }
  if (!missing(port_code)){ checkmate::assert_string(port_code) }
  checkmate::assert_numeric(distance, lower = 0)
  checkmate::assert_logical(ignore.case)
  data("seaports", envir = environment())
  
  seaport_filter <- seaports
  
  if (!missing(city)){
    seaport_city <- agrep(data.frame(city), seaports$city, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    seaport_filter <- seaport_filter %>% dplyr::filter(city %in% seaport_city)
  }
  if (!missing(country)){
    seaport_country <- agrep(data.frame(country), seaports$country, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    seaport_filter <- seaport_filter %>% dplyr::filter(country %in% seaport_country)
  }
  if(!missing(port_code)){
    seaport_pc <- agrep(data.frame(port_code), seaport_filter$port_code, ignore.case = ignore.case, max.distance = 0, value = TRUE)
    seaport_filter <- seaport_filter %>% dplyr::filter(port_code %in% seaport_pc)
  }
  
  return(seaport_filter)
}


