#' Calculate CO2e emissions from secondary sources
#' 
#' @description CO2e emissions from the manufacture, delivery, and disposal of products and services in a year. Emission values are calculated from carbonfootprint.com, which base the emissions values off DEFRA 2017 Supply Chain Factors.
#'
#' @param item Item bought. Valid options are: `"IT equipment"`, `"restaurants"`, `"TV"`, `"radio"`, `"phone"`, `"paper based products"`, `"motor"`, `"manufactured goods"`, `"telephone/mobile call costs"`, `"banking/finance"`, `"insurance"`, `"education"`, `"recreational activities"`, `"textiles"`, `"food"`.
#' @param cost Amount spent on that item (in pounds)
#' @param time Time frame where the purchases took place. Options are `"per week"`, `"per month"`, `"per year"`.
#' @param diet Only if `item = "food"`. General diet of an individual. Options are `"high meat"`, `"medium meat"`, `"low meat"`, `"pescatarian"`, `"vegetarian"`, and `"vegan"`. 
#' `"high meat"` suggests more than 100g of meat is consumed a day; `"medium meat"` for 50-100g/day; `"low meat"` for <50g/day.
#'
#' @return Tonnes of CO2 emissions from secondary sources in a year.
#' @export
#'
#' @examples # Emissions for a new £1000 computer. 
#' secondary_emissions(item = "IT equipment", cost = 1000)
#' @examples # Emissions for a high meat eater who spends £200 on food each month. 
#' secondary_emissions(item = "food", cost = 200, time = "per month")

secondary_emissions <- function(item, cost, time = "per year", diet = "medium meat"){
  item_list <- c("IT equipment", "restaurants", "TV", "radio", "phone", "paper based products", "motor", "manufactured goods", "telephone/mobile call costs",
                 "banking/finance", "insurance", "education", "recreational activities", "textiles")
  if (!item %in% c(item_list, "food")){
    stop("`item` must be one of", paste0(item_list, sep = ", "), "food.")
  }
  if (!diet %in% c("high meat", "medium meat", "low meat", "pescatarian", "vegetarian", "vegan")){
    stop("`diet` must be one of high meat, medium meat, low meat, pescatarian, vegetarian, or vegan.")
  }
  if (!time %in% c("per week", "per month", "per year")){
    stop("`time` must be one of per week, per month, per year.")
  }
  if (!is.numeric(cost)){
    stop("`cost` should be a numeric value.")
  }
  
  # cost list is cost per £1 spent
  CO2e <- c(0.00114, 0.00037, 0.00114, 0.00114, 0.00114, 0.00027, 0.00030, 0.00031, 0.00024, 0.00039, 0.00018, 0.00025, 0.00032, 0.00040)
  df_list <- data.frame(item_list, CO2e)
  
  if (item == "food"){
    if (diet == "high meat"){
      emissions <- 0.00088
    } else if (diet == "medium meat"){
      emissions <- 0.00069
    } else if (diet == "low meat"){
      emissions <- 0.00057
    } else if (diet == "pescatarian"){
      emissions <- 0.00048
    } else if (diet == "vegetarian"){
      emissions <- 0.00047
    } else if (diet == "vegan"){
      emissions <- 0.00035
    }
  } else {
    row <- which(df_list$item_list == item)
    emissions <- df_list$CO2e[row]
  }
  if (time == "per year"){
    time_factor <- 1
  } else if (time == "per month") {
    time_factor <- 12
  } else if (time == "per week") {
    time_factor <- 52
  }
  emissions <- emissions * cost * time_factor
  return(emissions)
}
