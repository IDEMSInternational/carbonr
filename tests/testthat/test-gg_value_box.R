library(testthat)

# Define test cases
test_that("gg_value_box creates value box plot correctly", {
  # Test case 1: Check if the function returns a ggplot object
  result <- gg_value_box(values = c(100, 500, 1000),
                         information = c("Sales", "Revenue", "Customers"),
                         icons = c("\U0000f06d", "\U0000f155", "\U0000f0f7"),
                         color = factor(1:3))
  expect_true(inherits(result, "ggplot"))
  
  # Test case 2: Check if the value box has the correct number of elements
  expect_equal(length(result$layers), 4)
  
  # Test case 3: Check if the value box has the correct aesthetics
  expect_true(all(names(result$mapping) %in% c("x", "y", "height", "width", "label", "fill")))
})
