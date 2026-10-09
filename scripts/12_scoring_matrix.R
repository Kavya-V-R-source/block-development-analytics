# ====================================
# Block Development Analytics
# Script 12 - Scoring Matrix
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Datasets
# ====================================

baseline_data <- read_csv(
  "data/processed/baseline_classification.csv",
  show_col_types = FALSE
)

performance_data <- read_csv(
  "data/processed/performance_classification.csv",
  show_col_types = FALSE
)

# ====================================
# Keep Required Baseline Columns
# ====================================

baseline_status <- baseline_data |>
  select(
    Block,
    KDI,
    Baseline_Status
  )

# ====================================
# Join Baseline + Performance
# ====================================

scoring_data <- performance_data |>
  left_join(
    baseline_status,
    by = c("Block", "KDI")
  )

# ====================================
# SPC Scoring Matrix
# ====================================

scoring_data <- scoring_data |>
  mutate(
    Score = case_when(
      
      Performance_Status == "Achiever"
      ~ 1,
      
      Baseline_Status == "Under-Performing" &
        Performance_Status == "Front-Runner"
      ~ 0.5,
      
      Baseline_Status == "Performing" &
        Performance_Status == "Front-Runner"
      ~ 0.25,
      
      Performance_Status == "Aspirer"
      ~ 0,
      
      TRUE
      ~ NA_real_
    )
  )

# ====================================
# Validation
# ====================================

scoring_data |>
  count(
    Score
  )

# ====================================
# Export
# ====================================

write_csv(
  scoring_data,
  "data/processed/scoring_matrix.csv"
)

file.exists(
  "data/processed/scoring_matrix.csv"
)