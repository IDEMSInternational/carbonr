context("secondary emissions output")

library(carbonr)

test_that("correct calculations when editing time parameter", {
  expect_equal(secondary_emissions(item = "IT equipment", cost = 1000), 52*secondary_emissions(item = "IT equipment", cost = 1000, time = "per year"))
})
