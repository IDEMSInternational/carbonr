test_that("correct calculations when editing number of people", {
  expect_equal(10*raw_fuels(propane = 1000), raw_fuels(propane = 1000, num_people = 10))
})

test_that("changing units value alters calculation", {
  expect_gt(raw_fuels(propane = 100, propane_units = "tonnes"), raw_fuels(propane = 100))
  expect_gt(raw_fuels(butane = 100, butane_units = "tonnes"), raw_fuels(butane = 100))
})
