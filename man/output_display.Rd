% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/output_display.R
\name{output_display}
\alias{output_display}
\title{Display a grid of plots and tables}
\usage{
output_display(
  data = x$data,
  time = time,
  date_format = c("\%d/\%m/\%Y"),
  name = theatre,
  relative_gpi_val = emissions,
  gti_by = c("default", "month", "year"),
  plot_val = carbon_price_credit,
  plot_by = "default",
  pdf = TRUE
)
}
\arguments{
\item{data}{The data frame containing the data.}

\item{time}{The variable representing the time dimension.}

\item{date_format}{The date format for the time variable (optional, default: "\%d/\%m/\%Y").}

\item{name}{The variable representing the grouping variable.}

\item{relative_gpi_val}{The variable representing the relative GPI (Growth to Previous Index) value.}

\item{gti_by}{The grouping type for calculating the GTI ("default", "month", "year").}

\item{plot_val}{The variable to plot in the total output plot.}

\item{plot_by}{The grouping type for the total output plot ("default", "month", "year").}

\item{pdf}{Whether to export the plots to a PDF file (default: TRUE).}
}
\value{
A grid of plots and tables showing the value box, data table, relative GPI plot, and total output plot.
}
\description{
This function generates a grid of plots and tables, including a value box, data table, relative GPI plot, and total output plot.
}
\details{
The function utilises other auxiliary functions such as relative_gti() and total_output().
}
