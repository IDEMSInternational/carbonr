#' Clinical Emissions: Data Frame and Plot
#' 
#' @description Get the clinical theatre emissions after a data frame is inputted into the function.
#'
#'@inheritParams clinical_theatre_emissions
#' @param data Data frame containing all data to be used in the emissions calculation
#' @param time Variable in `data` that corresponds to the time.
#' @param name Variable in `data` that corresponds to the theatre name.
#' 
#' @return Returns two objects. A table containing CO2e emissions for each row of data, and a `ggplot2` object plotting the CO2e emissions.
#' @export
#'
#' @examples
#' # Example with dummy data
#' 
#' df <- data.frame(time = c("10/04/2000", "10/04/2000", "11/04/2000", "11/04/2000", "12/04/2000", "12/04/2000"),
#' theatre = rep(c("A", "B"), times = 3),
#' clinical_waste = c(80, 90, 80, 100, 120, 110),
#' electricity_kwh = c(100, 110, 90, 100, 100, 110),
#' general_waste = c(65, 55, 70, 50, 60, 30))
#' 
#' clinical_theatre_data(df, time = time, name = theatre,
#'                  wet_clinical_waste = clinical_waste,
#'                  wet_clinical_waste_unit = "kg",
#'                  desflurane = 10,
#'                  average = general_waste,
#'                  plastic_units = "kg",
#'                  electricity_kWh = electricity_kwh)
# x <- clinical_theatre_data(clincial_example_df, time = date_yyyy_mm, name = theatre_name,
# wet_clinical_waste = clinical_waste_kg,
# wet_clinical_waste_unit = "kg",
# average = general_waste_kg,
# plastic_units = "kg",
# electricity_kWh = electricity_kwh,
# water_supply = water_million_litres,
# water_unit = "million litres")
clinical_theatre_data <- function(data, time, name, wet_clinical_waste = 0, wet_clinical_waste_unit = c("tonnes", "kg"),
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
                                  electrical_units = c("kg", "tonnes")){
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
  
  summary_plot <- ggplot2::ggplot(summary_emissions, ggplot2::aes(x = {{ time }}, y = emissions)) + ggplot2::geom_point() + ggplot2::facet_wrap(ggplot2::vars({{ name }}))
  return_object <- NULL
  return_object[[1]] <- summary_emissions
  return_object[[2]] <- summary_plot
  names(return_object) <- c("data", "ggplot")
  return(return_object)
}