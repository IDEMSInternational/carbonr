#' Title
#'
#' @param name 
#' @param city 
#' @param IATA_code 
#' @param ICAO_code 
#'
#' @return
#' @export
#'
#' @examples
airport_finder <- function(name, city, IATA_code, ICAO_code){
  
  airport_filter <- airportr::airports %>% dplyr::select(c(Name, City, IATA))
  
  if (!missing(name)){
    airport_names <- agrep(data.frame(name), airport_filter$Name, ignore.case = TRUE, max.distance = 0.1, value = TRUE)
    
    airport_filter %>% dplyr::filter(Name %in% airport_names)
  }
}