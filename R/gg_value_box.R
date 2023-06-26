#' Create a Value Box for Reports
#' 
#' This function creates a value box for use in reports.
#' 
#' @param values A vector of numeric values to be displayed in the value box.
#' @param information A vector of strings providing information or labels for the values.
#' @param icons A vector of Font Awesome unicode symbols to be displayed as icons.
#' @param color A factor variable specifying the color scheme for the value box.
#' 
#' @return A `ggplot2` object with a value box for report use.
#'
#' @details This function creates a value box with customisable values, information, and icons.
#' The function takes inputs for the values, information, icons, and color of the value box.
#' The values and information are provided as vectors, while the icons are specified using
#' Font Awesome unicode symbols. The color of the value box can be customized using a factor
#' variable. The resulting value box is a `ggplot2` object that can be further customized or
#' combined with other plots or elements in a report.
#'
#' @examples
#' # Create a value box with custom values and icons
#' #gg_value_box(
#' #  values = c(100, 500, 1000),
#'#   information = c("Sales", "Revenue", "Customers"),
#'#   icons = c("\U0000f155", "\U0000f155", "\U0000f0f7"),
#'#   color = factor(1:3)
#'# )
#'
# @seealso [ggplot2::geom_tile()], [ggplot2::geom_text()], [ggplot2::geom_label()], [ggplot2::theme_void()]
#'
#' @references Modified from Stack Overflow post: https://stackoverflow.com/questions/47105282/valuebox-like-function-for-static-reports

gg_value_box <- function(values, information, icons, color){
 df <- data.frame(
    x = c(0, 10, 20),
    y = c(rep(6.5, 3)),
    h = rep(4.25, 3),
    w = rep(8, 3),
    value = values,
    info = information,
    icon = icons,
    font_family = rep("fontawesome-webfont", length(icons)),
    color = color
  )
  
  ggplot2::ggplot(df, ggplot2::aes(x, y, height = h, width = w, label = info)) +
    ggplot2::geom_tile(ggplot2::aes(fill = color)) +
    ggplot2::geom_text(
      color = "white", fontface = "bold", size = 10,
      ggplot2::aes(label = value, x = x - 2.9, y = y + 1), hjust = 0
    ) +
    ggplot2::geom_text(
      color = "white", fontface = "bold",
      ggplot2::aes(label = info, x = x - 2.9, y = y - 1), hjust = 0
    ) +
    ggplot2::coord_fixed() +
    ggplot2::scale_fill_brewer(type = "qual", palette = "Dark2") +
    ggplot2::geom_text(
      size = 20, ggplot2::aes(label = icon, family = font_family,
                              x = x + 1.5, y = y + 0.5), alpha = 0.25
    ) +
    ggplot2::theme_void() +
    ggplot2::guides(fill = FALSE)
}
