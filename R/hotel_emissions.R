# Hotels
"Scope 3 (other indirect) emissions":
# are a consequence of your actions that occur at sources you do not own or control and are not classed as Scope 2 emissions.
# E.g. business travel by means not owned or controlled by your organisation, waste disposal, materials or fuels your organisation purchases.
# Scope 3 emissions can be from activities that are upstream or downstream of your organisation. 
# More information on Scope 3 and other aspects of reporting can be found in the Greenhouse Gas Protocol Corporate Standard.
hotel_emissions <- function(location = "UK", nights = 1, rooms = 1){
  row <- which(hotel_df$Country == location)
  if (length(row) == 0) {
    warning("location not recognised, using 'Average' instead")
    row <- which(hotel_df$Country == "Average")
  }
  emissions <- hotel_df$CO2e[row]
  emissions <- emissions * nights * rooms
  return(emissions)
}