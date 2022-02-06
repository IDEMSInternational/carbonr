library(carbonr)

test_that("correct calculations when editing number of people", {
  expect_equal(10*raw_fuels(electricity_kwh = 10), raw_fuels(electricity_kwh = 10, num_people = 10))
})

test_that("changing units value alters calculation", {
  expect_gt(raw_fuels(electricity_kwh = 0, propane = 100, propane_units = "tonnes"), raw_fuels(electricity_kwh = 0, propane = 100))
  expect_gt(raw_fuels(electricity_kwh = 0, butane = 100, butane_units = "tonnes"), raw_fuels(electricity_kwh = 0, butane = 100))
})
