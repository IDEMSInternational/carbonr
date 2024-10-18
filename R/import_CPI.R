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
import_CPI <- function(path, sheet = "Data_Price", skip = 2){
  data <- readxl::read_excel(path, sheet = sheet, skip = skip)
  data <- data %>%
    dplyr::filter(.data$`Instrument Type` == "ETS") %>% 
    dplyr::select(-c(tidyr::starts_with("Price_label_"), tidyr::ends_with("Instrument_Type"), .data$`Name of the initiative`, .data$`Instrument Type`)) %>%
    tidyr::pivot_longer(cols = tidyselect::starts_with("Price_rate_"), names_to = "Year", values_to = "Price ($)") %>%
    dplyr::mutate(Year = sub(".*Price_rate_", "", .data$Year))
  
  year_time <- stringr::str_split(data$Year, "_", simplify = TRUE)
  
  data <- data %>%
    dplyr::mutate(Period = as.numeric(year_time[,1])) %>%
    dplyr::mutate(Year = as.numeric(year_time[,2])) %>%
    dplyr::select(c(Jurisdiction = .data$`Jurisdiction Covered`, .data$Period, .data$Year, `Price ($)`)) %>%
    dplyr::mutate(`Price ($)` = as.numeric(.data$`Price ($)`)) %>%
    dplyr::group_by(.data$Jurisdiction) %>%
    tidyr::fill(.data$`Price ($)`) %>%
    dplyr::filter(!is.na(.data$`Price ($)`)) %>%
    tidyr::separate_rows(.data$Jurisdiction, sep=", ", convert = TRUE)
  
  return(data)
}
