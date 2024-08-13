library(carbonr)

test_that("correct calculations for industrial vs solo", {
  expect_equal(paper_emissions(paper = 100, paper_WD = 10, units = "kg"), material_emissions(paper = 100, paper_WD = 10, paper_units = "kg"))
  expect_equal(plastic_emissions(PET = 100, PET_WD = 10, units = "kg"), material_emissions(PET = 100, PET_WD = 10, plastic_units = "kg"))
  expect_equal(metal_emissions(aluminuim_cans = 100, aluminuim_cans_WD = 10, units = "kg"), material_emissions(aluminuim_cans = 100, aluminuim_cans_WD = 10, metal_units = "kg"))
  expect_equal(electrical_emissions(alkaline_batteries = 100, alkaline_batteries_WD = 10, units = "kg"), material_emissions(alkaline_batteries = 100, alkaline_batteries_WD = 10, electrical_units = "kg"))
  expect_equal(construction_emissions(metals = 100, metals_WD = 10, units = "kg"), material_emissions(metals = 100, metals_WD = 10, metal_units = "kg"))
})

test_that("changing units value alters calculation", {
  expect_gt(construction_emissions(metals = 100, units = "tonnes"), construction_emissions(metals = 100, units = "kg"))
})