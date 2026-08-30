# ====================================
# FBDP Analytics Portfolio
# Script 01 - Import Raw Data
# Author: Kavya V R
# ====================================

# ====================================
# Load Packages
# ====================================

library(readxl)
library(tidyverse)
library(janitor)

# ====================================
# File Path
# ====================================

file_path <- "data/raw/Analysis for March 2026 data -trial.xlsx"

# ====================================
# Available Worksheets
# ====================================

excel_sheets(file_path)

# ====================================
# Import Core Datasets
# ====================================

master_data <- read_excel(
  path = file_path,
  sheet = "Master",
  col_names = FALSE
)

three_year_data <- read_excel(
  path = file_path,
  sheet = "3 years of data",
  col_names = FALSE
)

block_baseline <- read_excel(
  path = file_path,
  sheet = "Block Baseline 2024",
  col_names = FALSE
)

district_baseline <- read_excel(
  path = file_path,
  sheet = "District Baseline 2024",
  col_names = FALSE
)

first_year_target <- read_excel(
  path = file_path,
  sheet = "1st year target",
  col_names = FALSE
)

second_year_target <- read_excel(
  path = file_path,
  sheet = "2nd year target",
  col_names = FALSE
)

district_2025 <- read_excel(
  path = file_path,
  sheet = "District - March 2025 data",
  col_names = FALSE
)

district_2026 <- read_excel(
  path = file_path,
  sheet = "District - March 2026 data",
  col_names = FALSE
)

# ====================================
# Inspect Imported Data
# ====================================

glimpse(master_data)

glimpse(three_year_data)

glimpse(block_baseline)

glimpse(district_baseline)

glimpse(first_year_target)

glimpse(second_year_target)

glimpse(district_2025)

glimpse(district_2026)
