library(carbonr)

test_that("correct calculations when editing distance", {
  expect_equal(10*land_emissions(distance = 1), land_emissions(distance = 10))
})

test_that("some parameters do not affect calculations for certain vehicles", {
  expect_equal(land_emissions(distance = 100, vehicle = "Bus", owned_by_org = TRUE), land_emissions(distance = 100, vehicle = "Bus", owned_by_org = FALSE))
  expect_equal(land_emissions(distance = 100, vehicle = "Coach", owned_by_org = TRUE), land_emissions(distance = 100, vehicle = "Coach", owned_by_org = FALSE))
  expect_equal(land_emissions(distance = 100, vehicle = "Taxis", owned_by_org = TRUE), land_emissions(distance = 100, vehicle = "Taxis", owned_by_org = FALSE))
  expect_equal(land_emissions(distance = 100, vehicle = "Cars", include_electricity = TRUE), land_emissions(distance = 100, vehicle = "Cars", include_electricity = FALSE))
  expect_equal(land_emissions(distance = 100, vehicle = "Cars", fuel = "Petrol", include_electricity = TRUE), land_emissions(distance = 100, vehicle = "Car", fuel = "Petrol", include_electricity = FALSE))
})

test_that("changing size option alters calculation", {
  expect_gt(land_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Large"), land_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Small"))
  expect_gt(land_emissions(distance = 100, vehicle = "Cars", car_type = "Large car"), land_emissions(distance = 100, vehicle = "Cars", car_type = "Small car"))
})

test_that("changing `num` option alters calculation", {
  expect_equal(land_emissions(distance = 100, num = 2, vehicle = "Motorbike", bike_type = "Large"), 2*land_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Large"))
})

test_that("more emissions are released at 100 miles than 100km", {
  expect_gt(land_emissions(distance = 100, units = "miles"), land_emissions(distance = 100, units = "km"))
})

test_that("bus works when bus_type is altered", {
  expect_gt(land_emissions(distance = 100, vehicle = "Bus", bus_type = "Local bus (not London)"), land_emissions(distance = 100, vehicle = "Bus", bus_type = "Local London bus"))
})

test_that("coach works when an unrelated parameter is altered", {
  expect_equal(land_emissions(distance = 100, vehicle = "Coach", bus_type = "Local bus (not London)"), land_emissions(distance = 100, vehicle = "Coach", bus_type = "Local London bus"))
})

test_that("Battery Electric Vehicle changes when parameters are altered", {
  expect_gt(land_emissions(distance = 100, fuel = "Battery Electric Vehicle", TD = TRUE), land_emissions(distance = 100, fuel = "Battery Electric Vehicle", TD = FALSE))
  expect_gt(land_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_WTT = TRUE), land_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_WTT = FALSE))
  expect_gt(land_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_electricity = TRUE), land_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_electricity = FALSE))
})