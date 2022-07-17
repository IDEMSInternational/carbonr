library(airportr)
library(carbonr)

# load airport data
data("airports")
airports <- airports %>% dplyr::select(c(Name, City, IATA))

test_that("correct calculations when you edit options on class and round trip", {
  expect_lt(airplane_emissions(from = "BRS", to = "LHR", class = "Economy class"), airplane_emissions(from = "BRS", to = "LHR", class = "Business class"))
  expect_equal(2*airplane_emissions(from = "LAX", to = "LHR"), airplane_emissions(from = "LAX", to = "LHR", round_trip = TRUE))
})

# checking errors
test_that("check an error arises for typos", {
  expect_error(airplane_emissions(from = "NBO", to = "LHRR"))
  expect_error(airplane_emissions(from = "Nairobi Airport", to = "LHR"))
  expect_error(airplane_emissions(from = "NBO", to = "LHR", via = ""))
  expect_error(airplane_emissions(from = "NBO", to = "LHR", via = "AMMS"))
})

# via option
test_that("via option", {
  expect_gt(airplane_emissions(from = "NBO", to = "LHR", via = "AMS"), airplane_emissions(from = "NBO", to = "LHR"))
})

# WTT option
test_that("via option", {
  expect_gt(airplane_emissions(from = "NBO", to = "LHR"), airplane_emissions(from = "NBO", to = "LHR", include_WTT = FALSE))
})