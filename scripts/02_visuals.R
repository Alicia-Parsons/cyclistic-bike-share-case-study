# Cyclistic Case Study (Divvy)
# 02 - Visuals (from summary file only)
# Author: Alicia Parsons
#
# Prereq:
# Run scripts/01_data_cleaning_and_summary.R to generate:
# data_clean/by_day_summary.csv

library(tidyverse)
library(scales)   # for comma() + label_number()
library(ggplot2)

# ---- Load summary dataset (small + safe) ----
by_day <- read_csv("data_clean/by_day_summary.csv", show_col_types = FALSE)

# ---- Ensure clean labels + ordering ----
by_day <- by_day %>%
  mutate(
    member_casual = factor(member_casual, levels = c("casual", "member")),
    day_of_week = factor(
      day_of_week,
      levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"),
      ordered = TRUE
    )
  )

# Create output folder if it doesn't exist
dir.create("Visuals", showWarnings = FALSE)

# =========================================================
# VISUAL 1: Number of Rides by Day of Week (Member vs Casual)
# =========================================================
p1 <- ggplot(by_day, aes(x = day_of_week, y = rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Number of Rides by Day of Week",
    subtitle = "Members ride more frequently, especially on weekdays",
    x = "Day of Week",
    y = "Number of Rides",
    fill = "User Type"
  ) +
  theme_minimal()

print(p1)

ggsave(
  filename = "Visuals/number_of_rides_by_day.png",
  plot = p1,
  width = 10, height = 6, dpi = 300
)

# =========================================================
# VISUAL 2: Average Ride Length by Day of Week
# =========================================================
p2 <- ggplot(by_day, aes(x = day_of_week, y = avg_ride_length, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = function(x) paste0(round(x), " min")) +
  labs(
    title = "Average Ride Length by Day of Week",
    subtitle = "Casual riders take longer rides, especially on weekends",
    x = "Day of Week",
    y = "Average Ride Length (minutes)",
    fill = "User Type"
  ) +
  theme_minimal()

print(p2)

ggsave(
  filename = "Visuals/avg_ride_length_by_day.png",
  plot = p2,
  width = 10, height = 6, dpi = 300
)

# =========================================================
# Optional: Export as PDF versions too (nice for GitHub viewing)
# =========================================================
ggsave("Visuals/number_of_rides_by_day.pdf", plot = p1, width = 10, height = 6)
ggsave("Visuals/avg_ride_length_by_day.pdf", plot = p2, width = 10, height = 6)

cat("Saved visuals to /Visuals:\n",
    "- number_of_rides_by_day.png\n",
    "- avg_ride_length_by_day.png\n",
    "- number_of_rides_by_day.pdf\n",
    "- avg_ride_length_by_day.pdf\n")
