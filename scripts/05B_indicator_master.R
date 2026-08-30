# ====================================
# FBDP Analytics Portfolio
# Script 05B - Indicator Master
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
# Create Indicator Master
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
  mutate(
    Direction = toupper(Direction),
    
    Indicator_Type =
      case_when(
        Direction == "Y" ~ "Negative",
        TRUE ~ "Positive"
      )
  ) |>
  arrange(
    Theme,
    KDI
  )

# ====================================
# Indicator Summary
# ====================================

indicator_master |>
  count(
    Indicator_Type
  )

# ====================================
# Theme-wise Indicator Summary
# ====================================

indicator_master |>
  count(
    Theme,
    Indicator_Type
  )

# ====================================
# Export Indicator Master
# ====================================

write_csv(
  indicator_master,
  "data/processed/indicator_master.csv"
)

# ====================================
# Validation
# ====================================

glimpse(indicator_master)

nrow(indicator_master)