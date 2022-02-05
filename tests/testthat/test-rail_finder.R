context("train station finder")

library(carbonr)

# load station data
finder_typo <- rail_finder(station = "Coventry")
finder_port <- rail_finder(station_code = "LHS")

test_that("correct output", {
  expect_equal(finder_typo$region, "West Midlands")
  expect_equal(finder_typo$district, "Coventry")
})

test_that("works with multiple entries"){
  expect_equal(rail_finder(region = "West Midlands", district = "Coventry", county = "West Midlands")$station = "Coventry")
})
