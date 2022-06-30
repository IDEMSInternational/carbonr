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
                                                                                                                                                                           htmltools::h6("tonnes"),
                                                                                                                                                                           shiny::actionButton("add_plane", "Add to Table", class="btn-success"), 
                                                                                                                                                                           cellArgs = list(style = "vertical-align: top")),
                                                                                                                 ),
                                                                                                                 shinydashboard::box(width = NULL,
                                                                                                                                     shiny::textInput(inputId = "airportname", 
                                                                                                                                                      label = "Check Airport Code:", 
                                                                                                                                                      value = "London Heathrow Airport"),
                                                                                                                                     htmltools::p("Airports with similar names:"),
                                                                                                                                     shiny::tableOutput("flight_name_check")), # close box
                                                                                                                 cellWidths = c("40%", "60%"))) # close Flights panel

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

  }
  return(shiny::shinyApp(ui, server))
}