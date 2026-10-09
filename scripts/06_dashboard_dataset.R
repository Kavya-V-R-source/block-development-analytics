# ====================================
# Block Development Analytics
# Script 06 - Dashboard Dataset
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Processed Datasets
# ====================================

analysis_data <- read_csv(
  "data/processed/analysis_data.csv",
  show_col_types = FALSE
)

indicator_master <- read_csv(
  "data/processed/indicator_master.csv",
  show_col_types = FALSE
)

# ====================================
# Join Indicator Metadata
# ====================================

dashboard_data <- analysis_data |>
  left_join(
    indicator_master |>
      select(
        KDI,
        Indicator_Type
      ),
    by = "KDI"
  )

# ====================================
# Validation
# ====================================

dashboard_data |>
  count(
    Indicator_Type
  )

dashboard_data |>
  summarise(
    Total_Records = n(),
    Indicators = n_distinct(KDI),
    Blocks = n_distinct(Block),
    Years = n_distinct(Year)
  )

# ====================================
# Export Dashboard Dataset
# ====================================

write_csv(
  dashboard_data,
  "data/processed/dashboard_data.csv"
)

# ====================================
# Final Inspection
# ====================================

glimpse(dashboard_data)

head(dashboard_data)