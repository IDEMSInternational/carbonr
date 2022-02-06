library(carbonr)

test_that("correct calculations when editing distance", {
  expect_equal(10*vehicle_emissions(distance = 1), vehicle_emissions(distance = 10))
})

test_that("changing size option alters calculation", {
  expect_gt(vehicle_emissions(distance = 100, vehicle = "motorbike", size = "large"), vehicle_emissions(distance = 100, vehicle = "motorbike", size = "small"))
  expect_gt(vehicle_emissions(distance = 100, vehicle = "car", size = "large"), vehicle_emissions(distance = 100, vehicle = "car", size = "small"))
  expect_gt(vehicle_emissions(distance = 100, vehicle = "van", size = "large"), vehicle_emissions(distance = 100, vehicle = "van", size = "small"))
})

test_that("changing `num` option alters calculation", {
  expect_equal(vehicle_emissions(distance = 100, num = 2, vehicle = "van", size = "large"), 2*vehicle_emissions(distance = 100, vehicle = "van", size = "large"))
})

test_that("more emissions are released at 100 miles than 100km", {
  expect_gt(vehicle_emissions(distance = 100, units = "miles"), vehicle_emissions(distance = 100, units = "km"))
})

test_that("van works with an incorrectly specified fuel", {
  expect_warning(vehicle_emissions(distance = 100, vehicle = "van", fuel = "hybrid electric"))
})

test_that("bus works when bus_type is altered", {
  expect_gt(vehicle_emissions(distance = 100, vehicle = "bus", bus_type = "local not London"), vehicle_emissions(distance = 100, vehicle = "bus", bus_type = "average"))
})

test_that("coach works when an unrelated parameter is altered", {
  expect_equal(vehicle_emissions(distance = 100, vehicle = "coach", bus_type = "local not London"), vehicle_emissions(distance = 100, vehicle = "coach", bus_type = "average"))
})
