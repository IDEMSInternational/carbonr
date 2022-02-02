context("airports output")

library(airportr)
library(carbonr)

# load airport data
data("airports")
airports <- airports %>% dplyr::select(c(Name, City, IATA))

test_that("correct calculations when you edit options on class and round trip", {
  expect_equal(4*airplane_emissions(from = "BRS", to = "LHR"), airplane_emissions(from = "BRS", to = "LHR", class = "premium"))
  expect_equal(2*airplane_emissions(from = "LAX", to = "LHR"), airplane_emissions(from = "LAX", to = "LHR", round_trip = TRUE))
  expect_equal(8*airplane_emissions(from = "LAX", to = "LHR"), airplane_emissions(from = "LAX", to = "LHR", round_trip = TRUE, class = "first"))
})

