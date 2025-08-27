local_uk_gov_data <- function(df, pkg = "carbonr") {
  ns <- asNamespace(pkg)
  testthat::local_mocked_bindings(uk_gov_data = df, .env = ns)
}

test_that("material_emissions handles glass and industrial waste internally", {
  toy <- tibble::tribble(
    ~`Level 1`,       ~`Level 2`, ~`Level 3`,                        ~`Column Text`,                  ~UOM, ~value, ~value_2024,
    "Material use",   "Glass",    "Glass",                           "Primary material production",    NA,   1.0,     1.0,
    "Waste disposal", "Glass",    "Glass",                           "Closed-loop",                    NA,   0.2,     0.2,
    "Waste disposal", "Waste",    "Commercial and industrial waste", "Combustion",                     NA,   0.3,     0.3
  )
  local_uk_gov_data(toy)
  
  got <- material_emissions(
    glass = 3, glass_waste = TRUE, glass_waste_disposal = "Closed-loop",
    industrial_waste = 10, industrial_waste_disposal = "Combustion",
    units = "kg"
  )
  # 3 * (1.0 + 0.2) + 10 * 0.3 = 3.6 + 3 = 6.6
  expect_equal(got, 6.6)
})


test_that("metal_emissions: happy path (primary + landfill; waste = use; kg)", {
  toy <- tibble::tribble(
    ~`Level 1`,       ~`Level 2`, ~`Level 3`,                                      ~`Column Text`,                  ~value, ~value_2024,
    "Material use",   "Metal",    "Metal: aluminium cans and foil (excl. forming)", "Primary material production",   9000,   9001,
    "Material use",   "Metal",    "Metal: mixed cans",                              "Primary material production",   5000,   5002,
    "Material use",   "Metal",    "Metal: scrap metal",                             "Primary material production",   3400,   3403,
    "Material use",   "Metal",    "Metal: steel cans",                              "Primary material production",   2800,   2804,
    "Waste disposal", "Metal",    "Metal: aluminium cans and foil (excl. forming)", "Landfill",                        12,     12,
    "Waste disposal", "Metal",    "Metal: mixed cans",                              "Landfill",                        10,     10,
    "Waste disposal", "Metal",    "Metal: scrap metal",                             "Landfill",                        11,     11,
    "Waste disposal", "Metal",    "Metal: steel cans",                              "Landfill",                         9,      9
  )
  local_uk_gov_data(toy)
  
  got <- metal_emissions(
    use = c(aluminium = 0.2, mixed_cans = 0.1, scrap = 0.05, steel_cans = 0.03),
    material_production = "Primary material production",
    waste_disposal = "Landfill",
    waste = TRUE,
    units = "kg"
  )
  expect_equal(got, 0.2*(9000+12) + 0.1*(5000+10) + 0.05*(3400+11) + 0.03*(2800+9))
})

test_that("metal_emissions: per-material production + synonyms; only named item is changed", {
  toy <- tibble::tribble(
    ~`Level 1`,       ~`Level 2`, ~`Level 3`,                                      ~`Column Text`,                 ~value,
    "Material use",   "Metal",    "Metal: aluminium cans and foil (excl. forming)", "Primary material production",   9000,
    "Material use",   "Metal",    "Metal: aluminium cans and foil (excl. forming)", "Closed-loop source",            5500,
    "Material use",   "Metal",    "Metal: mixed cans",                              "Primary material production",   5000,
    "Material use",   "Metal",    "Metal: steel cans",                              "Primary material production",   2800,
    "Waste disposal", "Metal",    "Metal: aluminium cans and foil (excl. forming)", "Closed-loop",                     8,
    "Waste disposal", "Metal",    "Metal: mixed cans",                              "Closed-loop",                     6,
    "Waste disposal", "Metal",    "Metal: steel cans",                              "Closed-loop",                     5
  )
  local_uk_gov_data(toy)
  
  got <- metal_emissions(
    use = c(aluminum_foil = 0.1, mixed = 0.2, steel_cans = 0.3),
    material_production = c(aluminium = "closed loop"),
    waste_disposal = "Closed-loop",
    waste = TRUE,
    units = "kg"
  )
  expect_equal(got, 0.1*(5500+8) + 0.2*(5000+6) + 0.3*(2800+5))
})

test_that("metal_emissions: strict errors vs lenient zero-fill; units/value_col", {
  toy <- tibble::tribble(
    ~`Level 1`,       ~`Level 2`, ~`Level 3`,                 ~`Column Text`,                 ~value, ~value_2024,
    "Material use",   "Metal",    "Metal: mixed cans",        "Primary material production",   5000,    5106
    # no waste rows
  )
  local_uk_gov_data(toy)
  
  # strict=TRUE: missing waste factor with waste=TRUE
  expect_error(
    metal_emissions(
      use = c(mixed_cans = 1),
      material_production = "Primary material production",
      waste_disposal = "Landfill",
      waste = TRUE,
      strict = TRUE
    ), "No waste-disposal factor"
  )
  
  # strict=FALSE: missing WD treated as 0; 2024 column; tonnes
  got <- metal_emissions(
    use = c(mixed_cans = 0.5),
    material_production = "Primary material production",
    waste_disposal = "Landfill",
    waste = TRUE,
    strict = FALSE,
    value_col = "value_2024",
    units = "tonnes"
  )
  expect_equal(got, (0.5 * 5106) * 0.001)  # WD=0
})

test_that("metal_emissions: unknown names warn and are ignored", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`, ~`Level 3`,                                      ~`Column Text`,                 ~value,
    "Material use", "Metal",    "Metal: aluminium cans and foil (excl. forming)", "Primary material production",   9000,
    "Waste disposal","Metal",   "Metal: aluminium cans and foil (excl. forming)", "Open-loop",                       7
  )
  local_uk_gov_data(toy)
  
  expect_warning(
    got <- metal_emissions(
      use = c(tin_cans = 99, aluminum_cans = 0.1),
      material_production = "primary",
      waste_disposal = "Open-loop",
      waste = TRUE
    ),
    "unknown metal material name"
  )
  expect_equal(got, 0.1 * (9000 + 7))
})


test_that("paper_emissions: happy path (primary + closed-loop; waste = use)", {
  toy <- tibble::tribble(
    ~`Level 1`,       ~`Level 2`, ~`Level 3`,         ~`Column Text`,                  ~value, ~value_2024,
    "Material use",   "Paper",    "Paper: Board",     "Primary material production",     1.5,     1.6,
    "Material use",   "Paper",    "Paper: Mixed",     "Primary material production",     1.0,     1.1,
    "Material use",   "Paper",    "Paper: Paper",     "Primary material production",     2.0,     2.1,
    "Waste disposal", "Paper",    "Paper: Board",     "Closed-loop",                     0.3,     0.35,
    "Waste disposal", "Paper",    "Paper: Mixed",     "Closed-loop",                     0.2,     0.22,
    "Waste disposal", "Paper",    "Paper: Paper",     "Closed-loop",                     0.5,     0.55
  )
  local_uk_gov_data(toy)
  
  got <- paper_emissions(
    use = c(board = 10, paper = 5),
    waste = TRUE,
    waste_disposal = "Closed-loop",
    units = "kg"
  )
  expect_equal(got, 10*(1.5+0.3) + 5*(2.0+0.5))
})

test_that("paper_emissions: per-material production only affects specified item", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`, ~`Level 3`,     ~`Column Text`,                  ~value,
    "Material use", "Paper",    "Paper: Mixed", "Primary material production",     1.0,
    "Material use", "Paper",    "Paper: Mixed", "Closed-loop source",              0.6,
    "Material use", "Paper",    "Paper: Board", "Primary material production",     1.5,
    "Waste disposal","Paper",   "Paper: Mixed", "Closed-loop",                     0.2,
    "Waste disposal","Paper",   "Paper: Board", "Closed-loop",                     0.3
  )
  local_uk_gov_data(toy)
  
  got <- paper_emissions(
    use = c(mixed = 2, board = 3),
    material_production = c(mixed = "closed loop"),
    waste = TRUE,
    waste_disposal = "Closed-loop",
    units = "kg"
  )
  expect_equal(got, 2*(0.6+0.2) + 3*(1.5+0.3))
})

test_that("paper_emissions: unknown names warn and are ignored; strict handling", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`, ~`Level 3`,     ~`Column Text`,                  ~value,
    "Material use", "Paper",    "Paper: Paper", "Primary material production",     2.0
    # no WD rows
  )
  local_uk_gov_data(toy)
  
  expect_warning(
    got <- paper_emissions(
      use = c(paper = 1, newsletter = 99),
      waste = FALSE,
      units = "kg"
    ),
    "unknown paper material name"
  )
  expect_equal(got, 2.0)  # no waste
  
  expect_error(
    paper_emissions(
      use = c(paper = 1),
      waste = TRUE,
      waste_disposal = "Closed-loop",
      strict = TRUE
    ),
    "No waste-disposal factor"
  )
  
  got2 <- paper_emissions(
    use = c(paper = 1),
    waste = TRUE,
    waste_disposal = "Closed-loop",
    strict = FALSE
  )
  expect_equal(got2, 2.0)  # WD treated as 0
})

test_that("paper_emissions: units and value_col", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`, ~`Level 3`,     ~`Column Text`,                  ~value, ~value_2024,
    "Material use", "Paper",    "Paper: Paper", "Primary material production",     2.0,    2.2,
    "Waste disposal","Paper",   "Paper: Paper", "Closed-loop",                     0.5,    0.6
  )
  local_uk_gov_data(toy)
  
  got <- paper_emissions(
    use = c(paper = 1),
    waste = TRUE,
    waste_disposal = "Closed-loop",
    value_col = "value_2024",
    units = "tonnes"
  )
  expect_equal(got, (1 * (2.2 + 0.6)) * 0.001)
})

test_that("construction_emissions: happy path (per-material production + landfill; waste = use)", {
  toy <- tibble::tribble(
    ~`Level 1`,       ~`Level 2`,      ~`Level 3`,   ~`Column Text`,                  ~value, ~value_2024,
    # Material use (two materials with two production routes)
    "Material use",   "Construction",  "Metals",     "Primary material production",    1000,    1001,
    "Material use",   "Construction",  "Metals",     "Closed-loop source",              600,     601,
    "Material use",   "Construction",  "Concrete",   "Primary material production",     200,     201,
    # Waste disposal (landfill) for both
    "Waste disposal", "Construction",  "Metals",     "Landfill",                          6,       6,
    "Waste disposal", "Construction",  "Concrete",   "Landfill",                          1,       1
  )
  local_uk_gov_data(toy)
  
  got <- construction_emissions(
    use = c(metals = 2, concrete = 3),
    material_production = c(metals = "closed loop", concrete = "primary"),
    waste_disposal = "Landfill",
    waste = TRUE,
    units = "kg"
  )
  expect_equal(got, 2*(600+6) + 3*(200+1))
})

test_that("construction_emissions: strict errors when MU/WD missing vs lenient zero-fill", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`,     ~`Level 3`, ~`Column Text`,                  ~value,
    "Material use", "Construction", "Metals",   "Primary material production",     1000
    # no WD rows
  )
  local_uk_gov_data(toy)
  
  expect_error(
    construction_emissions(
      use = c(metals = 1),
      material_production = "Primary material production",
      waste_disposal = "Landfill",
      waste = TRUE,
      strict = TRUE
    ),
    "No waste-disposal factor"
  )
  
  got <- construction_emissions(
    use = c(metals = 1),
    material_production = "Primary material production",
    waste_disposal = "Landfill",
    waste = TRUE,
    strict = FALSE,
    units = "kg"
  )
  expect_equal(got, 1000)  # WD treated as 0
})

test_that("construction_emissions: unknown names are ignored (no error), units/value_col", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`,     ~`Level 3`, ~`Column Text`,                  ~value, ~value_2024,
    "Material use", "Construction", "Concrete", "Primary material production",      200,     250,
    "Waste disposal","Construction","Concrete", "Landfill",                           1,       2
  )
  local_uk_gov_data(toy)
  
  got <- construction_emissions(
    use = c(concrete = 4, unobtanium = 99),
    material_production = "Primary material production",
    waste_disposal = "Landfill",
    waste = TRUE,
    value_col = "value_2024",
    units = "tonnes"
  )
  expect_equal(got, (4 * (250 + 2)) * 0.001)
})

test_that("plastic_emissions: happy path (PET primary + landfill; waste = use)", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`, ~`Level 3`,       ~`Column Text`,                  ~value,
    "Material use", "Plastic",  "Plastics - PET", "Primary material production",      3.0,
    "Waste disposal","Plastic", "Plastics - PET", "Landfill",                          0.7
  )
  
  local_uk_gov_data(toy)
  
  got <- plastic_emissions(
    use = c(pet = 100),
    waste = TRUE,
    waste_disposal = "Landfill",
    units = "kg"
  )
  expect_equal(got, 100 * (3.0 + 0.7))
})

test_that("plastic_emissions: name normalisation + LDPE/LLDPE bucket; unknown warns", {
  expect_warning(
    got <- plastic_emissions(
      use = c(`mystery` = 9),
      waste = TRUE,
      waste_disposal = "Open-loop",
      units = "kg"
    ),
    "unknown plastic material name"
  )
})

test_that("plastic_emissions: strict errors vs lenient zero-fill; value_col/units", {
  toy <- tibble::tribble(
    ~`Level 1`,     ~`Level 2`, ~`Level 3`,       ~`Column Text`,                  ~value, ~value_2024,
    "Material use", "Plastic",  "Plastics - PET", "Primary material production",     3.0,     3.2
    # no WD rows
  )
  local_uk_gov_data(toy)
  
  expect_error(
    plastic_emissions(
      use = c(pet = 1),
      waste = TRUE,
      waste_disposal = "Landfill",
      strict = TRUE
    ),
    "No waste-disposal factor"
  )
  
  got <- plastic_emissions(
    use = c(pet = 2),
    waste = TRUE,
    waste_disposal = "Landfill",
    strict = FALSE,
    value_col = "value_2024",
    units = "tonnes"
  )
  expect_equal(got, (2 * 3.2) * 0.001) # WD treated as 0
})
