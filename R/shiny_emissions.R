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
                                                                                                                                                        shiny::splitLayout(shiny::verbatimTextOutput("train_emissions"), htmltools::h6("emissions"), shiny::actionButton("add_train", "Add to Table", class="btn-success"), cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "trainname", label = "Check Train Station:", value = "Bristol"),
                                                                                                                                     htmltools::p("Train Stations with similar names:"),
                                                                                                                                     shiny::tableOutput("train_name_check")), # close box
                                                                                                                 cellWidths = c("40%", "60%"))), # close Flights panel
                                                                                                 shiny::tabPanel("Office",
                                                                                                                 # n = input
                                                                                                                 # %
                                                                                                 ), # close N panel
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
                                                                                                                                                                                     "Battery electric" = "battery electric"))),
                                                                                                                                       shiny::conditionalPanel(condition = "input.vehicle == 'van'",
                                                                                                                                                               shiny::radioButtons("driven_gas", "Fuel Type:", c("Unleaded gasoline" = "petrol",
                                                                                                                                                                                                                 "Diesel" = "diesel",
                                                                                                                                                                                                                 "Battery electric" = "battery electric"))),
                                                                                                                                     ),
                                                                                                                                     shiny::conditionalPanel(
                                                                                                                                       condition = "input.vehicle == 'bus'",
                                                                                                                                       shiny::radioButtons("driven_type", 
                                                                                                                                                           "Type:", 
                                                                                                                                                           c("Average" = "average", 
                                                                                                                                                             "Local (London)" = "local_L", 
                                                                                                                                                             "Local (Not London)" = "local_nL", 
                                                                                                                                                             "Local" = "local")),
                                                                                                                                     ),
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
                                                                                                                                     shiny::numericInput(inputId = "drive_KM", label = "Distance driven:", value = "", width = "41%"),
                                                                                                                                     shiny::splitLayout(shiny::verbatimTextOutput("driven_emissions"), htmltools::h6("emissions"), shiny::actionButton("add_drive", "Add to Table", class="btn-success"), 
                                                                                                                                                        cellArgs = list(style = "vertical-align: top")),
                                                                                                                 )),
                                                                                                 shiny::tabPanel("Ferry",
                                                                                                                 # n = input
                                                                                                                 # %
                                                                                                 ),
                                                                                                 shiny::tabPanel("Hotels",
                                                                                                                 # n = input
                                                                                                                 # %
                                                                                                 ),
                                                                                                 shiny::tabPanel("Raw Fuels",
                                                                                                                 # n = input
                                                                                                                 # %
                                                                                                 )
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
      airplane_emissions(from = input$flightfrom, to = input$flightto, via = C_P, class = input$flightclass, num_people = input$numberflying, radiative_force = input$radiative, round_trip = input$roundtrip_plane)
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
      rail_emissions(from = input$trainfrom, to = input$trainto, via = C, num_people = input$numbertrain, times_journey = input$timestrain, round_trip = input$roundtrip_train)
    })
    output$train_emissions <- shiny::renderText({ train_carbon_calc() })
    
    
    # Distance driven (car) -------------------------------
    #shiny::observeEvent(input$chk_mpg, {
    #  if(input$chk_mpg){
    #    shinyjs::enable("drive_mpg")
    #  }else{
    #    shinyjs::disable("drive_mpg")
    #  }
    #})
    
    drive_carbon_calc <- shiny::reactive({
      #  vehicle_emissions(distance = input$drive_KM,
      #                    vehicle = input$vehicle,
      #                    units = input$driven_units,
      #                    fuel = input$driven_gas,
      #                    size = input$size_vehicle,
      #                    type = input$driven_type,
      #                    taxi_type = input$taxi_type)
    })
    
    output$driven_emissions <- shiny::renderText({
      #  drive_carbon_calc()
    })
    
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
    shiny::observeEvent(input$add_plane, {
      if (input$add_plane > 0) {
        df$data <- rbind(df$data, carbon_calc())
        names(df$data) <- "Emissions"
      }
    })
    shiny::observeEvent(input$add_train, {
      if (input$add_train > 0) {
        df$data <- rbind(df$data, train_carbon_calc())
        names(df$data) <- "Emissions"
      }
    })
    shiny::observeEvent(input$add_drive, {
      if (input$add_drive > 0) {
        df$data <- rbind(df$data, drive_carbon_calc())
        names(df$data) <- "Emissions"
      }
    })
    output$table_emissions <- shiny::renderTable(df$data)
  }
  return(shiny::shinyApp(ui, server))
}