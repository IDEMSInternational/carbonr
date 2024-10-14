test_that("tonnes and kg parameter works for wet_clinical_waste", {
  expect_gt(clinical_theatre_emissions(wet_clinical_waste = 100), clinical_theatre_emissions(wet_clinical_waste = 100, wet_clinical_waste_unit = "kg"))  
})
