# ====================================
# FBDP Analytics Portfolio
# Script 10 - Baseline Classification
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Ranking Dataset
# ====================================

ranking_data <- read_csv(
  "data/processed/ranking_data.csv",
  show_col_types = FALSE
)

# ====================================
# Extract Baseline Year Data
#
# Baseline Year:
# 2023-24
#
# Used for classifying indicators as:
# - Performing
# - Under-Performing
#
# based on comparison with
# District indicator values.
# ====================================

baseline_data <- ranking_data |>
  filter(
    Year == "2023-24"
  )

# ====================================
# Validate Baseline Dataset
# ====================================

baseline_data |>
  summarise(
    Records = n(),
    Indicators = n_distinct(KDI),
    Blocks = n_distinct(Block)
  )

# ====================================
# Baseline Classification
#
# Positive Indicators:
# Block >= District
# = Performing
#
# Negative Indicators:
# Block <= District
# = Performing
#
# Missing Actual or District values
# are classified as:
# Not Available
# ====================================

baseline_classification <- baseline_data |>
  mutate(
    Baseline_Status = case_when(
      
      is.na(Actual_Value) |
        is.na(District_Value)
      ~ "Not Available",
      
      Indicator_Type == "Positive" &
        Actual_Value >= District_Value
      ~ "Performing",
      
      Indicator_Type == "Positive" &
        Actual_Value < District_Value
      ~ "Under-Performing",
      
      Indicator_Type == "Negative" &
        Actual_Value <= District_Value
      ~ "Performing",
      
      Indicator_Type == "Negative" &
        Actual_Value > District_Value
      ~ "Under-Performing"
    )
  )

# ====================================
# Baseline Status Summary
# ====================================

baseline_classification |>
  count(
    Baseline_Status
  )

# ====================================
# Missing Classification Records
#
# Review indicators where
# baseline classification
# could not be determined.
# ====================================

baseline_classification |>
  filter(
    Baseline_Status == "Not Available"
  ) |>
  select(
    KDI,
    Indicator,
    Block,
    Actual_Value,
    District_Value,
    Indicator_Type
  )

# ====================================
# Export Baseline Classification
# ====================================

write_csv(
  baseline_classification,
  "data/processed/baseline_classification.csv"
)

# ====================================
# Validation
# ====================================

file.exists(
  "data/processed/baseline_classification.csv"
)

# ====================================
# End of Script 10
# ====================================