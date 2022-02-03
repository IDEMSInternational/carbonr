context("seaport finder check")

library(carbonr)

# load airport data
finder_typo <- seaport_finder(country = "United", city = "borunemouth", ignore.case = TRUE)
finder_port <- seaport_finder(port_code = "LIL", ignore.case = TRUE)

test_that("correct output", {
  expect_equal(finder_typo$country, "United Kingdom")
  expect_equal(finder_typo$city, "Bournemouth")
  expect_equal(finder_typo$port_code, "BOH")
  expect_equal(finder_port$country, "Norway")
})
