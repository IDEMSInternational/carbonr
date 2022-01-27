context("airports output")

library(airportr)
library(carbonr)

# load airport data
data("airports")
airports <- airports %>% dplyr::select(c(Name, City, IATA))

test_that("correct calculations when you add people/trips", {
  expect_equal(2*airplane_emissions(from = "LAX", to = "LHR"), airplane_emissions(from = "LAX", to = "LHR", round_trip = TRUE))
})