#' Calculate carbon price credit
#' 
#' This function calculates the carbon price credit for a given jurisdiction, year, period, and CO2e value.
#' It uses CPI (Carbon Price Index) data to determine the carbon price for the specified jurisdiction and time period.
#' The carbon price credit is calculated by multiplying the CO2e value by the corresponding carbon price.
#' 
#' @param jurisdiction A character string specifying the jurisdiction for which the carbon price credit should be calculated.
#' @param year An optional numeric value specifying the year for which the carbon price credit should be calculated.
#' If `NULL`, the most recent year available in the CPI data will be used.
#' @param period An optional numeric value specifying the period within the specified year for which the carbon price credit should be calculated.
#' If `1`, the function will use the first period if it is available; if `2`, the function will use the second period if it is available. If `0`, the function will calculate the mean between the first and second period.
#' @param co2e_val A numeric value specifying the CO2e (carbon dioxide equivalent) value for which the carbon price credit should be calculated.
#' @return The calculated carbon price credit in USD ($).
#' @export
#'
#' @examples
#' # Calculate carbon price credit for the United Kingdom in the year 2000, period 2, and CO2e value of 100
#' carbon_price_credit("United Kingdom", 2022, 2, 100)

carbon_price_credit <- function(jurisdiction, year = NULL, period = 0, co2e_val){
  our_cpi <- cpi_data %>% dplyr::filter(Jurisdiction == jurisdiction)
  if (!is.null(year)){
    our_cpi <- our_cpi %>% dplyr::filter(Year == year)
    if (nrow(our_cpi) == 0) {
      stop("No data for given year. Try `valid_jurisdictions()` to see valid years. Or give no year argument to get the most recent year.")
    }
  } else {
    our_cpi <- our_cpi %>% filter(Year == max(Year))
    warning(paste0("Year is NULL. Giving most recent year: ", unique(our_cpi$Year)))
  }
  if (nrow(our_cpi) > 1){
    if (period == 0){
      our_cpi <- our_cpi %>% dplyr::summarise(`Price ($)` = mean(`Price ($)`))
    } else {
      our_cpi <- our_cpi %>% dplyr::filter(Period == period)
    }
  } else {
    warning("only one period available for this year, defaulting to that period")
  }
  return(co2e_val * our_cpi$`Price ($)`)
}
