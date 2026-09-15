# ====================================
# FBDP Analytics Portfolio
# Script 13 - Theme Scores
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
# Calculate Theme Scores
# ====================================

theme_scores <- scoring_data |>
  group_by(
    Year,
    Block,
    Theme
  ) |>
  summarise(
    Theme_Score =
      mean(
        Score,
        na.rm = TRUE
      ),
    
    Indicators =
      sum(
        !is.na(Score)
      ),
    
    .groups = "drop"
  )

# ====================================
# Validation
# ====================================

theme_scores |>
  summarise(
    Records = n(),
    Blocks = n_distinct(Block),
    Themes = n_distinct(Theme),
    Years = n_distinct(Year)
  )

# ====================================
# Export
# ====================================

write_csv(
  theme_scores,
  "data/processed/theme_scores.csv"
)

file.exists(
  "data/processed/theme_scores.csv"
)