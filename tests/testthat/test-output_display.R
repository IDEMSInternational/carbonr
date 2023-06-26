library(carbonr)
# Sample data
data <- data.frame(
  time = as.Date(c("2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01")),
  theatre = c("A", "A", "B", "B"),
  emissions = c(100, 150, 200, 250),
  carbon_price_credit = c(10, 15, 20, 25)
)

test_that("output_display generates correct plots and layout for default settings", {
})