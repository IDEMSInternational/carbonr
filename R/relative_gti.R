#' Relative GTI Plot
#' 
#' Calculate and plot the relative growth to index (GTI) over time
#'
#' @param data The data frame containing the data.
#' @param time The variable representing the time dimension.
#' @param date_format The date format for the time variable (optional, default: c("%d/%m/%Y")).
#' @param name The variable representing the grouping variable.
#' @param val The variable representing the value.
#' @param gti_by The grouping type for calculating the GTI ("default", "month", "year").
#'
#' @return A ggplot2 object showing the relative GTI (Growth to Index) over time.
#' @export
#'
#' @examples # TODO
relative_gti <- function(data = data, time = time, date_format = c("%d/%m/%Y"), name = theatre,
                         val = emissions, gti_by = c("default", "month", "year")){
  gti_by <- match.arg(gti_by)
  if (!is.null(date_format)) data <- data %>% dplyr::mutate(time = as.Date({{ time }}, format = date_format))
  if (gti_by == "month"){
    data <- data %>%
      dplyr::mutate(time = lubridate::month({{ time }}))
  } else if (gti_by == "year"){
    data <- data %>%
      dplyr::mutate(time = lubridate::year({{ time }}))
  } else {
    data <- data %>%
      dplyr::mutate(time = {{ time }})
  }
  data <- data %>%
    dplyr::group_by({{ name }}, time) %>%
    dplyr::summarise(val = sum( {{ val }})) %>%
    dplyr::mutate(lead_val = dplyr::lag(val, default = val[1])) %>%
    dplyr::mutate(pct_change = (val/lead_val))
  gg_object <- ggplot2::ggplot(data, ggplot2::aes(x = time, y = pct_change, group = {{ name }}, colour = {{ name }})) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars({{ name }})) +
    ggplot2::theme_bw()
return(gg_object)
  
}