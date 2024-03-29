% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_CPI.R
\name{check_CPI}
\alias{check_CPI}
\title{Check which jurisdictions are in the Carbon Credits data}
\usage{
check_CPI(jurisdiction = NULL, period = FALSE)
}
\arguments{
\item{jurisdiction}{(optional) A character string specifying the jurisdiction to filter the data by.}

\item{period}{(logical) If TRUE, include the Period column in the output data frame.}
}
\value{
A vector or data frame containing the information.
}
\description{
Find jurisdictions available in the Carbon Credits data. If a jurisdiction is specified, find the years associated with that jurisdiction.
}
\examples{
which_jur <- check_CPI()
which_years <- check_CPI(jurisdiction = "Switzerland")
which_years_and_period <- check_CPI(jurisdiction = "Switzerland", period = TRUE)
}
