# distance calculator function
distance_calc <- function(lat1, lat2, long1, long2) {
  acos(cos(degree_conversion(90-lat1)) * cos(degree_conversion(90-lat2)) + sin(degree_conversion(90-lat1)) * sin(degree_conversion(90-lat2)) * cos(degree_conversion(long1 - long2))) * 3958.756
}