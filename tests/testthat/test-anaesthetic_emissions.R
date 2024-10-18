test_that("default 0 works", {
  expect_gt(anaesthetic_emissions(desflurane = 100), anaesthetic_emissions())  
})
