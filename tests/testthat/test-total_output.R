library(carbonr)

# Sample data
data <- data.frame(
  time = as.Date(c("2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01")),
  theatre = c("A", "A", "B", "B"),
  carbon_price_credit = c(100, 150, 200, 250)
)

test_that("total_output plots correctly for default settings", {
  # Expected plot
  expected_plot <- ggplot2::ggplot(data, ggplot2::aes(x = time, y = carbon_price_credit, group = theatre, colour = theatre)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars(theatre)) +
    ggplot2::theme_bw()
  
  # Test plot
  test_plot <- total_output(data)
  
  # Compare plots
  expect_equal(expected_plot$facet, test_plot$facet)
})

# Sample data
data <- data.frame(
  time = as.Date(c("2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01")),
  theatre = c("A", "A", "B", "B"),
  carbon_price_credit = c(100, 150, 200, 250)
)

test_that("total_output plots correctly for month grouping", {
  # Expected plot
  expected_plot <- ggplot2::ggplot(data %>% dplyr::mutate(time = lubridate::month(time)), ggplot2::aes(x = time, y = carbon_price_credit, group = theatre, colour = theatre)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars(theatre)) +
    ggplot2::theme_bw()
  
  # Test plot
  test_plot <- total_output(data, plot_by = "month")
  
  # Compare plots
  expect_equal(expected_plot$facet, test_plot$facet)
})

# Sample data
data <- data.frame(
  time = as.Date(c("2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01")),
  theatre = c("A", "A", "B", "B"),
  carbon_price_credit = c(100, 150, 200, 250)
)

test_that("total_output plots correctly for year grouping", {
  # Expected plot
  expected_plot <- ggplot2::ggplot(data %>% dplyr::mutate(time = lubridate::year(time)), ggplot2::aes(x = time, y = carbon_price_credit, group = theatre, colour = theatre)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars(theatre)) +
    ggplot2::theme_bw()
  
  # Test plot
  test_plot <- total_output(data, plot_by = "year")
  
  # Compare plots
  expect_equal(expected_plot$facet, test_plot$facet)
})
