#' Dataset of UK train stations
#'
#' A dataset containing the city, station code, and coordinates of seaports
#'
#' @usage data(stations)
#' @format A data frame with 2608 rows and 4 variables:
#' \describe{
#'   \item{station}{Name of the station}
#'   \item{station_code}{Code of the station}
#'   \item{region}{Region of the station. One of \code{"London", "Scotland", "Wales - Cymru", "North West", "West Midlands", "North East", "East", "South East", "East Midlands", "Yorkshire And The Humber", "South West", NA}}
#'   \item{county}{County of the station}
#'   \item{district}{District of the station}
#'   \item{latitude}{Latitude of the station}
#'   \item{longitude}{Longitude of the station}
#' }
#' @source \url{https://data.gov.uk/dataset/ff93ffc1-6656-47d8-9155-85ea0b8f2251/national-public-transport-access-nodes-naptan}
#' @source \url{https://www.theguardian.com/news/datablog/2011/may/19/train-stations-listed-rail#data}
"stations"