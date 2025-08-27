#############################

# This file adds in the 2025 Gov UK data into the 2024 file
# It has checks, before merging it in
# And renaming the 2024 (last year) column as value_2024
# and then renaming this year column to value
# so that it calls the most recent data.

############################



# adding a new year into our data:
library(readxl)

### 1. Set up and Merge -----------------------------------------------------------
ghg_conversion_factors_2025_flat_format <- read_excel("C:/Users/lclem/Downloads/ghg-conversion-factors-2025-flat-format.xlsx", 
                                                      sheet = "Factors by Category", skip = 5)

#View(ghg_conversion_factors_2025_flat_format)
ghg_conversion_factors_2025_flat_format <- ghg_conversion_factors_2025_flat_format %>%
  filter(`GHG/Unit` != "kg CO2e of CO2 per unit") %>%
  filter(`GHG/Unit` != "kg CO2e of CH4 per unit") %>%
  filter(`GHG/Unit` != "kg CO2e of N2O per unit")

ghg_conversion_factors_2025_flat_format <- ghg_conversion_factors_2025_flat_format %>%
  dplyr::filter(!is.na(`GHG Conversion Factor 2025`))

uk_gov_data_2024 <- uk_gov_data_2024 %>%
  dplyr::filter(!is.na(value))

# check the names are all the same, except for the value / GHG Conversion Factor 2025
names(ghg_conversion_factors_2025_flat_format)
names(uk_gov_data_2024)

# and then merge them!
uk_gov_data_2024_1 <- full_join(uk_gov_data_2024, ghg_conversion_factors_2025_flat_format)

### 2. Check if we have increased in row numbers ----------------------------------

# both 2024 and 2025 have the same number of rows, but the merged has different:
nrow(uk_gov_data_2024)
nrow(ghg_conversion_factors_2025_flat_format)
nrow(uk_gov_data_2024_1)

# Check the 231 new rows -- we can see there are no new IDs:
setdiff(uk_gov_data_2024$ID, ghg_conversion_factors_2025_flat_format$ID)
setdiff(ghg_conversion_factors_2025_flat_format$ID, uk_gov_data_2024$ID)

# so we must now have duplicated IDs. Let's get the duplicates:
dup_rows <- uk_gov_data_2024_1 %>% group_by(ID) %>% filter(n() > 1) %>% ungroup() %>% arrange(ID)
nrow(dup_rows)
View(dup_rows)

# OK, 

# ROWS 1 - 18: Level 4 said kWh, but now does not. So we can add that back in
# ROWS 19 - 36: Column Text said "Closed-loop" and now says "Closed-loop source". Change this.
# ROWS 37 - 96: CT said Combustion, and now says Incineration with Energy Recovery
# ROWS 97 - 208: L4 said Average passenger, and now is NA, etc, for all classes they're missing this
# 209 - 220 - issue in L3. Need to remove "passenger" (/ (all passenger))
# 221 - 432: L4 missing info 
# 433 - 434: L3 name change
# 435 - 438: L4 missing kWh

# So, we do LOCF for Level 4 in rows 1-18, 121-232, 245-457, 459-462.
# And we can do this for our others in L3 and CT too: remove all info for our new data (if there is a value in GHG Conversino Factor 2025) in Column Text and in L3. Collapse again.
dup_rows <- dup_rows %>%
  mutate(`Column Text` = ifelse(!is.na(`GHG Conversion Factor 2025`), NA, `Column Text`)) %>%
  mutate(`Level 3` = ifelse(!is.na(`GHG Conversion Factor 2025`), NA, `Level 3`))

cols <- setdiff(names(dup_rows), "ID")
df_locf <- dup_rows %>%
  arrange(ID) %>%
  group_by(ID) %>%
  fill(all_of(cols), .direction = "downup") %>%  # forward then backward
  ungroup()
# We simply want to collapse them. 
df_locf <- unique(df_locf)

# Then we remove these IDs from our main data, and then add this data back in.
df_locf_IDs <- df_locf %>% dplyr::pull(ID)
nrow(uk_gov_data_2024_1)
uk_gov_data_2024_1 <- uk_gov_data_2024_1 %>% dplyr::filter(!ID %in% df_locf_IDs)
nrow(uk_gov_data_2024_1)
uk_gov_data_2024_1 <- rbind(uk_gov_data_2024_1, df_locf)
nrow(uk_gov_data_2024_1) # at 3067 now

##########################

# 3. Let's finally next check where there are differences in vlaues to sanity check
# Let's look where it is different
uk_diff_rows <- uk_gov_data_2024_1 %>% filter(value != `GHG Conversion Factor 2025`)
nrow(uk_diff_rows) # this gives 1687 rows, which should include our 231 new rows.
View(uk_diff_rows)
# Manually inspect all these rows to check the difference is OK
uk_diff_rows <- uk_gov_data_2024_1 %>% mutate(x = value - `GHG Conversion Factor 2025`) %>% arrange(x)
View(uk_diff_rows)


# 4. Rename Columns
uk_gov_data_2024_1 <- uk_gov_data_2024_1 %>%
  dplyr::rename(value_2024 = value) %>%
  dplyr::rename(value = `GHG Conversion Factor 2025`)

uk_gov_data <- uk_gov_data_2024_1


#######################################################################################

# FInally, add it in

usethis::use_data(
  airports,
  anaesthetics_df,
  cpi_data,
  data,
  fuels,
  uk_gov_data,
  uk_gov_data_2023,
  uk_gov_data_2024,
  vehicles,
  internal  = TRUE,
  overwrite = TRUE
  #compress  = "xz"   # keeps file small for CRAN
)

