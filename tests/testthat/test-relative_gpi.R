library(carbonr)
# Sample data
data <- data.frame(
  time = as.Date(c("2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01")),
  theatre = c("A", "A", "B", "B"),
  emissions = c(100, 150, 200, 250)
)

test_that("relative_gti plots correctly for default settings", {
  # Expected plot
  expected_plot <- ggplot2::ggplot(data,ggplot2::aes(x = time, y = pct_change, group = theatre, colour = theatre)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars(theatre)) +
    ggplot2::theme_bw()
  
  # Test plot
  test_plot <- relative_gti(data)
  
  # Compare plots
  expect_equal(expected_plot$facet, test_plot$facet)
})

test_that("relative_gti plots correctly for month grouping", {
  # Expected plot
  expected_plot <- ggplot2::ggplot(data %>% dplyr::mutate(time = lubridate::month(time)),ggplot2::aes(x = time, y = pct_change, group = theatre, colour = theatre)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars(theatre)) +
    ggplot2::theme_bw()
  
  # Test plot
  test_plot <- relative_gti(data, gti_by = "month")
  
  # Compare plots
  expect_equal(expected_plot$facet, test_plot$facet)
})

test_that("relative_gti plots correctly for year grouping", {
  # Sample data
  data <- data.frame(
    time = as.Date(c("2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01")),
    theatre = c("A", "A", "B", "B"),
    emissions = c(100, 150, 200, 250)
  )
  
  # Expected plot
  expected_plot <- ggplot2::ggplot(data %>% dplyr::mutate(time = lubridate::year(time)),ggplot2::aes(x = time, y = pct_change, group = theatre, colour = theatre)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars(theatre)) +
    ggplot2::theme_bw()
  
  # Test plot
  test_plot <- relative_gti(data, gti_by = "year")
  
  # Compare plots
  expect_equal(expected_plot$facet, test_plot$facet)
})
