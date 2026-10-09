# ====================================
# Block Development Analytics
# Script 15 - Theme Rankings
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Normalised Scores
# ====================================

normalised_scores <- read_csv(
  "data/processed/normalised_scores.csv",
  show_col_types = FALSE
)

# ====================================
# Calculate Theme Rankings
# ====================================

theme_rankings <- normalised_scores |>
  group_by(
    Year,
    Theme
  ) |>
  arrange(
    desc(Normalised_Score),
    .by_group = TRUE
  ) |>
  mutate(
    Theme_Rank = min_rank(desc(Normalised_Score))
  ) |>
  ungroup()

# ====================================
# Validation
# ====================================

theme_rankings |>
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
  theme_rankings,
  "data/processed/theme_rankings.csv"
)

file.exists(
  "data/processed/theme_rankings.csv"
)