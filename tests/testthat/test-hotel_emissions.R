context("hotel emissions output")

library(carbonr)

test_that("calculations are correct when you edit options on hotel emissions", {
  expect_equal(4*hotel_emissions(location = "UK"), hotel_emissions(location = "UK", nights = 4))
  expect_equal(16*hotel_emissions(location = "UK"), hotel_emissions(location = "UK", nights = 4, rooms = 4))
})

test_that("error function for incorrect locations", {
  expect_error(hotel_emissions(location = "uk"))
})
