#' Clinical Emissions: Data Frame and Plot
#' 
#' @description Get the clinical theatre emissions after a data frame is inputted into the function.
#'
#'@inheritParams clinical_theatre_emissions
#' @param data Data frame containing all data to be used in the emissions calculation
#' @param time Variable in `data` that corresponds to the time.
#' @param date_format The date format for the time variable (optional, default: c("%d/%m/%Y")).
#' @param name Variable in `data` that corresponds to the theatre name.
#' @param include_cpi Logical variable specifying whether to calculate carbon price credit as well as emissions.
#' @param jurisdiction A character string specifying the jurisdiction for which the carbon price credit should be calculated. Available jurisdictions can be found by `check_CPI()`.
#' @param year An optional numeric value specifying the year for which the carbon price credit should be calculated.
#' If `NULL`, the most recent year available in the CPI data will be used.
#' @param period An optional numeric value specifying the period within the specified year for which the carbon price credit should be calculated.
#' If `1`, the function will use the first period if it is available; if `2`, the function will use the second period if it is available. If `0`, the function will calculate the mean between the first and second period.
#' @param manual_price An option to manually input a carbon price index to override the value in the World Bank Data.
#' @param gti_by The grouping type for calculating the GTI ("default", "month", "year").
#' @param overall_by The grouping type for the total output plot ("default", "month", "year"). This is a plot of the emissions if `include_cpi = FALSE`, otherwise is the CPI value.
#' @param single_sheet Options are `NULL`, `TRUE` or `FALSE`. This is whether to give the summaries in a single sheet display, or as a list containing the table and `ggplot2` objects.
#' If `NULL` then no graphical output is given. 
#' 
#' @return Returns list containing two objects. A table containing CO2e emissions for each row of data (and carbon price index in USD if `include_cpi` is `TRUE`), and a `ggplot2` object plotting the CO2e emissions. The second object is a single sheet containing summaries if `single_sheet = TRUE`. 
#' @export
#'
#' @examples
#' # Example with dummy data
#' df <- data.frame(time = c("10/04/2000", "10/04/2000", "11/04/2000",
#'                           "11/04/2000", "12/04/2000", "12/04/2000"),
#'                  theatre = rep(c("A", "B"), times = 3),
#'                  clinical_waste = c(80, 90, 80, 100, 120, 110),
#'                  electricity_kwh = c(100, 110, 90, 100, 100, 110),
#'                  general_waste = c(65, 55, 70, 50, 60, 30))
#' 
#' clinical_theatre_data(df, time = time, name = theatre,
#'                  wet_clinical_waste = clinical_waste,
#'                  wet_clinical_waste_unit = "kg",
#'                  desflurane = 10,
#'                  average = general_waste,
#'                  plastic_units = "kg",
#'                  electricity_kWh = electricity_kwh,
#'                  include_cpi = TRUE,
#'                  jurisdiction = "Australia",
#'                  year = 2023,
#'                  single_sheet = FALSE)
clinical_theatre_data <- function(data, time, date_format = c("%d/%m/%Y"), name, wet_clinical_waste = 0, wet_clinical_waste_unit = c("tonnes", "kg"),
                                  desflurane = 0, sevoflurane = 0, isoflurane = 0, methoxyflurane = 0, N2O = 0, propofol = 0,
                                  water_supply = 0, water_trt = TRUE, water_unit = c("cubic metres", "million litres"),
                                  electricity_kWh = 0, electricity_TD = TRUE, electricity_WTT = TRUE,
                                  heat_kWh = 0, heat_TD = TRUE, heat_WTT = TRUE,
                                  glass = 0, board = 0, mixed = 0, paper = 0,
                                  average = 0, average_film = 0, average_rigid = 0, HDPE = 0,
                                  LDPE = 0, LLDPE = 0, PET = 0, PP = 0, PS = 0, PVC = 0,
                                  glass_WD = 0, glass_waste_disposal = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
                                  board_WD = 0, mixed_WD = 0, paper_WD = 0,
                                  paper_waste_disposal = c("Closed-loop", "Combustion", "Composting", "Landfill"),
                                  average_WD = 0, average_film_WD = 0, average_rigid_WD = 0, HDPE_WD = 0,
                                  LDPE_WD = 0, LLDPE_WD = 0, PET_WD = 0, PP_WD = 0, PS_WD = 0, PVC_WD = 0,
                                  plastic_waste_disposal = c("Closed-loop", "Combustion", "Landfill", "Open-loop"),
                                  fridges = 0, freezers = 0, electric_waste_disposal = c("Landfill", "Open-loop"),
                                  glass_units = c("kg", "tonnes"), paper_units = c("kg", "tonnes"), plastic_units = c("kg", "tonnes"),
                                  electrical_units = c("kg", "tonnes"),
                                  include_cpi = FALSE, jurisdiction = NULL, year = NULL, period = 0, manual_price = NULL,
                                  gti_by = c("default", "month", "year"), overall_by = c("default", "month", "year"), single_sheet = FALSE){
  gti_by <- match.arg(gti_by)
  overall_by <- match.arg(overall_by)
  summary_emissions <- data %>%
    dplyr::mutate(emissions = clinical_theatre_emissions(wet_clinical_waste = {{ wet_clinical_waste }}, wet_clinical_waste_unit = wet_clinical_waste_unit,
                                                         desflurane = {{ desflurane }}, sevoflurane = {{ sevoflurane }}, isoflurane = {{ isoflurane }},
                                                         methoxyflurane = {{ methoxyflurane }}, N2O = {{ N2O }}, propofol = {{ propofol }},
                                                         water_supply = {{ water_supply }}, water_trt = water_trt, water_unit = water_unit,
                                                         electricity_kWh = {{ electricity_kWh }}, electricity_TD = electricity_TD, electricity_WTT = electricity_WTT,
                                                         heat_kWh = {{ heat_kWh }}, heat_TD = heat_TD, heat_WTT = heat_WTT,
                                                         # glass
                                                         glass = {{ glass }}, glass_WD = glass_WD, glass_waste_disposal = glass_waste_disposal,
                                                         # types of paper / disposing the paper
                                                         board = {{ board }}, mixed = {{ mixed }}, paper = {{ paper }},
                                                         board_WD = {{ board_WD }}, mixed_WD = {{ mixed_WD }}, paper_WD = {{ paper_WD }},
                                                         paper_waste_disposal = paper_waste_disposal, paper_units = paper_units,
                                                         # types of plastic / disposing the plastic
                                                         average = {{ average }}, average_film = {{ average_film }}, average_rigid = {{ average_rigid }},
                                                         HDPE = {{ HDPE }}, LDPE = {{ LDPE }}, LLDPE = {{ LLDPE }}, PET = {{ PET }}, PP = {{ PP }}, PS = {{ PS }}, PVC = {{ PVC }},
                                                         average_WD = {{ average_WD }}, average_film_WD = {{ average_film_WD }}, average_rigid_WD = {{ average_rigid_WD }},
                                                         HDPE_WD = {{ HDPE_WD }}, LDPE_WD = {{ LDPE_WD }}, LLDPE_WD = {{ LLDPE_WD }}, PET_WD = {{ PET_WD }}, PP_WD = {{ PP_WD }},
                                                         PS_WD = {{ PS_WD }}, PVC_WD = {{ PVC_WD }}, plastic_waste_disposal = plastic_waste_disposal, plastic_units = plastic_units,
                                                         fridges = {{ fridges }}, freezers = {{ freezers }}, electric_waste_disposal = electric_waste_disposal, electrical_units = electrical_units)) %>%
    dplyr::select(c({{ time }}, {{ name }}, emissions))
  return_object <- NULL
  if (include_cpi) {
    summary_emissions <- summary_emissions %>% dplyr::mutate(carbon_price_credit = carbon_price_credit(jurisdiction, year, period, manual_price, emissions))
    if (!is.null(single_sheet)){
      return_object[[1]] <- summary_emissions
      return_object[[2]] <- output_display(data = summary_emissions, time = {{ time }}, date_format = date_format,
                                           name = {{ name }}, relative_gpi_val = emissions, gti_by = gti_by,
                                           plot_val = carbon_price_credit, plot_by = overall_by, pdf = single_sheet)
    } else {
      return_object <- summary_emissions
    }
  } else {
    if (!is.null(single_sheet)){
      return_object[[1]] <- summary_emissions
      return_object[[2]] <- output_display(data = summary_emissions, time = {{ time }}, date_format = date_format,
                                           name = {{ name }}, relative_gpi_val = emissions, gti_by = gti_by,
                                           plot_val = emissions, plot_by = overall_by, pdf = single_sheet)
    } else {
      return_object <- summary_emissions
    }
  }
  return(return_object)
}

