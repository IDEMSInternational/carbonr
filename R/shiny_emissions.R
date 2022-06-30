#' Run Shiny App to Calculate Carbon Emissions
#' @description Runs a GUI to the functions in the carbonr package to calculate carbon-equivalent emissions.
#'
#' @return Shiny app to calculate carbon-equivalent emissions
#' @export
#'
#' @examples 
#' ## NOT RUN ##
#' # shiny_emissions()
shiny_emissions <- function(){
  df <- shiny::reactiveValues(data = data.frame(y=NULL))
  ui <- shinydashboard::dashboardPage(header = shinydashboard::dashboardHeader(title = "Carbon Emissions - IDEMS"),
                                      sidebar = shinydashboard::dashboardSidebar(disable = TRUE),
                                      shinydashboard::dashboardBody(shiny::fluidRow(
                                        shiny::column(12, align = "left",
                                                      shinydashboard::box(shiny::splitLayout(htmltools::h2("Calculate Emissions"), shiny::icon("calculator", "fa-5x"), cellArgs = list(style = "vertical-align: top"), cellWidths = c("80%", "20%")),
                                                                          width = 10, solidHeader = TRUE, height = "95px"))))
  ) # close page
  
  server <- function(input, output) {
    ##### Flight Emissions #####
    # checking airport names
    flight_name_check <- shiny::reactive({ airport_finder(name = input$airportname, ignore.case = TRUE) })
    output$flight_name_check <- shiny::renderTable({{ flight_name_check() }}, striped = TRUE)
    
    # via input options
    K_plane <- shiny::reactive({ input$flightvia })
    output$flightvia_input <- shiny::renderUI({ add_inputs(numeric_input = K_plane(),  label = "Airport:", value = "airport IATA code") })
    carbon_calc <- shiny::reactive({
      if (input$flightvia == 0){
        C_P <- NULL
      } else {
        C_P <- sapply(1:K_plane(), function(i) {input[[paste0("via_",i)]]})
      }
      airplane_emissions(from = input$flightfrom, to = input$flightto, via = C_P, class = input$flightclass, num_people = input$numberflying, radiative_force = input$radiative, round_trip = input$roundtrip_plane, include_WTT = input$secondary_plane)
    })
    output$plane_emissions <- shiny::renderText({ carbon_calc() })
    
    ##### Train Emissions #####
    # checking station names
    train_name_check <- shiny::reactive({ rail_finder(station = input$trainname, ignore.case = TRUE) })
    output$train_name_check <- shiny::renderTable({{train_name_check()}}, striped = TRUE)
    
    # via input options
    K_train <- shiny::reactive({ input$trainvia })
    output$trainvia_input <- shiny::renderUI({ add_inputs(numeric_input = K_train(),  label = "Station:", value = "station name") })
    train_carbon_calc <- shiny::reactive({
      if (input$trainvia == 0){
        C <- NULL
      } else {
        C <- sapply(1:K_train(), function(i) {input[[paste0("via1_",i)]]})
      }
      rail_emissions(from = input$trainfrom, to = input$trainto, via = C, num_people = input$numbertrain, times_journey = input$timestrain, round_trip = input$roundtrip_train, include_WTT = input$secondary_train)
    })
    output$train_emissions <- shiny::renderText({ train_carbon_calc() })
    
    ##### Vehicle Emissions #####
    drive_carbon_calc <- shiny::reactive({ vehicle_emissions(distance = input$drive_KM, vehicle = input$vehicle, units = input$driven_units, num = input$drive_number, fuel = input$driven_gas, size = input$size_vehicle, bus_type = input$driven_type, taxi_type = input$taxi_type, include_WTT = input$secondary_vehicles, include_electricity = input$secondary_electric, TD = input$owned_vehicles) })
    output$driven_emissions <- shiny::renderText({ drive_carbon_calc() })
    
    ##### Ferry Emissions #####
    # checking station names
    ferry_name_check <- shiny::reactive({ seaport_finder(city = input$ferryname, ignore.case = TRUE) })
    output$ferry_name_check <- shiny::renderTable({{ferry_name_check()}}, striped = TRUE)
    
    # via input options
    K_ferry <- shiny::reactive({ input$ferryvia })
    output$ferryvia_input <- shiny::renderUI({ add_inputs(numeric_input = K_ferry(),  label = "Station:", value = "station name") })
    ferry_carbon_calc <- shiny::reactive({
      if (input$ferryvia == 0){
        C <- NULL
      } else {
        C <- sapply(1:K_ferry(), function(i) {input[[paste0("via1_",i)]]})
      }
      ferry_emissions(from = input$ferryfrom, to = input$ferryto, via = C, num_people = input$numberferry, times_journey = input$timesferry, round_trip = input$roundtrip_ferry, include_WTT = input$secondary_ferry, type = input$typeferry)
    })
    output$ferry_emissions <- shiny::renderText({ ferry_carbon_calc() })
    
    ##### Hotel Emissions #####
    hotel_carbon_calc <- shiny::reactive({ hotel_emissions(location = input$location_hotel, nights = input$nights_hotel, rooms = input$number_hotel) })
    output$hotel_emissions <- shiny::renderText({ hotel_carbon_calc() })
    
    ##### Office Emissions #####
    office_carbon_calc <- shiny::reactive({ office_emissions(specify = input$specify_office, num_people = input$number_office, num_wfh = input$wfh_office, electricity_kwh = input$electricity_office, heat_kwh = input$heat_office, water_m3 = input$water_office, include_TD = input$td_office, include_WTT = input$wtt_office, water_trt = input$trt_office, natural_gas = input$naturalgas_office, burning_oil = input$oil_office, coal_domestic = input$coal_office, wood_log = input$woodlogs_office, wood_chips = input$woodchips_office, natural_gas_units = input$naturalgas_units_office, burning_oil_units = input$oil_units_office, coal_domestic_units = input$coal_units_office, wood_log_units = input$woodlogs_units_office,  wood_chips_units = input$woodchips_units_office) })
    output$office_emissions <- shiny::renderText({ office_carbon_calc() })
    
    ######## Submit Button ########
    Data = shiny::reactive({ input$add_plane
      if (input$add_plane > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=c(carbon_calc(), "Airplane")))))) }
    })
    Data = shiny::reactive({input$add_train
      if (input$add_train > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=c(train_carbon_calc(), "Train")))))) }
    })
    Data = shiny::reactive({input$add_drive
      if (input$add_drive > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=c(drive_carbon_calc(), "Vehicle")))))) }
    })
    Data = shiny::reactive({input$add_ferry
      if (input$add_ferry > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=c(ferry_carbon_calc(), "Ferry")))))) }
    })
    Data = shiny::reactive({input$add_hotel
      if (input$add_hotel > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=c(hotel_carbon_calc(), "Hotel")))))) }
    })
    Data = shiny::reactive({input$add_office
      if (input$add_office > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=c(office_carbon_calc(), "Office")))))) }
    })
    shiny::observeEvent(input$add_plane, {
      if (input$add_plane > 0) { df$data <- rbind(df$data, c(carbon_calc(), "Airplane")) }
      names(df$data) <- c("Emissions", "Activity")
    })
    shiny::observeEvent(input$add_train, {
      if (input$add_train > 0) { df$data <- rbind(df$data, c(train_carbon_calc(), "Train")) }
      names(df$data) <- c("Emissions", "Activity")
    })
    shiny::observeEvent(input$add_drive, {
      if (input$add_drive > 0) { df$data <- rbind(df$data, c(drive_carbon_calc(), "Vehicle")) }
      names(df$data) <- c("Emissions", "Activity")
    })
    shiny::observeEvent(input$add_ferry, {
      if (input$add_ferry > 0) { df$data <- rbind(df$data, c(ferry_carbon_calc(), "Ferry")) }
      names(df$data) <- c("Emissions", "Activity")
    })
    shiny::observeEvent(input$add_hotel, {
      if (input$add_hotel > 0) { df$data <- rbind(df$data, c(hotel_carbon_calc(), "Hotel")) }
      names(df$data) <- c("Emissions", "Activity")
    })
    shiny::observeEvent(input$add_office, {
      if (input$add_office > 0) { df$data <- rbind(df$data, c(office_carbon_calc(), "Office")) }
      names(df$data) <- c("Emissions", "Activity")
    })
    output$table_emissions <- shiny::renderTable(df$data)
  }
  return(shiny::shinyApp(ui, server))
}
