# ====================================
# Block Development Analytics
# Script 05 - Performance Analysis
# Author: Kavya V R
# Purpose:
# Evaluate block performance against targets
# using indicators with valid positive targets.
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
# Create Performance Dataset
#
# Excludes:
# - Baseline year (2023-24)
# - Negative indicators
# - Missing targets
# - Missing actual values
# - Zero targets
# ====================================

performance_data <- analysis_data |>
  filter(
    Year != "2023-24",
    Direction != "Y",
    !is.na(Target_Value),
    !is.na(Actual_Value),
    Target_Value > 0
  )

# ====================================
# Calculate Achievement Percentage
#
# Formula:
# Achievement % =
# (Actual Value / Target Value) × 100
# ====================================

performance_data <- performance_data |>
  mutate(
    Achievement_Percent =
      (Actual_Value / Target_Value) * 100
  )

# ====================================
# Overall Performance Summary
# ====================================

performance_data |>
  summarise(
    Average_Achievement =
      mean(
        Achievement_Percent,
        na.rm = TRUE
      ),
    
    Median_Achievement =
      median(
        Achievement_Percent,
        na.rm = TRUE
      )
  )

# ====================================
# Average Achievement by Theme
# ====================================

performance_data |>
  group_by(Theme) |>
  summarise(
    Average_Achievement =
      mean(
        Achievement_Percent,
        na.rm = TRUE
      )
  ) |>
  arrange(
    desc(Average_Achievement)
  )

# ====================================
# Target Diagnostics
#
# Understand target availability
# before performance calculations.
# ====================================

analysis_data |>
  filter(
    Year != "2023-24"
  ) |>
  summarise(
    Total_Records = n(),
    
    Missing_Targets =
      sum(
        is.na(Target_Value)
      ),
    
    Zero_Targets =
      sum(
        Target_Value == 0,
        na.rm = TRUE
      )
  )

# ====================================
# Direction Distribution
#
# Check number of positive and
# negative indicators available.
# ====================================

analysis_data |>
  filter(
    Year != "2023-24"
  ) |>
  mutate(
    Direction =
      toupper(Direction)
  ) |>
  count(Direction)

# ====================================
# Indicators with Zero Targets
#
# These indicators require
# special treatment and are
# excluded from achievement
# calculations for now.
# ====================================

analysis_data |>
  filter(
    Year != "2023-24",
    Target_Value == 0
  ) |>
  distinct(
    KDI,
    Indicator
  )

# ====================================
# End of Script 05
# ====================================