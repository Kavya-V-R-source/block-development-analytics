# ====================================
# FBDP Analytics Portfolio
# Script 09 - Ranking Indicator Dataset
# Author: Kavya V R
# ====================================

library(tidyverse)

dashboard_data <- read_csv(
  "data/processed/dashboard_data.csv",
  show_col_types = FALSE
)

# ====================================
# Ranking Indicators (SPC Methodology)
# ====================================

ranking_indicators <- tibble(
  KDI = c(
    "1.A","1.B","1.C",
    "2.A","2.B","2.C","2.D","2.E",
    "3",
    "4.B",
    "5",
    "7.A",
    "8.A","8.B","8.C.a","8.C.b","8.D",
    "9.A","9.B.a","9.B.b",
    "11.A","11.B","11.D",
    
    "12.A.a","12.A.b","12.A.c","12.A.d",
    "12.B.a","12.B.b","12.B.c","12.B.d",
    "13.B.a","13.B.b","13.B.c","13.B.d",
    "13.C","13.D","13.E",
    "14.B","14.C","14.D",
    
    "18",
    "21.A","21.B",
    
    "23",
    "24.A","24.B","24.C",
    
    "26.A","26.C","26.D","26.E",
    "28.A","28.B",
    
    "29","31","32","33.A","33.C",
    "35","36.A","37","38","39",
    
    "40.A","40.B",
    "41.A","41.B","41.C",
    "44"
  )
)

# ====================================
# Create Ranking Dataset
# ====================================

ranking_data <- dashboard_data |>
  semi_join(
    ranking_indicators,
    by = "KDI"
  )

# ====================================
# Validation
# ====================================

ranking_data |>
  summarise(
    Records = n(),
    Indicators = n_distinct(KDI),
    Blocks = n_distinct(Block),
    Years = n_distinct(Year)
  )

ranking_data |>
  count(
    Theme,
    sort = TRUE
  )

# ====================================
# Export Ranking Dataset
# ====================================

write_csv(
  ranking_data,
  "data/processed/ranking_data.csv"
)
