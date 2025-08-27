# Sample data
data <- data.frame(
  time = as.Date(c("2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01")),
  theatre = c("A", "A", "B", "B"),
  emissions = c(100, 150, 200, 250),
  carbon_price_credit = c(10, 15, 20, 25)
)

output <- suppressWarnings(output_display(data = data, gti_by = "default", pdf = TRUE))
output1 <- suppressWarnings(output_display(data = data, gti_by = "month", pdf = TRUE))
output2 <- suppressWarnings(output_display(data = data, gti_by = "year", pdf = TRUE))

test_that("output_display generates gg/ggplot object", {
  expect_true(any(c("gg", "ggplot") %in% class(output)))
  expect_true(any(c("gg", "ggplot") %in% class(output1)))
  expect_true(any(c("gg", "ggplot") %in% class(output2)))
})
