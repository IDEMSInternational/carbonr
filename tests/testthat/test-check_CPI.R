# Start writing tests using testthat syntax
test_that("check_CPI returns correct jurisdictions", {
  # Test for check_CPI() without specifying jurisdiction
  result <- check_CPI()
  expected_result <- unique(cpi_data$Jurisdiction)
  expect_equal(result, expected_result)
})

test_that("check_CPI returns correct years", {
  # Test for check_CPI() with jurisdiction specified
  result <- check_CPI(jurisdiction = "United Kingdom")
  expected_result <- unique(cpi_data %>% dplyr::filter(Jurisdiction == "United Kingdom") %>% dplyr::pull(Year))
  expect_equal(result, expected_result)
})

test_that("check_CPI returns correct years and periods", {
  # Test for check_CPI() with jurisdiction and period specified
  result <- check_CPI(jurisdiction = "Germany", period = TRUE)
  expected_result <- cpi_data %>% dplyr::filter(Jurisdiction == "Germany") %>% dplyr::select(Period, Year)
  expect_equal(result, expected_result)
})
