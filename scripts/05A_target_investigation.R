# ====================================
# Block Development Analytics
# Script 05A - Data Diagnostics
# Author: Kavya V R
#
# Purpose:
# Understand target availability,
# indicator direction,
# and metadata quality before
# performance calculations.
# ====================================

library(tidyverse)

# ====================================
# Load Analysis Dataset
# ====================================

analysis_data <- read_csv(
  "data/processed/analysis_data.csv",
  show_col_types = FALSE
)

# ====================================
# Target Availability by Theme
#
# Classifies records as:
# - Positive Target
# - Zero Target
# - Missing Target
# ====================================

analysis_data |>
  filter(
    Year != "2023-24"
  ) |>
  mutate(
    Target_Type = case_when(
      is.na(Target_Value) ~ "Missing",
      Target_Value == 0 ~ "Zero",
      TRUE ~ "Positive"
    )
  ) |>
  count(
    Theme,
    Target_Type
  )

# ====================================
# Indicator Classification Summary
#
# Counts indicators associated with:
# - Positive Targets
# - Zero Targets
# - Missing Targets
# ====================================

analysis_data |>
  filter(
    Year != "2023-24"
  ) |>
  mutate(
    Target_Type = case_when(
      is.na(Target_Value) ~ "Missing",
      Target_Value == 0 ~ "Zero",
      TRUE ~ "Positive"
    )
  ) |>
  distinct(
    KDI,
    Indicator,
    Direction,
    Target_Type
  ) |>
  count(
    Target_Type
  )

# ====================================
# Indicator Master List
#
# Creates a unique list of
# indicators, themes, and directions.
# ====================================

indicator_master <- analysis_data |>
  filter(
    Year != "2023-24"
  ) |>
  distinct(
    KDI,
    Indicator,
    Theme,
    Direction
  ) |>
  arrange(
    Theme,
    KDI
  )

# Inspect Indicator Master

glimpse(indicator_master)

nrow(indicator_master)

# ====================================
# Direction Validation Example
#
# Verify baseline-year direction issues.
# ====================================

analysis_data |>
  filter(
    KDI == "2.B"
  ) |>
  distinct(
    Year,
    Direction
  )

# ====================================
# End of Script 05A
# ====================================