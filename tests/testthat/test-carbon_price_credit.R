# Load required libraries
library(carbonr)

test_that("carbon_price_credit handles invalid input correctly", {
  # Test case 2: Check if an warning is thrown when both jurisdiction and manual_value are given
  expect_warning(carbon_price_credit("Australia", manual_price = 100, co2e_val = 50))
  
  # Test case 3: Check if an error is thrown when only co2e is given
  expect_error(carbon_price_credit(co2e_val = 50))
  
  # Test case 4: Check if an error is thrown when no data is available for the specified year (2022) for United Kingdom
  expect_error(carbon_price_credit("United Kingdom", 2000, 1, co2e_val = 50))
  
  # Test case 5: Check if a warning is issued when no year is specified and the most recent year (2021) is used for Germany
  expect_warning(carbon_price_credit("Germany", co2e_val = 100))
}) 
