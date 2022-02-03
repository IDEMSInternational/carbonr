context("airport finder")

library(carbonr)

# load station data
finder_typo <- airport_finder(name = "Exter", country = "United Kingdom")
finder_port <- airport_finder(IATA_code = "LHS")

test_that("correct output", {
  expect_equal(finder_typo$City, "Exeter")
  expect_equal(finder_typo$IATA, "EXT")
  expect_equal(finder_port$Name, "Las Heras Airport")
})
