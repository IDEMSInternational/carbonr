test_that("correct calculations for household vs solo", {
  expect_equal(paper_emissions(paper = 100, paper_WD = 10, units = "kg"), household_emissions(paper = 100, paper_WD = 10, units = "kg"))
  expect_equal(plastic_emissions(PET = 100, PET_WD = 10, units = "kg"), household_emissions(PET = 100, PET_WD = 10, units = "kg"))
  expect_equal(metal_emissions(aluminuim_cans = 100, aluminuim_cans_WD = 10, units = "kg"), household_emissions(aluminuim_cans = 100, aluminuim_cans_WD = 10, units = "kg"))
  expect_equal(electrical_emissions(alkaline_batteries = 100, alkaline_batteries_WD = 10, units = "kg"), household_emissions(alkaline_batteries = 100, alkaline_batteries_WD = 10, units = "kg"))
})

test_that("changing units value alters calculation", {
  expect_gt(household_emissions(glass = 100, units = "tonnes"), household_emissions(glass = 100, units = "kg"))
})