# Cyclistic Case Study (Divvy)
# 00 - Import + Standardize + Merge (2019 Q1 + 2020 Q1)
# Author: Alicia Parsons

library(tidyverse)
library(lubridate)

# ---- Paths ----
path_2019 <- "data_raw/Divvy_Trips_2019_Q1.csv"
path_2020 <- "data_raw/Divvy_Trips_2020_Q1.csv"

# ---- Load raw data ----
divvy_2019_raw <- read_csv(path_2019, show_col_types = FALSE)
divvy_2020_raw <- read_csv(path_2020, show_col_types = FALSE)

# ---- Standardize 2019 (old schema) ----
divvy_2019 <- divvy_2019_raw %>%
  rename(
    ride_id = trip_id,
    started_at = start_time,
    ended_at = end_time,
    start_station_name = from_station_name,
    start_station_id = from_station_id,
    end_station_name = to_station_name,
    end_station_id = to_station_id,
    member_casual = usertype
  ) %>%
  mutate(
    ride_id = as.character(ride_id),
    
    # 2019 doesn't include rideable_type; keep for schema consistency
    rideable_type = NA_character_,
    
    start_station_id = as.character(start_station_id),
    end_station_id   = as.character(end_station_id),
    
    # Normalize membership labels to match 2020
    member_casual = case_when(
      member_casual == "Subscriber" ~ "member",
      member_casual == "Customer"   ~ "casual",
      TRUE ~ as.character(member_casual)
    )
  ) %>%
  select(
    ride_id, rideable_type,
    started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    member_casual
  )

# ---- Standardize 2020 (new schema) ----
divvy_2020 <- divvy_2020_raw %>%
  mutate(
    ride_id = as.character(ride_id),
    start_station_id = as.character(start_station_id),
    end_station_id   = as.character(end_station_id),
    
    # Keep only member/casual (just in case)
    member_casual = case_when(
      member_casual %in% c("member", "casual") ~ member_casual,
      TRUE ~ as.character(member_casual)
    )
  ) %>%
  select(
    ride_id, rideable_type,
    started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    member_casual
  )

# ---- Merge + feature engineering ----
divvy_all <- bind_rows(divvy_2019, divvy_2020) %>%
  mutate(
    started_at = ymd_hms(started_at, quiet = TRUE),
    ended_at   = ymd_hms(ended_at, quiet = TRUE),
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
    day_of_week = wday(started_at, label = TRUE, abbr = TRUE)
  ) %>%
  filter(
    !is.na(started_at),
    !is.na(ended_at),
    !is.na(ride_length),
    ride_length > 0,
    !is.na(member_casual),
    member_casual %in% c("member", "casual")   # enforce only these two
  )

# ---- Export cleaned dataset ----
dir.create("data_clean", showWarnings = FALSE)
write_csv(divvy_all, "data_clean/divvy_2019_2020_clean.csv")

cat("Exported rows:", nrow(divvy_all), "\n")
cat("Member types:", paste(unique(divvy_all$member_casual), collapse = ", "), "\n")

# Optional memory cleanup
rm(divvy_2019_raw, divvy_2020_raw, divvy_2019, divvy_2020)
gc()

