test_that("correct calculations when editing distance", {
  expect_equal(10*vehicle_emissions(distance = 1), vehicle_emissions(distance = 10))
})

test_that("some parameters do not affect calculations for certain vehicles", {
  expect_equal(vehicle_emissions(distance = 100, vehicle = "Cars", include_electricity = TRUE), vehicle_emissions(distance = 100, vehicle = "Cars", include_electricity = FALSE))
  expect_equal(vehicle_emissions(distance = 100, vehicle = "Cars", fuel = "Petrol", include_electricity = TRUE), vehicle_emissions(distance = 100, vehicle = "Car", fuel = "Petrol", include_electricity = FALSE))
})

test_that("changing size option alters calculation", {
  expect_gt(vehicle_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Large"), vehicle_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Small"))
  expect_gt(vehicle_emissions(distance = 100, vehicle = "Cars", car_type = "Large car"), vehicle_emissions(distance = 100, vehicle = "Cars", car_type = "Small car"))
})

test_that("changing `num` option alters calculation", {
  expect_equal(vehicle_emissions(distance = 100, num = 2, vehicle = "Motorbike", bike_type = "Large"), 2*vehicle_emissions(distance = 100, vehicle = "Motorbike", bike_type = "Large"))
})

test_that("more emissions are released at 100 miles than 100km", {
  expect_gt(vehicle_emissions(distance = 100, units = "miles"), vehicle_emissions(distance = 100, units = "km"))
})

test_that("Battery Electric Vehicle changes when parameters are altered", {
  expect_gt(vehicle_emissions(distance = 100, fuel = "Battery Electric Vehicle", TD = TRUE), vehicle_emissions(distance = 100, fuel = "Battery Electric Vehicle", TD = FALSE))
  expect_gt(vehicle_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_WTT = TRUE), vehicle_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_WTT = FALSE))
  expect_gt(vehicle_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_electricity = TRUE), vehicle_emissions(distance = 100, fuel = "Battery Electric Vehicle", include_electricity = FALSE))
})
