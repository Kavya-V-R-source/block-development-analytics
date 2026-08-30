# ====================================
# FBDP Analytics Portfolio
# Script 07 - Dashboard Overview
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Dashboard Dataset
# ====================================

dashboard_data <- read_csv(
  "data/processed/dashboard_data.csv",
  show_col_types = FALSE
)

# ====================================
# Dataset Summary
# ====================================

dashboard_data |>
  summarise(
    Total_Records = n(),
    Indicators = n_distinct(KDI),
    Blocks = n_distinct(Block),
    Years = n_distinct(Year)
  )

# ====================================
# Records by Theme
# ====================================

dashboard_data |>
  count(
    Theme,
    sort = TRUE
  )

# ====================================
# Records by Year
# ====================================

dashboard_data |>
  count(
    Year
  )

# ====================================
# Indicator Summary
# ====================================

dashboard_data |>
  distinct(
    KDI,
    Indicator_Type
  ) |>
  count(
    Indicator_Type
  )

# ====================================
# Indicators by Theme
# ====================================

dashboard_data |>
  distinct(
    KDI,
    Theme
  ) |>
  count(
    Theme,
    sort = TRUE
  )

# ====================================
# Theme-wise Data Coverage
# ====================================

dashboard_data |>
  group_by(
    Theme
  ) |>
  summarise(
    Total_Records = n(),
    
    Missing_Actual =
      sum(is.na(Actual_Value)),
    
    Missing_Target =
      sum(is.na(Target_Value))
  ) |>
  arrange(
    desc(Total_Records)
  )

# ====================================
# Missing Data Percentage by Theme
# ====================================

dashboard_data |>
  group_by(
    Theme
  ) |>
  summarise(
    Total_Records = n(),
    
    Missing_Actual_Pct =
      round(
        mean(is.na(Actual_Value)) * 100,
        1
      ),
    
    Missing_Target_Pct =
      round(
        mean(is.na(Target_Value)) * 100,
        1
      )
  ) |>
  arrange(
    desc(Missing_Actual_Pct)
  )

# ====================================
# Indicator Coverage by Year
# ====================================

dashboard_data |>
  group_by(
    Year
  ) |>
  summarise(
    Indicators =
      n_distinct(KDI),
    
    Blocks =
      n_distinct(Block)
  )

# ====================================
# Theme Coverage by Year
# ====================================

dashboard_data |>
  count(
    Year,
    Theme
  )

# ====================================
# End of Script 07
# ====================================