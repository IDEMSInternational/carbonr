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
#' @param manual_price An option to manually input a carbon price index instead of using the World Bank Data. This value is used if not `NULL`, even if jurisdiction is inputted.
#' This should be a value of the carbon credit price per tCO2e.
#' @param co2e_val A numeric value specifying the CO2e (carbon dioxide equivalent) value for which the carbon price credit should be calculated.
#' @return The calculated carbon price credit in USD ($).
#' @export
#'
#' @examples
#' # Calculate carbon price credit for the United Kingdom in the year 2000, period 2, and CO2e value of 100
#' carbon_price_credit("United Kingdom", 2022, 2, 100)
#' 
#' # Or manually enter a value
#' carbon_price_credit(manual_price = 66.9, co2e_val = 100)
carbon_price_credit <- function(jurisdiction = NULL, year = NULL, period = 0, manual_price = NULL, co2e_val){
  if (!is.null(manual_price)){
    if (!is.null(jurisdiction)) warning("Both jurisdiction and manual_price are given. Using the value in manual_price")
    return(co2e_val * manual_price)
  } else if (is.null(jurisdiction)) {
    stop("One of jurisdiction or manual_price need to be provided")
  } else {
    our_cpi <- cpi_data %>% dplyr::filter(Jurisdiction == jurisdiction)
    if (!is.null(year)){
      our_cpi <- our_cpi %>% dplyr::filter(Year == year)
      if (nrow(our_cpi) == 0) {
        stop("No data for given year. Try `check_CPI()` to see valid years. Or give no year argument to get the most recent year.")
      }
    } else {
      our_cpi <- our_cpi %>% dplyr::filter(Year == max(Year))
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
}
