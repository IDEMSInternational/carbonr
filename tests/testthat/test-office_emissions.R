test_that("correct calculations when editing hours WFH", {
  expect_equal(10*office_emissions(specify = TRUE, WFH_hours = 1), office_emissions(specify = TRUE, WFH_hours = 10))
  expect_equal(office_emissions(specify = TRUE, WFH_hours = 1, WFH_num = 10), office_emissions(specify = TRUE, WFH_hours = 10))
  expect_equal(10*office_emissions(specify = FALSE, office_num = 1), office_emissions(specify = FALSE, office_num = 10))
})

test_that("changing units value alters calculation for water supply", {
  expect_gt(office_emissions(specify = TRUE, water_supply = 300, water_unit = "million litres"), office_emissions(specify = TRUE, water_supply = 300))
  expect_gt(office_emissions(specify = TRUE, water_supply = 300), office_emissions(specify = TRUE, water_supply = 300, water_trt = FALSE))
})

test_that("specifying emissions with changing parameters works successfully", {
  expect_gt(office_emissions(specify = TRUE, electricity_kWh = 100), office_emissions(specify = TRUE, electricity_kWh = 100, electricity_TD = FALSE))
  expect_gt(office_emissions(specify = TRUE, electricity_kWh = 100), office_emissions(specify = TRUE, electricity_kWh = 100, electricity_WTT = FALSE))
  expect_gt(office_emissions(specify = TRUE, heat_kWh = 100), office_emissions(specify = TRUE, heat_kWh = 100, heat_TD = FALSE))
  expect_gt(office_emissions(specify = TRUE, heat_kWh = 100), office_emissions(specify = TRUE, heat_kWh = 100, heat_WTT = FALSE))  
})