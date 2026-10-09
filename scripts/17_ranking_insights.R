# ====================================
# Block Development Analytics
# Script 17 - Ranking Insights
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Overall Rankings
# ====================================

overall_rankings <- read_csv(
  "data/processed/overall_rankings.csv",
  show_col_types = FALSE
)
theme_rankings <- read_csv(
  "data/processed/theme_rankings.csv",
  show_col_types = FALSE
)

# ====================================
# Top 10 Blocks (2025-26)
# ====================================

top_10_blocks <- overall_rankings |>
  filter(
    Year == "2025-26"
  ) |>
  arrange(
    Overall_Rank
  ) |>
  slice_head(
    n = 10
  )

top_10_blocks

# ====================================
# Bottom 10 Blocks (2025-26)
# ====================================

bottom_10_blocks <- overall_rankings |>
  filter(
    Year == "2025-26"
  ) |>
  arrange(
    desc(Overall_Rank)
  ) |>
  slice_head(
    n = 10
  )

bottom_10_blocks

# ====================================
# Rank Change Analysis
# ====================================

rank_change <- overall_rankings |>
  select(
    Year,
    Block,
    Overall_Rank
  ) |>
  pivot_wider(
    names_from = Year,
    values_from = Overall_Rank
  ) |>
  mutate(
    Rank_Change =
      `2024-25` - `2025-26`
  )

# ====================================
# Biggest Improvers
# ====================================

biggest_improvers <- rank_change |>
  arrange(
    desc(Rank_Change)
  ) |>
  slice_head(
    n = 10
  )

biggest_improvers

# ====================================
# Biggest Decliners
# ====================================

biggest_decliners <- rank_change |>
  arrange(
    Rank_Change
  ) |>
  slice_head(
    n = 10
  )

biggest_decliners

# ====================================
# Validation
# ====================================

rank_change |>
  summarise(
    Blocks = n(),
    Max_Improvement = max(Rank_Change),
    Max_Decline = min(Rank_Change)
  )

# ====================================
# Strongest Theme Per Block
# ====================================

strongest_theme <- theme_rankings |>
  filter(
    Year == "2025-26"
  ) |>
  group_by(
    Block
  ) |>
  slice_max(
    order_by = Theme_Score,
    n = 1,
    with_ties = FALSE
  ) |>
  ungroup() |>
  select(
    Block,
    Strongest_Theme = Theme,
    Strongest_Score = Theme_Score
  )

strongest_theme

# ====================================
# Weakest Theme Per Block
# ====================================

weakest_theme <- theme_rankings |>
  filter(
    Year == "2025-26"
  ) |>
  group_by(
    Block
  ) |>
  slice_min(
    order_by = Theme_Score,
    n = 1,
    with_ties = FALSE
  ) |>
  ungroup() |>
  select(
    Block,
    Weakest_Theme = Theme,
    Weakest_Score = Theme_Score
  )

weakest_theme

# ====================================
# Block Insights
# ====================================

block_insights <- strongest_theme |>
  left_join(
    weakest_theme,
    by = "Block"
  )

block_insights

# ====================================
# Export Insights
# ====================================

write_csv(
  top_10_blocks,
  "data/processed/top_10_blocks.csv"
)

write_csv(
  bottom_10_blocks,
  "data/processed/bottom_10_blocks.csv"
)

write_csv(
  rank_change,
  "data/processed/rank_change.csv"
)

write_csv(
  block_insights,
  "data/processed/block_insights.csv"
)