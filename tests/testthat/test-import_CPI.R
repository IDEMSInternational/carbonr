library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

# Assuming you have a test Excel file located in your test directory called "test_CPI_Data.xlsx"
path_to_test_file <- "tests/testthat/testdata/CPI_Data_DashboardExtract.xlsx"

test_data <- import_CPI(path = path_to_test_file, sheet = "Data_Price", skip = 2)

test_that("import_CPI returns a dataframe with correct structure and data", {
  # Check if the output is a dataframe
  expect_true(is.data.frame(test_data))

  # Check for correct columns in the dataframe
  expected_columns <- c("Jurisdiction", "Period", "Year", "Price ($)")
  expect_true(all(expected_columns %in% names(test_data)))
  
  # Here, check that only ETS instruments are included

  # Check the Year and Period transformations
  expect_true(all(!is.na(as.numeric(test_data$Year))))
  expect_true(all(!is.na(as.numeric(test_data$Period))))
  
  # Check for non-NA prices
  expect_false(any(is.na(test_data$`Price ($)`)))
})
