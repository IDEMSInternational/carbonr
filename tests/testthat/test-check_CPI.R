library(carbonr)

# Load the dataset or create a dummy dataset for testing
# Replace 'carbon_credits' with the actual name of the dataset
carbon_credits <- data.frame(
  Jurisdiction = c("Jurisdiction A", "Jurisdiction B", "Jurisdiction C"),
  Period = c(1, 2, 3),
  Year = c(2018, 2019, 2020)
)

# Start writing tests using testthat syntax
test_that("valid_jurisdictions returns correct jurisdictions", {
  # Test for valid_jurisdictions() without specifying jurisdiction
  result <- valid_jurisdictions()
  expected_result <- unique(carbon_credits$Jurisdiction)
  expect_equal(result, expected_result)
})

test_that("valid_jurisdictions returns correct years", {
  # Test for valid_jurisdictions() with jurisdiction specified
  result <- valid_jurisdictions(jurisdiction = "Jurisdiction A")
  expected_result <- unique(carbon_credits %>% filter(Jurisdiction == "Jurisdiction A") %>% pull(Year))
  expect_equal(result, expected_result)
})

test_that("valid_jurisdictions returns correct years and periods", {
  # Test for valid_jurisdictions() with jurisdiction and period specified
  result <- valid_jurisdictions(jurisdiction = "Jurisdiction B", period = TRUE)
  expected_result <- carbon_credits %>% filter(Jurisdiction == "Jurisdiction B") %>% select(Period, Year)
  expect_equal(result, expected_result)
})
