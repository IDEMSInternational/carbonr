# distance calculator function
distance_calc <- function(lat1, lat2, long1, long2) {
  acos(cos(deg2rad(90-lat1)) * cos(deg2rad(90-lat2)) + sin(deg2rad(90-lat1)) * sin(deg2rad(90-lat2)) * cos(deg2rad(long1 - long2))) * 3958.756
}