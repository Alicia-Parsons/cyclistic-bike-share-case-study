# Cyclistic Case Study (Divvy)
# 00 - Import + Standardize + Merge (2019 Q1 + 2020 Q1)
# Author: Alicia Parsons
# Purpose:
#   - Load raw trip data from 2019 and 2020
#   - Standardize columns so both years match
#   - Create core analysis features (ride_length, day_of_week)
#   - Export a cleaned, merged dataset for analysis scripts

library(tidyverse)
library(lubridate)

# -------------------------
# File paths (edit if needed)
# -------------------------
path_2019 <- "data_raw/Divvy_Trips_2019_Q1.csv"
path_2020 <- "data_raw/Divvy_Trips_2020_Q1.csv"

# -------------------------
# Load raw data
# -------------------------
divvy_2019_raw <- read_csv(path_2019, show_col_types = FALSE)
divvy_2020_raw <- read_csv(path_2020, show_col_types = FALSE)

# -------------------------
# Standardize 2019 schema to match 2020-style fields
# -------------------------
# Common fields we want across both:
# ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id,
# end_station_name, end_station_id, member_casual

divvy_2019 <- divvy_2019_raw %>%
  rename(
    ride_id = trip_id,
    started_at = started_at,
    ended_at = ended_at,
    start_station_name = start_station_name,
    start_station_id = start_station_id,
    end_station_name = end_station_name,
    end_station_id = end_station_id,
    member_casual = usertype
  ) %>%
  mutate(
    # 2019 may not include rideable_type; keep for schema consistency
    rideable_type = if ("rideable_type" %in% names(.)) rideable_type else NA_character_,
    start_station_id = as.character(start_station_id),
    end_station_id   = as.character(end_station_id)
  ) %>%
  select(
    ride_id, rideable_type,
    started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    member_casual
  )

# -------------------------
# Standardize 2020 schema (keep same fields)
# -------------------------
divvy_2020 <- divvy_2020_raw %>%
  mutate(
    start_station_id = as.character(start_station_id),
    end_station_id   = as.character(end_station_id)
  ) %>%
  select(
    ride_id, rideable_type,
    started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    member_casual
  )

# -------------------------
# Merge + feature engineering
# -------------------------
divvy <- bind_rows(divvy_2019, divvy_2020) %>%
  mutate(
    started_at = ymd_hms(started_at, quiet = TRUE),
    ended_at   = ymd_hms(ended_at, quiet = TRUE),
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
    day_of_week = wday(started_at, label = TRUE, abbr = TRUE)
  ) %>%
  # remove rows that would distort analysis
  filter(
    !is.na(started_at),
    !is.na(ended_at),
    !is.na(ride_length),
    ride_length > 0,
    !is.na(member_casual)
  )

# -------------------------
# Export cleaned dataset
# -------------------------
dir.create("data_clean", showWarnings = FALSE)
write_csv(divvy, "data_clean/divvy_2019_2020_clean.csv")

# Quick sanity prints (optional)
cat("Merged rows exported:", nrow(divvy), "\n")
cat("Columns exported:", paste(names(divvy), collapse = ", "), "\n")

# Memory cleanup (helpful in Posit Cloud)
rm(divvy_2019_raw, divvy_2020_raw, divvy_2019, divvy_2020)
gc()
