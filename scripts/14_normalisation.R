# ====================================
# FBDP Analytics Portfolio
# Script 14 - Theme Score Normalisation
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Theme Scores
# ====================================

theme_scores <- read_csv(
  "data/processed/theme_scores.csv",
  show_col_types = FALSE
)

# ====================================
# Normalise Theme Scores
# ====================================

normalised_scores <- theme_scores |>
  group_by(
    Year,
    Theme
  ) |>
  mutate(
    Min_Theme_Score = min(
      Theme_Score,
      na.rm = TRUE
    ),
    
    Max_Theme_Score = max(
      Theme_Score,
      na.rm = TRUE
    ),
    
    Normalised_Score =
      (
        (Theme_Score - Min_Theme_Score) /
          (Max_Theme_Score - Min_Theme_Score)
      ) * 100
  ) |>
  ungroup()

# ====================================
# Validation
# ====================================

normalised_scores |>
  summarise(
    Min_Score = min(
      Normalised_Score,
      na.rm = TRUE
    ),
    
    Max_Score = max(
      Normalised_Score,
      na.rm = TRUE
    )
  )

# ====================================
# Export
# ====================================

write_csv(
  normalised_scores,
  "data/processed/normalised_scores.csv"
)

file.exists(
  "data/processed/normalised_scores.csv"
)