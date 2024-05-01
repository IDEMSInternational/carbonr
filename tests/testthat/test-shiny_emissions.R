context("testing shiny emissions app")

# Helper function to check if the returned value is a Shiny app
is_shiny_app <- function(x) {
  inherits(x, "shiny.appobj")
}

# Test to ensure that shiny_emissions function executes and returns a Shiny app
test_that("shiny_emissions launches a Shiny app", {
  # Call the shiny_emissions function
  app <- shiny_emissions()
  
  # Check if the output is a Shiny app object
  expect_true(is_shiny_app(app))
})