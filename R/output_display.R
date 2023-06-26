#' Display a grid of plots and tables
#'
#' @description This function generates a grid of plots and tables, including a value box, data table, relative GPI plot, and total output plot.
#'
#' @param data The data frame containing the data.
#' @param time The variable representing the time dimension.
#' @param date_format The date format for the time variable (optional, default: "%d/%m/%Y").
#' @param name The variable representing the grouping variable.
#' @param relative_gpi_val The variable representing the relative GPI (Growth to Previous Index) value.
#' @param gti_by The grouping type for calculating the GTI ("default", "month", "year").
#' @param plot_val The variable to plot in the total output plot.
#' @param plot_by The grouping type for the total output plot ("default", "month", "year").
#' @param pdf Whether to export the plots to a PDF file (default: TRUE).
#'
#' @details The function utilises other auxiliary functions such as relative_gti() and total_output().
#'
#' @return A grid of plots and tables showing the value box, data table, relative GPI plot, and total output plot.
output_display <- function(data = x$data, time = time, date_format = c("%d/%m/%Y"), name = theatre,
                           relative_gpi_val = emissions, gti_by = c("default", "month", "year"),
                           plot_val = carbon_price_credit, plot_by = "default", pdf = TRUE){
  requireNamespace("ggpp")
  gti_by <- match.arg(gti_by)
  relative_plot <- relative_gti(data = data, time = {{ time }}, date_format = date_format, name = {{ name }},
                                val = {{ relative_gpi_val }}, gti_by = gti_by)
  
  total_plot <- total_output(data = data, time = {{ time }}, date_format = date_format, name = {{ name }},
                             val = {{ plot_val }}, plot_by = plot_by)
  #if (plot_val == carbon_price_credit) total_plot <- total_plot + ggplot2::labs(y = "CPI ($)", x = "Date")
  
  
  if (pdf){
    value_box <- gg_value_box(
      values = c(round(sum(data$emissions), 2),
                 paste0("$", round(sum(data$carbon_price_credit), 2)),
                 length(unique(data %>% dplyr::pull({{ name }})))),
      information = c("estimated tCO2e",
                      "carbon price index",
                      "operating theatres"),
      icons = c("\U0000f06d", "\U0000f155", "\U0000f0f7")
    )
    if (!is.null(date_format)) data <- data %>% dplyr::mutate(time = as.Date({{ time }}, format = date_format))
    if (gti_by == "month"){
      data <- data %>% dplyr::mutate(time = lubridate::month({{ time }}))
    } else if (gti_by == "year"){
      data <- data %>% dplyr::mutate(time = lubridate::year({{ time }}))
    } else {
      data <- data %>% dplyr::mutate(time = {{ time }})
    }
    data <- data %>% dplyr::group_by({{ name }}, time) %>%
      dplyr::summarise(total_emissions = round(sum(emissions), 2),
                       total_carbon_price = paste0("$", round(sum(carbon_price_credit)), 2))
    ggp_table <- ggplot2::ggplot() +
      ggplot2::theme_void() +
      ggpp::geom_table(
        data = data,
        ggplot2::aes(x = 1, y = 1, label = list(data))
      )
    return(cowplot::plot_grid(value_box, ggp_table, relative_plot, total_plot, nrow = 4, rel_heights = c(1, 3, 3, 3)))
  }else {
    return_all <- NULL
    return_all[[1]] <- relative_plot
    return_all[[2]] <- total_plot
    return(return_all)
  }
}
