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

test_that("happy path: water+elec+heat (kg), TD+WTT included", {
  got <- building_emissions(
    water_supply = 10, water_unit = "cubic metres", water_trt = TRUE,
    electricity_kWh = 100, electricity_TD = TRUE, electricity_WTT = TRUE,
    heat_kWh = 50, heat_TD = TRUE, heat_WTT = TRUE,
    units = "kg", value_col = "value"
  )
  # water: 10*(0.5+0.2)=7
  # elec : 100*(0.20+0.03+0.05+0.01)=29
  # heat : 50*(0.10+0.02+0.03)=7.5
  expect_equal(got, 40.7398)
})

test_that("units and value_col work (tonnes, 2024)", {
  got <- building_emissions(
    water_supply = 1, water_unit = "cubic metres", water_trt = TRUE,
    electricity_kWh = 0, heat_kWh = 0,
    value_col = "value_2024", units = "tonnes"
  )
  expect_equal(got, 0.00033885)
})

test_that("electricity toggles: TD off, WTT on; and TD on, WTT off", {
  # TD OFF, WTT generation ON
  got1 <- building_emissions(
    electricity_kWh = 10, electricity_TD = FALSE, electricity_WTT = TRUE,
    heat_kWh = 0, water_supply = 0, units = "kg"
  )
  expect_equal(got1, 2.229)
  
  # TD ON, WTT OFF
  got2 <- building_emissions(
    electricity_kWh = 10, electricity_TD = TRUE, electricity_WTT = FALSE,
    heat_kWh = 0, water_supply = 0, units = "kg"
  )
  expect_equal(got2, 1.9553)
})

test_that("heat toggles: TD off/on, WTT off/on", {
  got1 <- building_emissions(heat_kWh = 20, heat_TD = FALSE, heat_WTT = TRUE,  water_supply = 0, electricity_kWh = 0)
  expect_equal(got1, 4.8422)
  
  got2 <- building_emissions(heat_kWh = 20, heat_TD = TRUE,  heat_WTT = FALSE, water_supply = 0, electricity_kWh = 0)
  expect_equal(got2, 3.6948)
})

test_that("million litres UOM is respected", {
  emissions_1 <- uk_gov_data |>
    dplyr::filter(`Level 1` == "Water supply",
                  `UOM` == "million litres")
  
  got <- building_emissions(
    water_supply = 0.002, water_unit = "million litres", water_trt = FALSE,
    electricity_kWh = 0, heat_kWh = 0, units = "kg"
  )
  expect_equal(got, 0.002 * emissions_1$value)
})

test_that("strict=FALSE zero-fills missing factors", {
  got <- building_emissions(
    water_supply = 10, water_unit = "cubic metres", water_trt = TRUE,
    electricity_kWh = 10, electricity_TD = TRUE, electricity_WTT = TRUE,
    heat_kWh = 20, heat_TD = TRUE, heat_WTT = TRUE,
    strict = FALSE, units = "kg"
  )
  # water: 10*(0.5 + 0) = 5
  # elec : 10*(0.20 + 0 + 0) = 2
  # heat : 20*(0.10 + 0 + 0) = 2
  expect_equal(got, 11.107)
})
