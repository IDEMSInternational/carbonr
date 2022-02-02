context("ferry emissions output")

library(carbonr)

test_that("correct calculations when you edit options on times and round trip", {
  expect_equal(4*ferry_emissions(from = "BEL", to = "BOY"), ferry_emissions(from = "BEL", to = "BOY", round_trip = TRUE, times_journey = 2))
})

