#' Find the station code for a train station
#'
#' @param station Name of train station.
#' @param region Region the train station is in. One of \code{c("London", "Scotland", "Wales - Cymru", "North West", "West Midlands", "North East", "East", "South East", "East Midlands", "Yorkshire And The Humber", "South West", NA)}.
#' @param county County the train station is in.
#' @param district District the train station is in.
#' @param station_code Code of the train station.
#' @param distance Maximum distance allowed for a match between the name/country/city given, and that of the value in the data set.
#' @param ignore.case If `FALSE`, the check for is case-sensitive. If `TRUE`, case is ignored.
#'
#' @return 
#' @export
#'
#' @examples
#' # Can get the station code from the station. Gets similar matches.
#' rail_finder(station = "Bristo")
#' 
#' # Can get the code from the station and city.
#' rail_finder(station = "Bristo", county = "Bristol")
#' 
#' # Can find the name and district of a train station given the IATA code
#' rail_finder(station_code = "BRI")
rail_finder <- function(station, region, county, district, station_code, distance = 0.1, ignore.case = FALSE){
  if (!missing(station)){ checkmate::assert_string(station) }
  if (!missing(region)){ checkmate::assert_string(region) }
  if (!missing(county)){ checkmate::assert_string(county) }
  if (!missing(district)){ checkmate::assert_string(district) }
  if (!missing(station_code)){ checkmate::assert_string(station_code) }
  checkmate::assert_numeric(distance, lower = 0)
  checkmate::assert_logical(ignore.case)
  data("stations", envir = environment())
  
  rail_filter <- stations
  
  if (!missing(station)){
    rail_station <- agrep(data.frame(station), rail_filter$station, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    rail_filter <- rail_filter %>% dplyr::filter(station %in% rail_station)
  }
  if (!missing(region)){
    rail_region <- agrep(data.frame(region), rail_filter$region, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    rail_filter <- rail_filter %>% dplyr::filter(region %in% rail_region)
  }
  if (!missing(county)){
    rail_county <- agrep(data.frame(county), rail_filter$county, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    rail_filter <- rail_filter %>% dplyr::filter(county %in% rail_county)
  }
  if (!missing(district)){
    rail_district <- agrep(data.frame(district), rail_filter$district, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    rail_filter <- rail_filter %>% dplyr::filter(district %in% rail_district)
  }
  if(!missing(station_code)){
    rail_code <- agrep(data.frame(station_code), rail_filter$station_code, ignore.case = ignore.case, max.distance = 0, value = TRUE)
    rail_filter <- rail_filter %>% dplyr::filter(station_code %in% rail_code)
  }
  
  return(rail_filter)
}