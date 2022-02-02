#' Convert degrees to radians
#'
#' @description Convert degrees to radians.
#'
#' @param deg Degree value to convert.
#'
#' @return Value in radians.
#' @export
#'
#' @examples # Convert 90 degrees into radians
#' degree_conversion(90)
degree_conversion <- function(deg) {
  checkmate::check_numeric(deg)
  (deg * pi) / (180)
}
