% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/airport_finder.R
\name{airport_finder}
\alias{airport_finder}
\title{Find the airport code for an airport}
\usage{
airport_finder(
  name,
  city,
  country,
  IATA_code,
  distance = 0.1,
  ignore.case = FALSE
)
}
\arguments{
\item{name}{Name of the airport.}

\item{city}{City that the airport is in.}

\item{country}{Country that the airport is in.}

\item{IATA_code}{The IATA code.}

\item{distance}{Maximum distance allowed for a match between the name/country/city given, and that of the value in the data set.}

\item{ignore.case}{If \code{FALSE}, the check for is case-sensitive. If \code{TRUE}, case is ignored.}
}
\value{
Data frame containing the name, city, country, and IATA code of an airport.
}
\description{
Find the name, city, country, and IATA code of an airport. For use in the \code{airplane_emissions} function.
}
\examples{
# Can get the IATA code from the name of an airport. Gets similar matches.
airport_finder(name = "Bristo")

# Can get the IATA code from the name and city of an airport
airport_finder(name = "Bristo", country = "United Kingdom")

# Can find the name and city of an airport given the IATA code
airport_finder(IATA_code = "BRS")
}
