# Cyclistic Case Study (Divvy)
# 01 - Analysis Summary + Export (by day of week)
# Author: Alicia Parsons
#
# NOTE:
# This script assumes raw data has already been imported, standardized,
# and merged into a single dataset.
# Run scripts/00_import_and_merge.R first to generate:
# data_clean/divvy_2019_2020_clean.csv

library(tidyverse)
library(lubridate)

# -------------------------
# Load cleaned, merged dataset
# -------------------------
# IMPORTANT: In Posit Cloud, your working directory is typically the project root,
# so use this path (no leading ../)
divvy <- read_csv("data_clean/divvy_2019_2020_clean.csv", show_col_types = FALSE)

# -------------------------
# Light-touch validation (no heavy transformations)
# -------------------------
# Ensure expected member categories only
divvy <- divvy %>%
  mutate(
    member_casual = as.character(member_casual)
  ) %>%
  filter(member_casual %in% c("member", "casual"))

# If started_at/ended_at are already POSIXct from script 00, this is harmless.
# If they came in as character, this fixes them.
divvy <- divvy %>%
  mutate(
    started_at = ymd_hms(started_at, quiet = TRUE),
    ended_at   = ymd_hms(ended_at, quiet = TRUE)
  )

# Ensure ride_length/day_of_week exist (script 00 creates them, but we keep this robust)
divvy <- divvy %>%
  mutate(
    ride_length = if_else(
      is.na(ride_length),
      as.numeric(difftime(ended_at, started_at, units = "mins")),
      ride_length
    ),
    # week_start = 1 makes Monday the first day (matches typical business view)
    day_of_week = if_else(
      is.na(day_of_week),
      as.character(wday(started_at, label = TRUE, abbr = TRUE, week_start = 1)),
      as.character(day_of_week)
    )
  ) %>%
  filter(!is.na(ride_length), ride_length > 0, !is.na(day_of_week))

# -------------------------
# Summarize usage patterns by rider type and weekday
# -------------------------
by_day <- divvy %>%
  group_by(member_casual, day_of_week) %>%
  summarise(
    rides = n(),
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    .groups = "drop"
  )

# Optional: order weekdays nicely (Mon -> Sun) for plots/tables
by_day <- by_day %>%
  mutate(
    day_of_week = factor(
      day_of_week,
      levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
    )
  ) %>%
  arrange(member_casual, day_of_week)

# -------------------------
# Export summary for plotting (small + memory friendly)
# -------------------------
dir.create("data_clean", showWarnings = FALSE)
write_csv(by_day, "data_clean/by_day_summary.csv")

cat("Saved summary file: data_clean/by_day_summary.csv\n")
cat("Rows in by_day:", nrow(by_day), "\n")
cat("Member categories:", paste(sort(unique(by_day$member_casual)), collapse = ", "), "\n")

# -------------------------
# Memory cleanup (important in Posit Cloud)
# -------------------------
rm(divvy)
gc()
