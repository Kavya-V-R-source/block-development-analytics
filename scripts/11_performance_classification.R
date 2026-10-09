# ====================================
# Block Development Analytics
# Script 11 - Performance Classification
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
# Analysis Years
# ====================================

performance_data <- ranking_data |>
  filter(
    Year != "2023-24"
  )

# ====================================
# Achievement Percentage
# ====================================

performance_classification <- performance_data |>
  mutate(
    Achievement_Percent =
      (Actual_Value / Target_Value) * 100,
    
    Performance_Status = case_when(
      
      is.na(Actual_Value) |
        is.na(Target_Value) |
        Target_Value == 0
      ~ "Not Available",
      
      Achievement_Percent >= 100
      ~ "Achiever",
      
      Achievement_Percent >= 90
      ~ "Front-Runner",
      
      Achievement_Percent < 90
      ~ "Aspirer"
    )
  )
performance_classification |>
  count(
    Performance_Status
  )