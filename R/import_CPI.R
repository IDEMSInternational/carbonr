#' Import CPI data from an Excel file
#' 
#' This function uses the downloaded data from the World Bank Carbon Pricing Dashboard (https://carbonpricingdashboard.worldbank.org/).
#' It imports data from an Excel file containing CPI (Carbon Price Index) data.
#' It filters the data for ETS (Emissions Trading Scheme) instruments, performs necessary transformations,
#' and returns a processed data frame.
#' 
#' @param path A character string specifying the file path of the Excel file.
#' @param sheet A character string specifying the name of the sheet in the Excel file to read data from.
#' @param skip An integer specifying the number of rows to skip while reading the Excel sheet.
#' @return A processed data frame containing CPI data.
#' @export
#'
#' @examples
#' #cpi_data <- import_CPI()
import_CPI <- function(path = "C:/Users/lclem/Downloads/CPI_Data_DashboardExtract.xlsx", sheet = "Data_Price", skip = 2){
  data <- readxl::read_excel(path, sheet = sheet, skip = skip)
  data <- data %>%
    dplyr::filter(`Instrument Type` == "ETS") %>% 
    dplyr::select(-c(starts_with("Price_label_"), ends_with("Instrument_Type"), `Name of the initiative`, `Instrument Type`))%>%
    tidyr::pivot_longer(cols = tidyselect::starts_with("Price_rate_"), names_to = "Year", values_to = "Price ($)") %>%
    mutate(Year = sub(".*Price_rate_", "", Year))
  year_time <- stringr::str_split(data$Year, "_", simplify = TRUE)
  data <- data %>%
    dplyr::mutate(Period = as.numeric(year_time[,1])) %>%
    dplyr::mutate(Year = as.numeric(year_time[,2])) %>%
    dplyr::select(c(Jurisdiction = `Jurisdiction Covered`, Period, Year, `Price ($)`)) %>%
    dplyr::mutate(`Price ($)` = as.numeric(`Price ($)`)) %>%
    dplyr::group_by(Jurisdiction) %>%
    tidyr::fill(`Price ($)`) %>%
    dplyr::filter(!is.na(`Price ($)`)) %>%
    tidyr::separate_rows(Jurisdiction, sep=", ", convert = TRUE)
  # repeat rows if a comma
  return(data)
}
