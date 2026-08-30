# ====================================
# FBDP Analytics Portfolio
# Script 08 - Visualisations
# Author: Kavya V R
# ====================================

library(tidyverse)

# ====================================
# Load Dashboard Dataset
# ====================================

dashboard_data <- read_csv(
  "data/processed/dashboard_data.csv",
  show_col_types = FALSE
)

indicator_master <- read_csv(
  "data/processed/indicator_master.csv",
  show_col_types = FALSE
)

# ====================================
# Chart 1
# Indicator Distribution by Theme
# ====================================

indicator_master |>
  count(Theme) |>
  ggplot(
    aes(
      x = reorder(Theme, n),
      y = n
    )
  ) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Indicator Distribution by Theme",
    x = NULL,
    y = "Number of Indicators"
  )

# ====================================
# Chart 2
# Positive vs Negative Indicators
# ====================================

indicator_master |>
  count(Indicator_Type) |>
  ggplot(
    aes(
      x = "",
      y = n,
      fill = Indicator_Type
    )
  ) +
  geom_col(
    width = 1
  ) +
  coord_polar(
    theta = "y"
  ) +
  labs(
    title = "Positive vs Negative Indicators"
  ) +
  theme_void()

# ====================================
# Chart 3
# Missing Actual Values by Theme
# ====================================

dashboard_data |>
  group_by(Theme) |>
  summarise(
    Missing_Actual_Pct =
      mean(
        is.na(Actual_Value)
      ) * 100
  ) |>
  ggplot(
    aes(
      x = reorder(
        Theme,
        Missing_Actual_Pct
      ),
      y = Missing_Actual_Pct
    )
  ) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Missing Actual Values by Theme",
    x = NULL,
    y = "Percent Missing"
  )

# ====================================
# Save Charts
# ====================================

ggsave(
  "outputs/chart_indicator_distribution.png",
  width = 8,
  height = 5
)

ggsave(
  "outputs/chart_indicator_direction.png",
  width = 6,
  height = 6
)

ggsave(
  "outputs/chart_missing_actuals.png",
  width = 8,
  height = 5
)

# ====================================
# End of Script 08
# ====================================
