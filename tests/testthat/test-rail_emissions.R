context("rail emissions output")

library(carbonr)

test_that("correct calculations when you edit options on times and round trip", {
  expect_equal(4*rail_emissions("Southampton Central", "Manchester Piccadilly"), rail_emissions("Southampton Central", "Manchester Piccadilly", round_trip = TRUE, times_journey = 2))
})

test_that("incorrect values gives error", {
  expect_error(rail_emissions(from = "Southampton", to = "Manchester Piccadilly"))
  expect_error(rail_emissions(from = "Southampton Central", to = "London Victoria"))
  expect_error(rail_emissions(from = "Southampton Central", to = "Paddington", via = c("Reading")))
})
