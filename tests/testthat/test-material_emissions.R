test_that("wrapper parity with solo calculators (vector-first, waste flags)", {
  # PAPER
  solo_paper <- paper_emissions(
    use = c(paper = 100),
    waste = TRUE,
    waste_disposal = "Closed-loop",
    units = "kg",
    strict = FALSE
  )
  wrap_paper <- material_emissions(
    paper_use = c(paper = 100),
    paper_waste = TRUE,
    paper_waste_disposal = "Closed-loop",
    units = "kg",
    strict = FALSE
  )
  expect_equal(solo_paper, wrap_paper)
  
  # PLASTIC
  solo_plastic <- plastic_emissions(
    use = c(pet = 100),
    waste = TRUE,
    waste_disposal = "Landfill",
    strict = FALSE,
    units = "kg"
  )
  wrap_plastic <- material_emissions(
    plastic_use = c(pet = 100),
    plastic_waste = TRUE,
    plastic_waste_disposal = "Landfill",
    strict = FALSE,
    units = "kg"
  )
  expect_equal(solo_plastic, wrap_plastic)
  
  # METAL (Primary for use; Landfill for WD)
  solo_metal <- metal_emissions(
    use = c(aluminium = 100),
    material_production = "Primary material production",
    waste = TRUE,
    waste_disposal = "Landfill",
    units = "kg"
  )
  wrap_metal <- material_emissions(
    metal_use = c(aluminium = 100),
    metal_material_production = "Primary material production",
    metal_waste = TRUE,
    metal_waste_disposal = "Landfill",
    units = "kg"
  )
  expect_equal(solo_metal, wrap_metal)
  
  # ELECTRICAL (Alkaline batteries; WD comes from WEEE 'Batteries')
  solo_elec <- electrical_emissions(
    use = c(alkaline_batteries = 100),
    waste = TRUE,
    waste_disposal = "Landfill",
    units = "kg"
  )
  wrap_elec <- material_emissions(
    electrical_use = c(alkaline_batteries = 100),
    electrical_waste = TRUE,
    electrical_waste_disposal = "Landfill",
    units = "kg"
  )
  expect_equal(solo_elec, wrap_elec)
  
  # CONSTRUCTION (Metals)
  solo_cons <- construction_emissions(
    use = c(metals = 100),
    material_production = "Primary material production",
    waste = TRUE,
    waste_disposal = "Landfill",
    units = "kg"
  )
  wrap_cons <- material_emissions(
    construction_use = c(metals = 100),
    construction_material_production = "Primary material production",
    construction_waste = TRUE,
    construction_waste_disposal = "Landfill",
    units = "kg"
  )
  expect_equal(solo_cons, wrap_cons)
})
