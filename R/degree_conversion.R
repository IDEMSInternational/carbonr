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
  if (!is.numeric(deg)){
    stop("`deg` should be a numeric value only.")
  }
  (deg * pi) / (180)
}
