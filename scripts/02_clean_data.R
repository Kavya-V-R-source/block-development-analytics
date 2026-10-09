# ====================================
# Block Development Analytics
# Script 02 - Clean Data
# Author: Kavya V R
# ====================================

library(tidyverse)

source("scripts/01_import_data.R")

# ====================================
# Function: Clean Three-Year Data Sheet
# ====================================

clean_three_year_sheet <- function(data) {
  
  # Extract block names
  block_names <- unlist(
    data[1, 5:ncol(data)]
  ) |>
    str_remove("BLOCK \\(") |>
    str_remove("\\)")
  
  # Extract year labels
  year_labels <- unlist(
    data[2, 5:ncol(data)]
  )
  
  # Remove header rows
  data <- data[-c(1, 2), ]
  
  # Rename metadata columns
  names(data)[1:4] <- c(
    "SNO",
    "KDI",
    "Indicator",
    "Theme"
  )
  
  # Rename value columns
  names(data)[5:ncol(data)] <-
    paste(
      block_names,
      year_labels,
      sep = "__"
    )
  
  # Convert to tidy format
  data <- data |>
    pivot_longer(
      cols = 5:ncol(data),
      names_to = c("Block", "Year"),
      names_sep = "__",
      values_to = "Actual_Value"
    ) |>
    mutate(
      Block = str_to_upper(Block),
      
      Block = case_when(
        Block == "KALVARAYAN HILLS" ~ "KALRAYAN HILLS",
        TRUE ~ Block
      ),
      
      Year = case_when(
        Year == "Baseline (2023-2024)" ~ "2023-24",
        Year == "2024-2025 Data" ~ "2024-25",
        Year == "2025-2026 Data" ~ "2025-26",
        TRUE ~ Year
      ),
      
      Actual_Value = na_if(Actual_Value, "Pending"),
      Actual_Value = na_if(Actual_Value, "NA"),
      Actual_Value = na_if(Actual_Value, "NIL"),
      
      Actual_Value = suppressWarnings(
        as.numeric(Actual_Value)
      )
    )
  
}

# ====================================
# Function: Clean Block Target Sheet
# ====================================

clean_block_target_sheet <- function(data, target_year) {
  
  # Extract district names
  district_names <- unlist(
    data[1, 8:ncol(data)]
  )
  
  # Extract block names
  block_names <- unlist(
    data[2, 8:ncol(data)]
  ) |>
    str_remove("BLOCK \\(") |>
    str_remove("\\)")
  
  # Remove header rows
  data <- data[-c(1:4), ]
  
  # Remove Tile_ID column
  data <- data |>
    select(-3)
  
  # Rename metadata columns
  names(data)[1:6] <- c(
    "SNO",
    "KDI",
    "Indicator",
    "Theme",
    "Direction",
    "Periodicity"
  )
  
  # Rename block columns
  names(data)[7:ncol(data)] <- block_names
  
  # Convert to tidy format
  data <- data |>
    pivot_longer(
      cols = 7:ncol(data),
      names_to = "Block",
      values_to = "Target_Value"
    )
  
  # Create block lookup table
  lookup_table <- tibble(
    District = district_names,
    Block = block_names
  )
  
  # Add district names
  data <- data |>
    left_join(
      lookup_table,
      by = "Block"
    ) |>
    relocate(
      District,
      Block
    ) |>
    mutate(
      District = str_to_upper(District),
      Block = str_to_upper(Block),
      
      Block = case_when(
        Block == "KALRAYANHILLS" ~ "KALRAYAN HILLS",
        TRUE ~ Block
      ),
      
      Year = target_year,
      
      Target_Value = na_if(Target_Value, "Pending"),
      Target_Value = na_if(Target_Value, "NA"),
      Target_Value = na_if(Target_Value, "NIL"),
      
      Target_Value = suppressWarnings(
        as.numeric(Target_Value)
      )
    )
  
  return(data)
  
}

# ====================================
# Function: Clean District Data Sheet
# ====================================

clean_district_sheet <- function(data, year, district_row) {
  
  # Extract district names
  district_names <- unlist(
    data[district_row, 8:ncol(data)]
  )
  
  # Remove header rows
  data <- data[-c(1:4), ]
  
  # Remove Tile_ID column
  data <- data |>
    select(-3)
  
  # Rename metadata columns
  names(data)[1:6] <- c(
    "SNO",
    "KDI",
    "Indicator",
    "Theme",
    "Direction",
    "Periodicity"
  )
  
  # Rename district columns
  names(data)[7:ncol(data)] <- district_names
  
  # Convert to tidy format
  data <- data |>
    pivot_longer(
      cols = 7:ncol(data),
      names_to = "District",
      values_to = "District_Value"
    ) |>
    mutate(
      District = str_to_upper(District),
      
      Year = year,
      
      District_Value = na_if(District_Value, "Pending"),
      District_Value = na_if(District_Value, "NA"),
      District_Value = na_if(District_Value, "NIL"),
      
      District_Value = suppressWarnings(
        as.numeric(District_Value)
      )
    )
  
  return(data)
  
}

# ====================================
# Clean Three-Year Dataset
# ====================================

clean_three_year <-
  clean_three_year_sheet(
    three_year_data
  )

# ====================================
# Clean Block Target Datasets
# ====================================

clean_first_year_target <-
  clean_block_target_sheet(
    first_year_target,
    "2024-25"
  )

clean_second_year_target <-
  clean_block_target_sheet(
    second_year_target,
    "2025-26"
  )

# ====================================
# Clean District Datasets
# ====================================

clean_district_baseline <-
  clean_district_sheet(
    district_baseline,
    "2023-24",
    district_row = 1
  )

clean_district_2025 <-
  clean_district_sheet(
    district_2025,
    "2024-25",
    district_row = 2
  )

clean_district_2026 <-
  clean_district_sheet(
    district_2026,
    "2025-26",
    district_row = 2
  )

# ====================================
# Inspect Cleaned Datasets
# ====================================

glimpse(clean_three_year)

glimpse(clean_first_year_target)

glimpse(clean_second_year_target)

glimpse(clean_district_baseline)

glimpse(clean_district_2025)

glimpse(clean_district_2026)