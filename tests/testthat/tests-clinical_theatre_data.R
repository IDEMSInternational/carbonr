library(carbonr)

# create some dummy data
df <- data.frame(time = c("10/04/2000", "10/04/2000", "11/04/2000", "11/04/2000", "12/04/2000", "12/04/2000"),
                 theatre = rep(c("A", "B"), times = 3),
                 clinical_waste = c(80, 90, 80, 100, 120, 110),
                 electricity_kwh = c(100, 110, 90, 100, 100, 110),
                 general_waste = c(65, 55, 70, 50, 60, 30))


output <- (clinical_theatre_data(df, time = time,
                               name = theatre,
                               wet_clinical_waste = clinical_waste,
                               wet_clinical_waste_unit = "kg",
                               average = general_waste,
                               plastic_units = "kg",
                               electricity_kWh = electricity_kwh,
                               include_cpi = FALSE))[[1]]

df1 <- df[6,]
output_1 <- with(df1, clinical_theatre_emissions(wet_clinical_waste = clinical_waste,
                                                 wet_clinical_waste_unit = "kg",
                                                 average = general_waste,
                                                 plastic_units = "kg",
                                                 electricity_kWh = electricity_kwh))

output_with_cpi <- (clinical_theatre_data(df, time = time,
                                 name = theatre,
                                 wet_clinical_waste = clinical_waste,
                                 wet_clinical_waste_unit = "kg",
                                 average = general_waste,
                                 plastic_units = "kg",
                                 electricity_kWh = electricity_kwh,
                                 include_cpi = TRUE,
                                 jurisdiction = "United Kingdom",
                                 year = 2023))[[1]]

test_that("reads in correct row of data", {
  expect_equal(output[6,3], output_1)
})

test_that("reads in jurisdiction", {
  expect_equal(names(output_with_cpi), c("time", "theatre", "emissions", "carbon_price_credit"))
})
