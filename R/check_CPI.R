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
#' which_jur <- valid_jurisdictions()
#' 
#' which_years <- valid_jurisdictions(jurisdiction = "Switzerland")
#' which_years_and_period <- valid_jurisdictions(jurisdiction = "Switzerland", period = TRUE)
valid_jurisdictions <- function(jurisdiction = NULL, period = FALSE){
  if (is.null(jurisdiction)){
    return(unique(carbon_credits$Jurisdiction))
  } else {
    if (period){
      return(carbon_credits %>% dplyr::filter(Jurisdiction == jurisdiction) %>% dplyr::select(Period, Year))     
    } else {
      return(unique(carbon_credits %>% dplyr::filter(Jurisdiction == jurisdiction) %>% dplyr::pull(Year)))
    }
  }
}
