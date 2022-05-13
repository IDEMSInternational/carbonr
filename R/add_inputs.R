#' Create multiple textInput functions in Shiny
#'
#' @description For use in the `shiny_emissions()` function. Adding an unknown quantity of textInputs.
#' 
#' @param numeric_input Name of numerical input that controls the number of items to add.
#' @param label Label of new textInput.
#' @param value Value of new textInput.
#'
#' @return 
#' @export
#'
#' @examples
#' ui <- shinydashboard::dashboardPage(header = shinydashboard::dashboardHeader(),
#'                                     sidebar = shinydashboard::dashboardSidebar(),
#'                                     shinydashboard::dashboardBody(
#'                                     shiny::fluidRow(
#'                                     shiny::column(12, align = "left",
#'                                     shiny::splitLayout(shinydashboard::box(width = NULL,
#'                                     shiny::numericInput("newbox_add",
#'                                                         "Number of new boxes:",
#'                                                         value = 0, min = 0),
#'                                     shiny::uiOutput("newbox_input")))))))
#' server <- function(input, output) {
#'   K_plane <- shiny::reactive({ input$newbox_add })
#'   output$newbox_input <- shiny::renderUI({ add_inputs(numeric_input = K_plane(),
#'                                                       label = "New Box:",
#'                                                       value = "textbox") })
#' }
#' ## NOT RUN ##
#' # shiny::shinyApp(ui, server)
add_inputs <- function(numeric_input, label, value){
  if (numeric_input == 0){
    L_P = 0
    output1 = NULL
  } else {
    L_P = sapply(1:numeric_input, function(i){paste0("via_",i)})
    output1 = htmltools::tagList()
    for(i in seq_along(1:numeric_input)){
      output1[[i]] = htmltools::tagList()
      output1[[i]][[1]] = shiny::textInput(L_P[i], label = label, value = value)
    }
  }
  output1
}