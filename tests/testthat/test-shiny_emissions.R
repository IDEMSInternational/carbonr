context("testing shiny app")

test_that("returned object is shiny.appobj", {
  expect_equal(class(shiny_emissions()), c("shiny.appobj"))
})
