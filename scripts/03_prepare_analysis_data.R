# ====================================
# Block Development Analytics
# Script 03 - Prepare Analysis Data
# Author: Kavya V R
# ====================================

library(tidyverse)

source("scripts/02_clean_data.R")

# ====================================
# Combine Block Target Datasets
# ====================================

block_targets <- bind_rows(
  clean_first_year_target,
  clean_second_year_target
)

# ====================================
# Combine District Performance Datasets
# ====================================

district_performance <- bind_rows(
  clean_district_baseline,
  clean_district_2025,
  clean_district_2026
)

# ====================================
# Create Block Lookup Table
# ====================================

block_lookup <- block_targets |>
  distinct(
    District,
    Block
  )

# ====================================
# Prepare Block Performance Dataset
# ====================================

block_performance <- clean_three_year |>
  left_join(
    block_lookup,
    by = "Block"
  ) |>
  relocate(
    District,
    Block
  )

# ====================================
# Validate Block Performance
# ====================================

glimpse(block_performance)

sum(is.na(block_performance$District))

# ====================================
# Join Block Targets
# ====================================

block_analysis <- block_performance |>
  left_join(
    block_targets |>
      select(
        District,
        Block,
        KDI,
        Year,
        Direction,
        Target_Value
      ),
    by = c(
      "District",
      "Block",
      "KDI",
      "Year"
    )
  )

# ====================================
# Validate Target Join
# ====================================

glimpse(block_analysis)

sum(is.na(block_analysis$Target_Value))

# ====================================
# Join District Performance
# ====================================

analysis_data <- block_analysis |>
  left_join(
    district_performance |>
      select(
        District,
        KDI,
        Year,
        District_Value
      ),
    by = c(
      "District",
      "KDI",
      "Year"
    )
  )

# ====================================
# Validate District Join
# ====================================

glimpse(analysis_data)

sum(is.na(analysis_data$District_Value))

# ====================================
# Organize Columns
# ====================================

analysis_data <- analysis_data |>
  select(
    District,
    Block,
    SNO,
    KDI,
    Indicator,
    Theme,
    Direction,
    Year,
    Actual_Value,
    Target_Value,
    District_Value
  ) |>
  arrange(
    Theme,
    Indicator,
    District,
    Block,
    Year
  )

# ====================================
# Export Processed Dataset
# ====================================

write_csv(
  analysis_data,
  "data/processed/analysis_data.csv"
)

# ====================================
# Final Inspection
# ====================================

glimpse(analysis_data)

summary(analysis_data)

head(analysis_data)

# ====================================
# Validation Checks
# ====================================

analysis_data |>
  summarise(
    Total_Records = n(),
    Missing_District = sum(is.na(District)),
    Missing_Actual = sum(is.na(Actual_Value)),
    Missing_Target = sum(is.na(Target_Value)),
    Missing_District_Value = sum(is.na(District_Value))
  )
