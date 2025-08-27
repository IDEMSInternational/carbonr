# helper: mock uk_gov_data inside the package namespace
local_uk_gov_data <- function(df, pkg = "carbonr") {
  ns <- asNamespace(pkg)
  testthat::local_mocked_bindings(uk_gov_data = df, .env = ns)
}

test_that("correct calculations for household vs solo (paper/plastic/metal/electrical)", {
  ## PAPER: solo vs household (only paper populated)
  solo_paper <- paper_emissions(
    use = c(paper = 100),
    waste = TRUE,
    material_production = "Primary material production",
    waste_disposal = "Closed-loop",
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  hh_paper <- household_emissions(
    paper_use = c(paper = 100),
    paper_waste = TRUE,
    paper_waste_disposal = "Closed-loop",
    # everything else left empty
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  expect_equal(hh_paper, solo_paper)
  
  ## PLASTIC (PET): solo vs household
  solo_plastic <- plastic_emissions(
    use = c(pet = 100),
    waste = TRUE,
    waste_disposal = "Landfill",
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  hh_plastic <- household_emissions(
    plastic_use = c(pet = 100),
    plastic_waste = TRUE,
    plastic_waste_disposal = "Landfill",
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  expect_equal(hh_plastic, solo_plastic)
  
  ## METAL (aluminium cans & foil): solo vs household
  solo_metal <- metal_emissions(
    use = c(aluminium = 100),
    waste = TRUE,
    material_production = "Primary material production",
    waste_disposal = "Open-loop",
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  hh_metal <- household_emissions(
    metal_use = c(aluminium = 100),
    metal_waste = TRUE,
    metal_waste_disposal = "Open-loop",
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  expect_equal(hh_metal, solo_metal)
  
  ## ELECTRICAL (alkaline batteries): solo vs household
  solo_elec <- electrical_emissions(
    use = c(alkaline_batteries = 100),
    waste = TRUE,
    waste_disposal = "Open-loop",
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  hh_elec <- household_emissions(
    electrical_use = c(alkaline_batteries = 100),
    electrical_waste = TRUE,
    electrical_waste_disposal = "Open-loop",
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  expect_equal(hh_elec, solo_elec)
})

test_that("changing units scales household_emissions correctly", {
  toy <- tibble::tribble(
    # MU for GCB glass under 'Other' so we can test units without needing WD
    ~`Level 1`,     ~`Level 2`, ~`Level 3`, ~`Column Text`,                   ~value, ~value_2024,
    "Material use", "Other",    "Glass",    "Primary material production",       2.00,       2.00
  )
  local_uk_gov_data(toy)
  
  kg_val <- household_emissions(
    gcb_use = c(glass = 100),
    gcb_waste = FALSE,
    units = "kg",
    value_col = "value",
    strict = TRUE
  )
  t_val <- household_emissions(
    gcb_use = c(glass = 100),
    gcb_waste = FALSE,
    units = "tonnes",
    value_col = "value",
    strict = TRUE
  )
  # tonnes should be smaller (kg / 1000)
  expect_lt(t_val, kg_val)
  expect_equal(t_val, kg_val / 1000, tolerance = 1e-12)
})