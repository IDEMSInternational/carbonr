#' Table of airport detail data
#'
#' This dataset is adapted from the `airportr` package. Full credit and acknowledgment go to the original authors of the `airportr` package for their contribution.
#' A dataset containing names, codes, locations, altitude, and timezones for airports.
#'
#' @format A data frame with 7698 rows and 14 variables:
#' \describe{
#'   \item{OpenFlights ID}{OpenFlights database ID}
#'   \item{Name}{Airport name, sometimes contains name of the city}
#'   \item{City}{Name of the city served by the airport}
#'   \item{IATA}{3-letter IATA code}
#'   \item{ICAO}{4-letter ICAO code}
#'   \item{Country}{Country name as in OpenFlights database. Note that country names may not be ISO 3166-1 standard.}
#'   \item{Country Code}{ISO 3166-1 numeric country code}
#'   \item{Country Code (Alpha-2)}{Two-letter ISO country code}
#'   \item{Country Code (Alpha-3)}{Three-letter ISO country code}
#'   \item{Latitude}{Latitude in decimal degrees}
#'   \item{Longitude}{Longitude in decimal degrees}
#'   \item{Altitude}{Altitude in feet}
#'   \item{UTC}{Hours offset from UTC}
#'   \item{DST}{Daylight Savings Time. One of E (Europe), A (US/Canada), S (South America), O
#'   (Australia), Z (New Zealand), N (None) or U (Unknown)}
#'   \item{Timezone}{Timezone in Olson format}
#'   \item{Type}{Type of airport (e.g., large airport, medium airport, small airport)}
#'   \item{Source}{Source of data, generally sourced from OurAirports}
#' }
#' @source \url{https://cran.r-project.org/package=airportr}
"airports"