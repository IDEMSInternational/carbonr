#' Check which jurisdictions are in the Carbon Credits data
#' 
#' Find jurisdictions available in the Carbon Credits data. If a jurisdiction is specified, find the years associated with that jurisdiction.
#' 
#' @param jurisdiction (optional) A character string specifying the jurisdiction to filter the data by.
#' @param period (logical) If TRUE, include the Period column in the output data frame.
#' @return A vector or data frame containing the information.
#' @export
#'
#' @examples
#' which_jur <- check_CPI()
#' which_years <- check_CPI(jurisdiction = "Switzerland")
#' which_years_and_period <- check_CPI(jurisdiction = "Switzerland", period = TRUE)
check_CPI <- function(jurisdiction = NULL, period = FALSE){
  if (is.null(jurisdiction)){
    return(unique(cpi_data$Jurisdiction))
  } else {
    if (period){
      return(cpi_data %>% dplyr::filter(Jurisdiction == jurisdiction) %>% dplyr::select(Period, Year))     
    } else {
      return(unique(cpi_data %>% dplyr::filter(Jurisdiction == jurisdiction) %>% dplyr::pull(Year)))
    }
  }
}
