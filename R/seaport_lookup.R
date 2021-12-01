#' Check the Code or Name of a Seaport
#'
#' @param country_name Name of the country.
#' @param city Name of the city.
#' @param distance Maximum distance allowed for a match between the country/city given, and that of the value in the data set.
#' @param ignore.case If `FALSE`, the check for city/country is case-sensitive. If `TRUE`, case is ignored.
#'
#' @return Data frame containing the latitude, longitude, country name, country code, port code, and city name.
#' @export
#'
#' @examples # Look up the city of Aberdeen to find the port_code for it
#' seaport_lookup(city = "Aberdeen")
#' # Search for a country and city and it finds matches
#' seaport_lookup(country_name = "United", city = "borunemouth", ignore.case = TRUE)

seaport_lookup <- function(country_name = NULL, city = NULL, distance = 0.1, ignore.case = FALSE){
  if (!is.numeric(distance)| distance < 0){
    stop("`distance` must be a positive number")
  }
  if (!is.logical(ignore.case)){
    stop("`ignore.case` can only take values TRUE or FALSE")
  }
  if (!is.null(country_name) & !is.null(city)){
    name_check1 <- agrep(data.frame(country_name), seaport_data$country_name, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(seaport_data) %>% dplyr::filter(country_name %in% name_check1)
    name_check2 <- agrep(data.frame(city), df$city, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(df) %>% dplyr::filter(city %in% name_check2)
  } else if(!is.null(city)){
    name_check <- agrep(data.frame(city), seaport_data$city, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(seaport_data) %>% dplyr::filter(city %in% name_check)
  } else if(!is.null(country_name)){
    name_check <- agrep(data.frame(country_name), seaport_data$country_name, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(seaport_data) %>% dplyr::filter(country_name %in% name_check)
  } else if(is.null(city) & is.null(country_name)){
    stop("One of country_name or city must be supplied")
  }
  return(df)
}


