library(carbonr)

test_that("correct calculations when editing number of people", {
  expect_equal(10*office_emissions(), office_emissions(num_people = 10))
})
