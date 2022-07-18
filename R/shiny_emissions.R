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
                                                      shinydashboard::box(shiny::splitLayout(htmltools::h2("Calculate Emissions"), 
                                                                                             shiny::icon("calculator", "fa-5x"),
                                                                                             cellArgs = list(style = "vertical-align: top")), #cellWidths = c("80%", "20%")
                                                                          width = 10,
                                                                          solidHeader = TRUE,
                                                                          height = "95px"))),
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
                                                                                                                                                                            c("Average" = "Average passenger",
                                                                                                                                                                              "Economy" = "Economy class",
                                                                                                                                                                              "Premium Economy" = "Premium economy class", 
                                                                                                                                                                              "Business" = "Business class", 
                                                                                                                                                                              "First" = "First class")),
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
                                                                                                                                                                           htmltools::h6("tonnes"),
                                                                                                                                                                           shiny::actionButton("add_plane", "Add to Table", class="btn-success"), 
                                                                                                                                                                           cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "airportname", 
                                                                                                                                                      label = "Check Airport Code:", 
                                                                                                                                                      value = "London Heathrow Airport"),
                                                                                                                                     htmltools::p("Airports with similar names:"),
                                                                                                                                     shiny::tableOutput("flight_name_check")) #,cellWidths = c("40%", "60%") # close box
                                                                                                                 )), # close Flights panel
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
                                                                                                                                                        shiny::splitLayout(shiny::verbatimTextOutput("train_emissions"), htmltools::h6("tonnes"), shiny::actionButton("add_train", "Add to Table", class="btn-success"), cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "trainname", label = "Check Train Station:", value = "Bristol"),
                                                                                                                                     htmltools::p("Train Stations with similar names:"),
                                                                                                                                     shiny::tableOutput("train_name_check"))#, cellWidths = c("40%", "60%") # close box
                                                                                                                 )), # close Flights panel
                                                                                                 shiny::tabPanel("Vehicle Transport",
                                                                                                                 shinydashboard::box(width = NULL, shiny::selectInput("vehicle", 
                                                                                                                                                                      "Vehicle:",
                                                                                                                                                                      c("Car" = "Cars",
                                                                                                                                                                        "Taxi" = "Taxis",
                                                                                                                                                                        "Motorbike" = "Motorbike",
                                                                                                                                                                        "Bus" = "Bus", 
                                                                                                                                                                        "Coach" = "Coach", 
                                                                                                                                                                        "Tram" = "Light rail and tram", 
                                                                                                                                                                        "Tube" = "London Underground")),
                                                                                                                                     shiny::conditionalPanel(
                                                                                                                                       condition = "input.vehicle == 'Cars'",
                                                                                                                                       shiny::radioButtons("size_vehicle", 
                                                                                                                                                           "Size:", 
                                                                                                                                                           c("Average" = "Average car",
                                                                                                                                                             "Small" = "Small car",
                                                                                                                                                             "Medium" = "Medium car",
                                                                                                                                                             "Large" = "Large car")),
                                                                                                                                       shiny::conditionalPanel(condition = "input.vehicle == 'Cars'",
                                                                                                                                                               shiny::radioButtons("driven_gas",
                                                                                                                                                                                   "Fuel Type:",
                                                                                                                                                                                   c("Unleaded gasoline" = "Petrol", 
                                                                                                                                                                                     "Diesel" = "Diesel",
                                                                                                                                                                                     "Unknown" = "Unknown", 
                                                                                                                                                                                     #"Hybrid" = "hybrid",
                                                                                                                                                                                     "Plug-in Electric" = "Plug-in Hybrid Electric Vehicle",
                                                                                                                                                                                     "Battery electric" = "Battery Electric Vehicle")),
                                                                                                                                                               shiny::conditionalPanel(condition = "input.driven_gas == 'Plug-in Hybrid Electric Vehicle' | input.driven_gas == 'Battery Electric Vehicle'",
                                                                                                                                                                                       shiny::checkboxInput(inputId = "secondary_electric", 
                                                                                                                                                                                                            label = "Include emissions for electricity",
                                                                                                                                                                                                            value = TRUE, 
                                                                                                                                                                                                            width = "20%")),
                                                                                                                                                               shiny::checkboxInput(inputId = "owned_vehicles", 
                                                                                                                                                                                    label = "Vehicle owned by company",
                                                                                                                                                                                    value = FALSE, 
                                                                                                                                                                                    width = "20%")),
                                                                                                                                       # shiny::conditionalPanel(condition = "input.vehicle == 'van'",
                                                                                                                                       #                         shiny::radioButtons("driven_gas",
                                                                                                                                       #                                             "Fuel Type:",
                                                                                                                                       #                                             c("Unleaded gasoline" = "petrol",
                                                                                                                                       #                                               "Diesel" = "diesel",
                                                                                                                                       #                                               "Battery electric" = "battery electric")),
                                                                                                                                       #                         shiny::conditionalPanel(condition = "input.driven_gas == 'battery electric'",
                                                                                                                                       #                                                 shiny::checkboxInput(inputId = "secondary_electric", 
                                                                                                                                       #                                                                      label = "Include emissions for electricity",
                                                                                                                                       #                                                                      value = TRUE, 
                                                                                                                                       #                                                                      width = "20%")))
                                                                                                                                     ),
                                                                                                                                     shiny::conditionalPanel(condition = "input.vehicle == 'Bus'",
                                                                                                                                                             shiny::radioButtons("driven_type", 
                                                                                                                                                                                 "Type:", 
                                                                                                                                                                                 c("Average" = "Average local bus", 
                                                                                                                                                                                   "Local (London)" = "Local London bus", 
                                                                                                                                                                                   "Local (Not London)" = "Local bus (not London)"))),
                                                                                                                                     shiny::conditionalPanel(
                                                                                                                                       condition = "input.vehicle == 'Taxis'",
                                                                                                                                       shiny::radioButtons("taxi_type", 
                                                                                                                                                           "Type:", 
                                                                                                                                                           c("Regular" = "Regular taxi", 
                                                                                                                                                             "Black Cab" = "Black cab")),
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
                                                                                                                                     shiny::splitLayout(shiny::verbatimTextOutput("driven_emissions"), htmltools::h6("tonnes"), shiny::actionButton("add_drive", "Add to Table", class="btn-success"), 
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
                                                                                                                                                        shiny::splitLayout(shiny::verbatimTextOutput("ferry_emissions"), htmltools::h6("tonnes"), shiny::actionButton("add_ferry", "Add to Table", class="btn-success"), cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "ferryname", label = "Check Port:", value = "Aberdeen"),
                                                                                                                                     htmltools::p("Ferry Ports with similar names:"),
                                                                                                                                     shiny::tableOutput("ferry_name_check"))#,cellWidths = c("40%", "60%") # close box
                                                                                                                 )), # close Flights panel
                                                                                                 shiny::tabPanel("Office Usage",
                                                                                                                 shiny::checkboxInput(inputId = "specify_office", 
                                                                                                                                      label = "Specify Emissions", 
                                                                                                                                      value = TRUE, 
                                                                                                                                      width = "20%"),
                                                                                                                 shiny::numericInput(inputId = "wfh_office",
                                                                                                                                     label = "Number of people working from home:",
                                                                                                                                     value = 1,
                                                                                                                                     width = "41%"),
                                                                                                                 shiny::numericInput(inputId = "wfh_hours",
                                                                                                                                     label = "Hours working from home (per person):",
                                                                                                                                     value = 7,
                                                                                                                                     width = "41%"),
                                                                                                                 # @param WFH_type Whether to account for `"Office Equipment"` and/or `"Heating"`. Default is both.
                                                                                                                 shiny::conditionalPanel(
                                                                                                                   condition = "input.specify_office == 0",
                                                                                                                   shiny::numericInput(inputId = "number_office",
                                                                                                                                       label = "Number of people in the office:",
                                                                                                                                       value = 1,
                                                                                                                                       width = "41%")),
                                                                                                                 shiny::conditionalPanel(
                                                                                                                   condition = "input.specify_office == 1",
                                                                                                                   shiny::numericInput(inputId = "electricity_office",
                                                                                                                                       label = "Electricity (kWh):",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::checkboxInput(inputId = "wtt_electricity", 
                                                                                                                                        label = "Include indirect emissions for electricity", # associated with extracting, refining, and transporting fuels", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%"),
                                                                                                                   shiny::checkboxInput(inputId = "td_electricity", 
                                                                                                                                        label = "Include emissions associated with grid losses for electricity", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%"),
                                                                                                                   shiny::numericInput(inputId = "heat_office",
                                                                                                                                       label = "Heat (kWh):",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::checkboxInput(inputId = "wtt_heat", 
                                                                                                                                        label = "Include indirect emissions for heat/steam", # associated with extracting, refining, and transporting fuels", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%"),
                                                                                                                   shiny::checkboxInput(inputId = "td_heat",
                                                                                                                                        label = "Include emissions associated with grid losses for heat/steam", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%"),
                                                                                                                   shiny::numericInput(inputId = "office_water",
                                                                                                                                       label = "Water:",
                                                                                                                                       value = 0,
                                                                                                                                       width = "41%"),
                                                                                                                   shiny::checkboxInput(inputId = "trt_water", 
                                                                                                                                        label = "Include emissions associated with water treatment for used water", 
                                                                                                                                        value = TRUE, 
                                                                                                                                        width = "20%"),
                                                                                                                   shiny::selectInput("units_water", 
                                                                                                                                      "Units for water:",
                                                                                                                                      c("cubic metres",
                                                                                                                                        "million litres"),
                                                                                                                                        width = "20%")),
                                                                                                                 shiny::splitLayout(shiny::verbatimTextOutput("office_emissions"),
                                                                                                                                    htmltools::h6("tonnes"),
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
                                                                                                                                                        htmltools::h6("tonnes"),
                                                                                                                                                        shiny::actionButton("add_hotel", "Add to Table", class="btn-success"), 
                                                                                                                                                        cellArgs = list(style = "vertical-align: top")))
                                                                                                 )#,
                                                                                                 #shiny::tabPanel("Raw Fuels",
                                                                                                 #                # n = input
                                                                                                 #                # %
                                                                                                 #)
                                                                              )# close tabset panel
                                                          ),# close box1
                                                          #htmltools::br(),
                                                          shinydashboard::box(width = NULL,
                                                                              title = "Emissions Table",
                                                                              status ="success",
                                                                              solidHeader = TRUE,
                                                                              shiny::tableOutput("table_emissions"))#,cellWidths = c("65%", "5%", "30%")
                                                        )))
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
    drive_carbon_calc <- shiny::reactive({ vehicle_emissions(distance = input$drive_KM, vehicle = input$vehicle, units = input$driven_units, num = input$drive_number, fuel = input$driven_gas, car_type = input$size_vehicle, bus_type = input$driven_type, taxi_type = input$taxi_type, include_WTT = input$secondary_vehicles, include_electricity = input$secondary_electric, TD = input$owned_vehicles) })
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
    office_carbon_calc <- shiny::reactive({ office_emissions(specify = input$specify_office, office_num = input$number_office, WFH_num = input$wfh_office, WFH_hours = input$wfh_hours, electricity_kWh = input$electricity_office, heat_kWh = input$heat_office, water_supply = input$office_water, electricity_TD = input$td_electricity, electricity_WTT = input$wtt_electricity, heat_TD = input$td_heat, heat_WTT = input$wtt_heat, water_trt = input$trt_water, water_unit = input$units_water) })
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
