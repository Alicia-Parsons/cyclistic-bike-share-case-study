# Cyclistic Case Study (Divvy)
# 01 - Data Cleaning + Summary Outputs (for visuals)
# Author: Alicia Parsons
#
# Prereq:
# Run scripts/00_import_and_merge.R first to generate:
# data_clean/divvy_2019_2020_clean.csv

library(tidyverse)
library(lubridate)

# ---- Load cleaned, merged dataset ----
divvy <- read_csv("data_clean/divvy_2019_2020_clean.csv", show_col_types = FALSE)

# ---- Sanity check: membership labels should already be normalized ----
member_levels <- sort(unique(divvy$member_casual))
cat("Member types found:", paste(member_levels, collapse = ", "), "\n")

# If anything besides member/casual appears, stop here (prevents bad visuals)
stopifnot(all(member_levels %in% c("member", "casual")))

# ---- Ensure datetime fields are parsed (quietly) ----
# (00 script already does this, but this makes 01 robust if file is reloaded later)
divvy <- divvy %>%
  mutate(
    started_at = ymd_hms(started_at, quiet = TRUE),
    ended_at   = ymd_hms(ended_at, quiet = TRUE)
  )

# ---- Ensure ride_length exists; compute only if missing ----
if (!("ride_length" %in% names(divvy))) {
  divvy <- divvy %>%
    mutate(ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")))
}

# ---- Ensure day_of_week exists; compute only if missing ----
if (!("day_of_week" %in% names(divvy))) {
  divvy <- divvy %>%
    mutate(day_of_week = wday(started_at, label = TRUE, abbr = TRUE, week_start = 1))
}

# ---- Light cleanup (protect analysis) ----
divvy <- divvy %>%
  filter(
    !is.na(started_at),
    !is.na(ended_at),
    !is.na(ride_length),
    ride_length > 0
  )

# ---- Force weekday order (Mon -> Sun) for cleaner visuals ----
divvy <- divvy %>%
  mutate(day_of_week = factor(
    day_of_week,
    levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"),
    ordered = TRUE
  ))

# ---- Summary 1: by rider type x weekday ----
by_day <- divvy %>%
  group_by(member_casual, day_of_week) %>%
  summarise(
    rides = n(),
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    .groups = "drop"
  )

# ---- Export summary files for visuals / GitHub ----
dir.create("data_clean", showWarnings = FALSE)

write_csv(by_day, "data_clean/by_day_summary.csv")

# Optional: a second summary that some templates use (kept for flexibility)
write_csv(by_day, "data_clean/divvy_summary_by_day.csv")

cat("Wrote: data_clean/by_day_summary.csv\n")

# ---- Memory cleanup (Posit Cloud friendly) ----
rm(divvy)
gc()
