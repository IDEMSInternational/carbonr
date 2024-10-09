#' Calculate Total Output and Generate Plot
#'
#' This function calculates the total output and generates a plot based on the specified parameters.
#'
#' @param data The data frame containing the data.
#' @param time The variable representing the time dimension.
#' @param date_format The date format for the time variable (optional, default: c("%d/%m/%Y")).
#' @param name The variable representing the grouping variable.
#' @param val The variable to calculate the total output for (default: carbon_price_credit).
#' @param plot_by The grouping type for the total output plot ("default", "month", "year").
#'
#' @return A ggplot object showing the total output plot.
#'
#' @details This function calculates the total output by grouping the data based on the specified parameters
#' (grouping variable and time dimension). It then summarises the specified variable (CPI or emissions) using the sum function.
#' The resulting data is used to create a line plot showing the total output over time, with each group represented
#' by a different color. The plot can be grouped by the default grouping, month, or year, based on the plot_by parameter.
total_output <- function(data = x$data, time = time, date_format = c("%d/%m/%Y"), name = theatre,
                        val = carbon_price_credit, plot_by = c("default", "month", "year")){
  plot_by <- match.arg(plot_by)
  if (!is.null(date_format)) data <- data %>% dplyr::mutate(time = as.Date({{ time }}, format = date_format))
  if (plot_by == "month"){
    data <- data %>%
      dplyr::mutate(time = lubridate::month({{ time }}))
  } else if (plot_by == "year"){
    data <- data %>%
      dplyr::mutate(time = lubridate::year({{ time }}))
  } else {
    data <- data %>%
      dplyr::mutate(time = {{ time }})
  }
  data <- data %>%
    dplyr::group_by({{ name }}, time) %>%
    dplyr::summarise(val = sum( {{ val }}))
  gg_object <- ggplot2::ggplot(data, ggplot2::aes(x = {{ time }}, y = val,
                                                  group = {{ name }}, colour = {{ name }})) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars({{ name }})) +
    ggplot2::theme_bw()
  return(gg_object)
}