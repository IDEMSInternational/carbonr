% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rail_finder.R
\name{rail_finder}
\alias{rail_finder}
\title{Find the station code for a train station}
\usage{
rail_finder(
  station,
  region,
  county,
  district,
  station_code,
  distance = 0.1,
  ignore.case = FALSE
)
}
\arguments{
\item{station}{Name of train station.}

\item{region}{Region the train station is in. One of \code{c("London", "Scotland", "Wales - Cymru", "North West", "West Midlands", "North East", "East", "South East", "East Midlands", "Yorkshire And The Humber", "South West", NA)}.}

\item{county}{County the train station is in.}

\item{district}{District the train station is in.}

\item{station_code}{Code of the train station.}

\item{distance}{Maximum distance allowed for a match between the name/country/city given, and that of the value in the data set.}

\item{ignore.case}{If \code{FALSE}, the check for is case-sensitive. If \code{TRUE}, case is ignored.}
}
\value{
Data frame containing the station code, station name, region, county, district, latitude, and longitude of a train station in the UK.
}
\description{
Find the name, area, and code of a train station in the UK. For use in the \code{rail_emissions} function.
}
\examples{
# Can get the station code from the station. Gets similar matches.
rail_finder(station = "Bristo")

# Can get the code from the station and city.
rail_finder(station = "Bristo", county = "Bristol")

# Can find the name and district of a train station given the IATA code
rail_finder(station_code = "BRI")
}
