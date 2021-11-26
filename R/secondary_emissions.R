#' Secondary 
#' source: carbonfootprint.com for these. They use DEFRA 2017 Supply Chain Factors
#' Emissions caused through the manufacture, delivery, and disposal of products and services we buy

secondary_emissions <- function(item, cost, number_bought = 1, diet = "medium meat"){
  
  item_list <- c("IT equipment", "restaurants", "TV", "radio", "phone", "paper based products", "motor", "manufactured goods", "telephone/mobile call costs",
                 "banking/finance", "insurance", "education", "recreational activities", "textiles")
  # cost list is cost per £1 spent
  # cost in pounds
  CO2e <- c(0.00114, 0.00037, 0.00114, 0.00114, 0.00114, 0.00027, 0.00030, 0.00031, 0.00024, 0.00039, 0.00018, 0.00025, 0.00032, 0.00040)
  df_list <- data.frame(item_list, CO2e)
  
  if (item == "food"){
    # high = >100g/day, med = 50-100g/day, low = <50g/day
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
    
    #TODO - ask meat consumption, or veggie etc.
  } else {
    row <- which(df_list$item_list == item)
    emissions <- df_list$CO2e[row]
  }
  
  emissions <- emissions * cost * number_bought
  return(emissions)
}
