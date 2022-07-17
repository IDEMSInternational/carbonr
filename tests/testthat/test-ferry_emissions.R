context("ferry emissions output")

library(carbonr)

test_that("correct calculations when you edit options on times and round trip", {
  expect_equal(4*ferry_emissions(from = "BEL", to = "BOY"), ferry_emissions(from = "BEL", to = "BOY", round_trip = TRUE, times_journey = 2))
})

test_that("include WTT works successfully", {
  expect_gt(ferry_emissions(from = "BEL", to = "BOY"), ferry_emissions(from = "BEL", to = "BOY", include_WTT = FALSE))
})

test_that("changing transport method works successfully", {
  expect_gt(ferry_emissions(from = "BEL", to = "BOY", type = "Car"), ferry_emissions(from = "BEL", to = "BOY", type = "Average"))
})


test_that("incorrect values gives error", {
  expect_error(ferry_emissions(from = "bel", to = "BOY"))
  expect_error(ferry_emissions(from = "BEL", to = "Bournemouth"))
  expect_error(ferry_emissions(from = "BEL", to = "BOY", via = "PLLL"))
})
