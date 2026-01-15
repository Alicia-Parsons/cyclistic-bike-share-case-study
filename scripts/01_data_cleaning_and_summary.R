# Cyclistic Case Study
# Data Cleaning and Feature Engineering
# Author: Alicia Parsons

library(tidyverse)
library(lubridate)

# Load cleaned, merged dataset
divvy <- read_csv("../data_clean/divvy_2019_2020_clean.csv")

# Ensure datetime fields are correctly parsed
divvy <- divvy %>%
  mutate(
    started_at = ymd_hms(started_at),
    ended_at = ymd_hms(ended_at)
  )

# Create derived features used for analysis
divvy <- divvy %>%
  mutate(
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
    day_of_week = wday(started_at, label = TRUE)
  ) %>%
  filter(!is.na(ride_length), ride_length > 0)

# Summarize usage patterns by rider type and weekday
by_day <- divvy %>%
  group_by(member_casual, day_of_week) %>%
  summarise(
    rides = n(),
    avg_ride_length = mean(ride_length),
    .groups = "drop"
  )
