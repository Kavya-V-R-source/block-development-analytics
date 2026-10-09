# ====================================
# Block Development Analytics
# Script 16 - Overall Rankings
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Scoring Matrix
# ====================================

scoring_data <- read_csv(
  "data/processed/scoring_matrix.csv",
  show_col_types = FALSE
)

# ====================================
# Calculate Overall Scores
# ====================================

overall_scores <- scoring_data |>
  group_by(
    Year,
    Block
  ) |>
  summarise(
    Overall_Score = mean(
      Score,
      na.rm = TRUE
    ),
    
    Indicators = sum(
      !is.na(Score)
    ),
    
    .groups = "drop"
  )

# ====================================
# Normalise Overall Scores
# ====================================

overall_rankings <- overall_scores |>
  group_by(
    Year
  ) |>
  mutate(
    Min_Score = min(
      Overall_Score,
      na.rm = TRUE
    ),
    
    Max_Score = max(
      Overall_Score,
      na.rm = TRUE
    ),
    
    Normalised_Score =
      (
        (Overall_Score - Min_Score) /
          (Max_Score - Min_Score)
      ) * 100
  ) |>
  mutate(
    Overall_Rank =
      min_rank(
        desc(Normalised_Score)
      )
  ) |>
  ungroup()

# ====================================
# Validation
# ====================================

overall_rankings |>
  summarise(
    Records = n(),
    Blocks = n_distinct(Block),
    Years = n_distinct(Year)
  )

# ====================================
# Top 10 Blocks
# ====================================

overall_rankings |>
  filter(
    Year == "2025-26"
  ) |>
  arrange(
    Overall_Rank
  ) |>
  select(
    Block,
    Overall_Score,
    Normalised_Score,
    Overall_Rank
  ) |>
  print(n = 10)

# ====================================
# Export
# ====================================

write_csv(
  overall_rankings,
  "data/processed/overall_rankings.csv"
)

file.exists(
  "data/processed/overall_rankings.csv"
)