library(carbonr)

test_that("correct calculations when editing number of people", {
  expect_equal(10*office_emissions(specify = TRUE, electricity_kwh = 100, num_people = 1), office_emissions(specify = TRUE, electricity_kwh = 100, num_people = 10))
  expect_equal(10*office_emissions(specify = FALSE, num_people = 1), office_emissions(specify = FALSE, num_people = 10))
})

test_that("changing units value alters calculation", {
  expect_gt(office_emissions(specify = TRUE, electricity_kwh = 300, natural_gas = 100, natural_gas_units = "tonnes"), office_emissions(specify = TRUE, electricity_kwh = 300, natural_gas = 100))
})
