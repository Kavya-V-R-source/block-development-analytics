# ====================================
# Block Development Analytics
# Script 04 - Exploratory Analysis
# Author: Kavya V R
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
# Dataset Overview
# ====================================

analysis_data |>
  summarise(
    Total_Records = n(),
    Districts = n_distinct(District),
    Blocks = n_distinct(Block),
    Indicators = n_distinct(KDI),
    Themes = n_distinct(Theme),
    Years = n_distinct(Year)
  )

# ====================================
# Indicators by Theme
# ====================================

analysis_data |>
  distinct(
    Theme,
    KDI
  ) |>
  count(
    Theme,
    sort = TRUE
  )

# ====================================
# Blocks per District
# ====================================

analysis_data |>
  distinct(
    District,
    Block
  ) |>
  count(
    District,
    sort = TRUE
  )

# ====================================
# Direction Validation
# ====================================

analysis_data |>
  distinct(
    KDI,
    Indicator,
    Direction
  ) |>
  count(
    KDI,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )

# ====================================
# Indicator Metadata Summary
# ====================================

analysis_data |>
  filter(
    Year != "2023-24"
  ) |>
  distinct(
    KDI,
    Theme,
    Direction
  ) |>
  count(
    Theme,
    Direction
  )

# ====================================
# Missing Actual Values by Indicator
# ====================================

analysis_data |>
  group_by(
    KDI,
    Indicator
  ) |>
  summarise(
    Missing_Actual =
      sum(is.na(Actual_Value)),
    .groups = "drop"
  ) |>
  arrange(
    desc(Missing_Actual)
  )

# ====================================
# Missing Data by Theme
# ====================================

analysis_data |>
  group_by(
    Theme
  ) |>
  summarise(
    Missing_Actual =
      sum(is.na(Actual_Value)),
    
    Missing_Target =
      sum(is.na(Target_Value)),
    
    Missing_District =
      sum(is.na(District_Value))
  ) |>
  arrange(
    desc(Missing_Actual)
  )

# ====================================
# Missing Data by Year
# ====================================

analysis_data |>
  group_by(
    Year
  ) |>
  summarise(
    Missing_Actual =
      sum(is.na(Actual_Value)),
    
    Missing_Target =
      sum(is.na(Target_Value)),
    
    Missing_District =
      sum(is.na(District_Value))
  )

# ====================================
# Data Quality Summary
# ====================================

analysis_data |>
  summarise(
    Total_Records = n(),
    
    Missing_Actual =
      sum(is.na(Actual_Value)),
    
    Missing_Target =
      sum(is.na(Target_Value)),
    
    Missing_District =
      sum(is.na(District_Value))
  )
# ====================================
# Direction Distribution
# ====================================

analysis_data |>
  mutate(
    Direction = toupper(Direction)
  ) |>
  count(Direction)
