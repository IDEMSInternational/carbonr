test_that("changing units value alters calculation for water supply", {
  expect_gt(building_emissions(water_supply = 300, water_unit = "million litres"), building_emissions(water_supply = 300))
  expect_gt(building_emissions(water_supply = 300), building_emissions(water_supply = 300, water_trt = FALSE))
})

test_that("specifying emissions with changing parameters works successfully", {
  expect_gt(building_emissions(electricity_kWh = 100), building_emissions(electricity_kWh = 100, electricity_TD = FALSE))
  expect_gt(building_emissions(electricity_kWh = 100), building_emissions(electricity_kWh = 100, electricity_WTT = FALSE))
  expect_gt(building_emissions(heat_kWh = 100), building_emissions(heat_kWh = 100, heat_TD = FALSE))
  expect_gt(building_emissions(heat_kWh = 100), building_emissions(heat_kWh = 100, heat_WTT = FALSE))  
})
