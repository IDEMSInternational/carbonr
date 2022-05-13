context("testing shiny functions")

test_that("NULL object if 0 numeric inputs are given", {
  expect_null(add_inputs(numeric_input = 0, label = "Label", value = "Value"))
})

test_that("returned object is shiny.tag.list", {
  expect_equal(class(add_inputs(numeric_input = 1, label = "Label", value = "Value")), c("shiny.tag.list", "list"))
})

numeric_input <- 2
add_input_output <- add_inputs(numeric_input = numeric_input, label = "Label", value = "Value")

test_that("new name of object increases with numeric_input box", {
  expect_equal(stringr::str_detect(as.character(add_input_output), paste0("via_", numeric_input, "-label")), TRUE)
})