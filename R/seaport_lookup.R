#' Check the code or name of a seaport
#' @description Given a country and/or city, find the name and/or code of a seaport for use in the `ferry_emissions` function.
#'
#' @param country Name of the country.
#' @param city Name of the city.
#' @param distance Maximum distance allowed for a match between the country/city given, and that of the value in the data set.
#' @param ignore.case If `FALSE`, the check for city/country is case-sensitive. If `TRUE`, case is ignored.
#'
#' @return Data frame containing the country, city, country code, port code, latitude, and longitude.
#' @export
#'
#' @examples # Look up the city of Aberdeen to find the port_code for it
#' seaport_lookup(city = "Aberdeen")
#' # Search for a country and city and it finds matches
#' seaport_lookup(country = "United", city = "borunemouth", ignore.case = TRUE)

seaport_lookup <- function(country = NULL, city = NULL, distance = 0.1, ignore.case = FALSE){
  data("seaports", envir = environment())
  if (!is.numeric(distance)| distance < 0){
    stop("`distance` must be a positive number")
  }
  if (!is.logical(ignore.case)){
    stop("`ignore.case` can only take values TRUE or FALSE")
  }
  if (!is.null(country) & !is.null(city)){
    name_check1 <- agrep(data.frame(country), seaports$country, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(seaports) %>% dplyr::filter(country %in% name_check1)
    name_check2 <- agrep(data.frame(city), df$city, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(df) %>% dplyr::filter(city %in% name_check2)
  } else if(!is.null(city)){
    name_check <- agrep(data.frame(city), seaports$city, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(seaports) %>% dplyr::filter(city %in% name_check)
  } else if(!is.null(country)){
    name_check <- agrep(data.frame(country), seaports$country, ignore.case = ignore.case, max.distance = distance, value = TRUE)
    df <- data.frame(seaports) %>% dplyr::filter(country %in% name_check)
  } else if(is.null(city) & is.null(country)){
    stop("One of country or city must be supplied")
  }
  return(df)
}


