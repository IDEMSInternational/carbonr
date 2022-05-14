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
  ui <- shinydashboard::dashboardPage(skin = "green",
                                      header = shinydashboard::dashboardHeader(title = "Carbon Emissions - IDEMS"),
                                      sidebar = shinydashboard::dashboardSidebar(disable = TRUE),
                                      shinydashboard::dashboardBody(shiny::fluidRow(
                                        shiny::column(12, align = "left",
                                                      shinydashboard::box(shiny::splitLayout(htmltools::h2("Calculate Emissions"), shiny::icon("calculator", "fa-5x"), cellArgs = list(style = "vertical-align: top"), cellWidths = c("80%", "20%")),
                                                                          width = 10, solidHeader = TRUE, height = "95px"))),
                                        shiny::fluidRow(
                                          shiny::column(12, align = "left",
                                                        shiny::splitLayout(
                                                          shinydashboard::box(width=NULL, title = "Calculator", status ="success", solidHeader = TRUE,
                                                                              shiny::uiOutput("tab"),
                                                                              shiny::tabsetPanel(type = "tabs",
                                                                                                 shiny::tabPanel("Flights",
                                                                                                                 shiny::splitLayout(shinydashboard::box(width = NULL,
                                                                                                                                                        shiny::textInput(inputId = "flightfrom",
                                                                                                                                                                         label = "From:",
                                                                                                                                                                         value = "LHR",
                                                                                                                                                                         width = "41%"),
                                                                                                                                                        shiny::textInput(inputId = "flightto",
                                                                                                                                                                         label = "To:",
                                                                                                                                                                         value = "NBO",
                                                                                                                                                                         width = "41%"),
                                                                                                                                                        shiny::numericInput("flightvia",
                                                                                                                                                                            "Via:",
                                                                                                                                                                            value = 0,
                                                                                                                                                                            min = 0,
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::uiOutput("flightvia_input"),
                                                                                                                                                        shiny::radioButtons(inputId = "flightclass",
                                                                                                                                                                            label = "Flight Class:",
                                                                                                                                                                            c("Economy" = "economy",
                                                                                                                                                                              "Premium Economy" = "premium economy", 
                                                                                                                                                                              "Business" = "business", 
                                                                                                                                                                              "First" = "first")),
                                                                                                                                                        shiny::numericInput(inputId = "numberflying", 
                                                                                                                                                                            label = "Number of people:",
                                                                                                                                                                            value = 1,
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::checkboxInput(inputId = "radiative",
                                                                                                                                                                             label = "Account for radiative forcing", 
                                                                                                                                                                             value = TRUE, width = "20%"),
                                                                                                                                                        shiny::checkboxInput(inputId = "roundtrip_plane",
                                                                                                                                                                             label = "Round trip", 
                                                                                                                                                                             value = TRUE, 
                                                                                                                                                                             width = "20%"),
                                                                                                                                                        shiny::checkboxInput(inputId = "secondary_plane", 
                                                                                                                                                                             label = "Include indirect emissions", # associated with extracting, refining, and transporting fuels", 
                                                                                                                                                                             value = TRUE, 
                                                                                                                                                                             width = "20%"),
                                                                                                                                                        shiny::splitLayout(shiny::verbatimTextOutput("plane_emissions"),
                                                                                                                                                                           htmltools::h6("emissions"),
                                                                                                                                                                           shiny::actionButton("add_plane", "Add to Table", class="btn-success"), 
                                                                                                                                                                           cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "airportname", 
                                                                                                                                                      label = "Check Airport Code:", 
                                                                                                                                                      value = "London Heathrow Airport"),
                                                                                                                                     htmltools::p("Airports with similar names:"),
                                                                                                                                     shiny::tableOutput("flight_name_check")), # close box
                                                                                                                 cellWidths = c("40%", "60%"))), # close Flights panel
                                                                                                 shiny::tabPanel("Rail (UK)", 
                                                                                                                 shiny::splitLayout(shinydashboard::box(width = NULL,
                                                                                                                                                        shiny::textInput(inputId = "trainfrom",
                                                                                                                                                                         label = "From:",
                                                                                                                                                                         value = "Bristol Temple Meads",
                                                                                                                                                                         width = "41%"),
                                                                                                                                                        shiny::textInput(inputId = "trainto", 
                                                                                                                                                                         label = "To:",
                                                                                                                                                                         value = "Paddington",
                                                                                                                                                                         width = "41%"),
                                                                                                                                                        shiny::numericInput("trainvia",
                                                                                                                                                                            "Via:",
                                                                                                                                                                            value = 0, 
                                                                                                                                                                            min = 0, 
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::uiOutput("trainvia_input"),
                                                                                                                                                        shiny::numericInput(inputId = "numbertrain", 
                                                                                                                                                                            label = "Number of people:",
                                                                                                                                                                            value = 1, 
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::numericInput(inputId = "timestrain",
                                                                                                                                                                            label = "Times Journey Made:",
                                                                                                                                                                            value = 1,
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::checkboxInput(inputId = "roundtrip_train", 
                                                                                                                                                                             label = "Round trip", 
                                                                                                                                                                             value = TRUE, 
                                                                                                                                                                             width = "20%"),
                                                                                                                                                        shiny::checkboxInput(inputId = "secondary_train", 
                                                                                                                                                                             label = "Include indirect emissions", # associated with extracting, refining, and transporting fuels", 
                                                                                                                                                                             value = TRUE, 
                                                                                                                                                                             width = "20%"),
                                                                                                                                                        shiny::splitLayout(shiny::verbatimTextOutput("train_emissions"), htmltools::h6("emissions"), shiny::actionButton("add_train", "Add to Table", class="btn-success"), cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "trainname", label = "Check Train Station:", value = "Bristol"),
                                                                                                                                     htmltools::p("Train Stations with similar names:"),
                                                                                                                                     shiny::tableOutput("train_name_check")), # close box
                                                                                                                 cellWidths = c("40%", "60%"))), # close Flights panel
                                                                                                 shiny::tabPanel("Vehicle Transport",
                                                                                                                 shinydashboard::box(width = NULL, shiny::selectInput("vehicle", 
                                                                                                                                                                      "Vehicle:",
                                                                                                                                                                      c("Car" = "car",
                                                                                                                                                                        "Van" = "van",
                                                                                                                                                                        "Taxi" = "taxi",
                                                                                                                                                                        "Motorbike" = "motorbike",
                                                                                                                                                                        "Bus" = "bus", 
                                                                                                                                                                        "Coach" = "coach", 
                                                                                                                                                                        "Tram" = "tram", 
                                                                                                                                                                        "Tube" = "tube")),
                                                                                                                                     shiny::conditionalPanel(
                                                                                                                                       condition = "input.vehicle == 'car' | input.vehicle == 'van' | input.vehicle == 'motorbike'",
                                                                                                                                       shiny::radioButtons("size_vehicle", 
                                                                                                                                                           "Size:", 
                                                                                                                                                           c("Average" = "average",
                                                                                                                                                             "Small" = "small",
                                                                                                                                                             "Medium" = "medium",
                                                                                                                                                             "Large" = "large")),
                                                                                                                                       shiny::conditionalPanel(condition = "input.vehicle == 'car'",
                                                                                                                                                               shiny::radioButtons("driven_gas",
                                                                                                                                                                                   "Fuel Type:",
                                                                                                                                                                                   c("Unleaded gasoline" = "petrol", 
                                                                                                                                                                                     "Diesel" = "diesel",
                                                                                                                                                                                     "Unknown" = "unknown", 
                                                                                                                                                                                     "Hybrid" = "hybrid",
                                                                                                                                                                                     "Hybrid Electric" = "hybrid electric",
                                                                                                                                                                                     "Battery electric" = "battery electric")),
                                                                                                                                                               shiny::conditionalPanel(condition = "input.driven_gas == 'hybrid electric' | input.driven_gas == 'battery electric'",
                                                                                                                                                                                       shiny::checkboxInput(inputId = "secondary_electric", 
                                                                                                                                                                                                            label = "Include emissions for electricity",
                                                                                                                                                                                                            value = TRUE, 
                                                                                                                                                                                                            width = "20%")),
                                                                                                                                                               shiny::checkboxInput(inputId = "owned_vehicles", 
                                                                                                                                                                                    label = "Vehicle owned by company",
                                                                                                                                                                                    value = FALSE, 
                                                                                                                                                                                    width = "20%")),
                                                                                                                                       shiny::conditionalPanel(condition = "input.vehicle == 'van'",
                                                                                                                                                               shiny::radioButtons("driven_gas",
                                                                                                                                                                                   "Fuel Type:",
                                                                                                                                                                                   c("Unleaded gasoline" = "petrol",
                                                                                                                                                                                     "Diesel" = "diesel",
                                                                                                                                                                                     "Battery electric" = "battery electric")),
                                                                                                                                                               shiny::conditionalPanel(condition = "input.driven_gas == 'battery electric'",
                                                                                                                                                                                       shiny::checkboxInput(inputId = "secondary_electric", 
                                                                                                                                                                                                            label = "Include emissions for electricity",
                                                                                                                                                                                                            value = TRUE, 
                                                                                                                                                                                                            width = "20%")))),
                                                                                                                                     shiny::conditionalPanel(condition = "input.vehicle == 'bus'",
                                                                                                                                       shiny::radioButtons("driven_type", 
                                                                                                                                                           "Type:", 
                                                                                                                                                           c("Average" = "average", 
                                                                                                                                                             "Local (London)" = "local_L", 
                                                                                                                                                             "Local (Not London)" = "local_nL", 
                                                                                                                                                             "Local" = "local"))),
                                                                                                                                     shiny::conditionalPanel(
                                                                                                                                       condition = "input.vehicle == 'taxi'",
                                                                                                                                       shiny::radioButtons("taxi_type", 
                                                                                                                                                           "Type:", 
                                                                                                                                                           c("Regular" = "regular", 
                                                                                                                                                             "Black Cab" = "black cab")),
                                                                                                                                     ),
                                                                                                                                     shiny::radioButtons("driven_units",
                                                                                                                                                         "Units:", 
                                                                                                                                                         c("Miles" = "miles", 
                                                                                                                                                           "Kilometres" = "km")),
                                                                                                                                     shiny::numericInput(inputId = "drive_KM", label = "Distance driven:", value = "100", width = "41%"),
                                                                                                                                     shiny::numericInput(inputId = "drive_number", label = "Number of vehicles (or passengers if by bus, coach, tram, tube):", value = "1", width = "41%"),
                                                                                                                                     shiny::checkboxInput(inputId = "secondary_vehicles", 
                                                                                                                                                          label = "Include indirect emissions",
                                                                                                                                                          value = TRUE, 
                                                                                                                                                          width = "20%"),
                                                                                                                                     shiny::splitLayout(shiny::verbatimTextOutput("driven_emissions"), htmltools::h6("emissions"), shiny::actionButton("add_drive", "Add to Table", class="btn-success"), 
                                                                                                                                                        cellArgs = list(style = "vertical-align: top")),
                                                                                                                 )),
                                                                                                 shiny::tabPanel("Ferry", 
                                                                                                                 shiny::splitLayout(shinydashboard::box(width = NULL,
                                                                                                                                                        shiny::textInput(inputId = "ferryfrom",
                                                                                                                                                                         label = "From:",
                                                                                                                                                                         value = "ABD",
                                                                                                                                                                         width = "41%"),
                                                                                                                                                        shiny::textInput(inputId = "ferryto", 
                                                                                                                                                                         label = "To:",
                                                                                                                                                                         value = "LIV",
                                                                                                                                                                         width = "41%"),
                                                                                                                                                        shiny::numericInput("ferryvia",
                                                                                                                                                                            "Via:",
                                                                                                                                                                            value = 0, 
                                                                                                                                                                            min = 0, 
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::uiOutput("ferryvia_input"),
                                                                                                                                                        shiny::numericInput(inputId = "numberferry", 
                                                                                                                                                                            label = "Number of people:",
                                                                                                                                                                            value = 1, 
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::radioButtons(inputId = "typeferry",
                                                                                                                                                                            "Type:",
                                                                                                                                                                            c("Foot" = "foot",
                                                                                                                                                                              "Car" = "car",
                                                                                                                                                                              "Average" = "average")),
                                                                                                                                                        shiny::numericInput(inputId = "timesferry",
                                                                                                                                                                            label = "Times Journey Made:",
                                                                                                                                                                            value = 1,
                                                                                                                                                                            width = "41%"),
                                                                                                                                                        shiny::checkboxInput(inputId = "roundtrip_ferry", 
                                                                                                                                                                             label = "Round trip", 
                                                                                                                                                                             value = TRUE, 
                                                                                                                                                                             width = "20%"),
                                                                                                                                                        shiny::checkboxInput(inputId = "secondary_ferry", 
                                                                                                                                                                             label = "Include indirect emissions", # associated with extracting, refining, and transporting fuels", 
                                                                                                                                                                             value = TRUE, 
                                                                                                                                                                             width = "20%"),
                                                                                                                                                        shiny::splitLayout(shiny::verbatimTextOutput("ferry_emissions"), htmltools::h6("emissions"), shiny::actionButton("add_ferry", "Add to Table", class="btn-success"), cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "ferryname", label = "Check Port:", value = "Aberdeen"),
                                                                                                                                     htmltools::p("Ferry Ports with similar names:"),
                                                                                                                                     shiny::tableOutput("ferry_name_check")), # close box
                                                                                                                 cellWidths = c("40%", "60%"))), # close Flights panel
                                                                                                 shiny::tabPanel("Office Usage",
                                                                                                                 shiny::checkboxInput(inputId = "specify_office", 
                                                                                                                                      label = "Specify Emissions", 
                                                                                                                                      value = TRUE, 
                                                                                                                                      width = "20%"),
                                                                                                                 shiny::numericInput(inputId = "number_office",
                                                                                                                                     label = "Number of people in the office:",
                                                                                                                                     value = 1,
                                                                                                                                     width = "41%"),
                                                                                                                 shiny::numericInput(inputId = "wfh_office",
                                                                                                                                     label = "Number of people working from home:",
                                                                                                                                     value = 1,
                                                                                                                                     width = "41%"),
                                                                                                                 shiny::conditionalPanel(
                                                                                                                   condition = "input.specify_office == 1",
                                                                                                                   shiny::numericInput(inputId = "electricity_office",
                                                                                                                                       label = "Electricity (kWh):",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::numericInput(inputId = "heat_office",
                                                                                                                                       label = "Heat (kWh):",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::numericInput(inputId = "water_office",
                                                                                                                                       label = "Water (m3):",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::numericInput(inputId = "naturalgas_office",
                                                                                                                                       label = "Natural Gas:",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::selectInput("naturalgas_units_office", 
                                                                                                                                      "Units:",
                                                                                                                                      c("Tonnes" = "tonnes",
                                                                                                                                        "Cubic metres" = "cubic metres",
                                                                                                                                        "kWh" = "kwh"),
                                                                                                                                      width = "41%"),
                                                                                                                   shiny::numericInput(inputId = "oil_office",
                                                                                                                                       label = "Burning Oil:",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::selectInput("oil_units_office",
                                                                                                                                      "Units:",
                                                                                                                                      c("Tonnes" = "tonnes",
                                                                                                                                        "Litres" = "litres",
                                                                                                                                        "kWh" = "kwh"),
                                                                                                                                      width = "41%"),
                                                                                                                   shiny::numericInput(inputId = "coal_office",
                                                                                                                                       label = "Domestic Coal:",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::selectInput("coal_units_office", 
                                                                                                                                      "Units:",
                                                                                                                                      c("Tonnes" = "tonnes",
                                                                                                                                        "kWh" = "kwh"),
                                                                                                                                      width = "41%"),
                                                                                                                   shiny::numericInput(inputId = "woodlogs_office",
                                                                                                                                       label = "Wood logs:",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::selectInput("woodlogs_units_office", 
                                                                                                                                      "Units:",
                                                                                                                                      c("Tonnes" = "tonnes",
                                                                                                                                        "kWh" = "kwh"),
                                                                                                                                      width = "41%"),
                                                                                                                   shiny::numericInput(inputId = "woodchips_office",
                                                                                                                                       label = "Wood chips:",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::selectInput("woodchips_units_office", 
                                                                                                                                      "Units:",
                                                                                                                                      c("Tonnes" = "tonnes",
                                                                                                                                        "kWh" = "kwh"),
                                                                                                                                      width = "41%"),
                                                                                                                   shiny::checkboxInput(inputId = "wtt_office", 
                                                                                                                                        label = "Include indirect emissions for fuels", # associated with extracting, refining, and transporting fuels", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%"),
                                                                                                                   shiny::checkboxInput(inputId = "td_office", 
                                                                                                                                        label = "Include emissions associated with grid losses", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%"),
                                                                                                                   shiny::checkboxInput(inputId = "trt_office", 
                                                                                                                                        label = "Include emissions associated with water treatment for used water", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%")),
                                                                                                                 
                                                                                                                 shiny::splitLayout(shiny::verbatimTextOutput("office_emissions"),
                                                                                                                                    htmltools::h6("emissions"),
                                                                                                                                    shiny::actionButton("add_office", "Add to Table", class="btn-success"), 
                                                                                                                                    cellArgs = list(style = "vertical-align: top"))),
                                                                                                 shiny::tabPanel("Hotel Stays",
                                                                                                                 shinydashboard::box(width = NULL, shiny::selectInput("location_hotel", 
                                                                                                                                                                      "Location:",
                                                                                                                                                                      c("UK", "Argentina", "Australia", "Austria", "Belgium", "Brazil", "Canada", "Chile", "China", "Columbia", "Costa Rica", "Czechia", "Egypt", "Fiji", "France", "Germany", "Greece", "Hong Kong", "India", "Indonesia", "Ireland", "Israel", "Italy", "Japan", "Jordan", "Korea", "Macau", "Malaysia", "Maldives", "Mexico", "Netherlands", "New Zealand", "Panama", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Saudi Arabia", "Singapore", "Slovakia", "South Africa", "Spain", "Switzerland", "Taiwan", "Thailand", "Turkey", "United Arab Emirates", "United States", "Vietnam",
                                                                                                                                                                        "Average")),
                                                                                                                                     shiny::numericInput(inputId = "nights_hotel",
                                                                                                                                                         label = "Nights stayed:",
                                                                                                                                                         value = "1",
                                                                                                                                                         width = "41%"),
                                                                                                                                     shiny::numericInput(inputId = "number_hotel",
                                                                                                                                                         label = "Number of rooms:",
                                                                                                                                                         value = "1",
                                                                                                                                                         width = "41%"),
                                                                                                                                     shiny::splitLayout(shiny::verbatimTextOutput("hotel_emissions"),
                                                                                                                                                        htmltools::h6("emissions"),
                                                                                                                                                        shiny::actionButton("add_hotel", "Add to Table", class="btn-success"), 
                                                                                                                                                        cellArgs = list(style = "vertical-align: top")))
                                                                                                                 )#,
                                                                                                 #shiny::tabPanel("Raw Fuels",
                                                                                                 #                # n = input
                                                                                                 #                # %
                                                                                                 #)
                                                                              )# close tabset panel
                                                          ),# close box1
                                                          htmltools::br(),
                                                          shinydashboard::box(width = NULL, title = "Emissions Table", status ="success", solidHeader = TRUE, shiny::tableOutput("table_emissions")),
                                                          cellWidths = c("65%", "5%", "30%"))))
                                      ) # close body
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
      if (input$add_plane > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=carbon_calc()))))) }
    })
    Data = shiny::reactive({input$add_train
      if (input$add_train > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=train_carbon_calc()))))) }
    })
    Data = shiny::reactive({input$add_drive
      if (input$add_drive > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=drive_carbon_calc()))))) }
    })
    Data = shiny::reactive({input$add_ferry
      if (input$add_ferry > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=ferry_carbon_calc()))))) }
    })
    Data = shiny::reactive({input$add_hotel
      if (input$add_hotel > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=hotel_carbon_calc()))))) }
    })
    Data = shiny::reactive({input$add_office
      if (input$add_office > 0) { shiny::isolate(return(list(df = data.frame(Emissions = rbind(y=NULL, x=office_carbon_calc()))))) }
    })
    shiny::observeEvent(input$add_plane, {
      if (input$add_plane > 0) { df$data <- rbind(df$data, carbon_calc()) }
        names(df$data) <- "Emissions"
    })
    shiny::observeEvent(input$add_train, {
      if (input$add_train > 0) { df$data <- rbind(df$data, train_carbon_calc()) }
        names(df$data) <- "Emissions"
    })
    shiny::observeEvent(input$add_drive, {
      if (input$add_drive > 0) { df$data <- rbind(df$data, drive_carbon_calc()) }
        names(df$data) <- "Emissions"
    })
    shiny::observeEvent(input$add_ferry, {
      if (input$add_ferry > 0) { df$data <- rbind(df$data, ferry_carbon_calc()) }
      names(df$data) <- "Emissions"
    })
    shiny::observeEvent(input$add_hotel, {
      if (input$add_hotel > 0) { df$data <- rbind(df$data, hotel_carbon_calc()) }
      names(df$data) <- "Emissions"
    })
    shiny::observeEvent(input$add_office, {
      if (input$add_office > 0) { df$data <- rbind(df$data, office_carbon_calc()) }
      names(df$data) <- "Emissions"
    })
    output$table_emissions <- shiny::renderTable(df$data)
  }
  return(shiny::shinyApp(ui, server))
}