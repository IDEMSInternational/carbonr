#' Find the airport code for an airport
#'
#' @param name Name of the airport
#' @param city City the airport is in 
#' @param IATA_code The IATA code
#' @param ICAO_code The ICAO code
#'
#' @return 
#' @export
#'
#' @examples # TODO
airport_finder <- function(name, city, IATA_code, ICAO_code){
  
  airport_filter <- airportr::airports %>% dplyr::select(c(Name, City, IATA))
  
  if (!missing(name)){
    airport_names <- agrep(data.frame(name), airport_filter$Name, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
    
    airport_filter %>% dplyr::filter(Name %in% airport_names)
  }
}
