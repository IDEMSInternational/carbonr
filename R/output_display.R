#' Display a grid of plots and tables
#' 
#' @description Function to display a grid of plots and tables
#'
#' @param data The data frame containing the data.
#' @param time The variable representing the time dimension.
#' @param date_format The date format for the time variable (optional, default: c("%d/%m/%Y")).
#' @param name The variable representing the grouping variable.
#' @param relative_gpi_val The variable representing the relative GPI (Growth to Previous Index) value.
#' @param gti_by The grouping type for calculating the GTI ("default", "month", "year").
#' @param plot_val The variable to plot in the total output plot.
#' @param plot_by The grouping type for the total output plot ("default", "month", "year").
#' @param pdf Whether to export the plots to a PDF file (default: TRUE).
#'
#' @details This function generates a grid of plots and tables showing a value box, data table, relative GPI plot,
#' and total output plot. The function uses other auxiliary functions such as `relative_gti()` and `total_output()`.
#'
#' @import ggpp
#'
#' @return A grid of plots and tables showing the value box, data table, relative GPI plot, and total output plot.
output_display <- function(data = x$data, time = time, date_format = c("%d/%m/%Y"), name = theatre,
                           relative_gpi_val = emissions, gti_by = "default",
                           plot_val = carbon_price_credit, plot_by = "default", pdf = TRUE){
  requireNamespace("ggpp")
  relative_plot <- relative_gti(data = data, time = {{ time }}, date_format = c("%d/%m/%Y"), name = {{ name }},
                                val = {{ relative_gpi_val }}, gti_by = gti_by)
  
  total_plot <- total_output(data = data, time = {{ time }}, date_format = c("%d/%m/%Y"), name = {{ name }},
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
      icons = c("\U0000f06d", "\U0000f155", "\U0000f0f7"),
      color = factor(1:3)
      )

    ggp_table <- ggplot2::ggplot() +
      ggplot2::theme_void() +
      ggplot2::annotate(geom = "table",
                        x = 1,
                        y = 1,
                        label = list(data))
    return(cowplot::plot_grid(value_box, ggp_table, relative_plot, total_plot, nrow = 4, rel_heights = c(1, 3, 3, 3)))
  }else {
    return_all <- NULL
    return_all[[1]] <- data
    return_all[[2]] <- relative_plot
    return_all[[3]] <- total_plot
    return(return_all)
  }
}
