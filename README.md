# From Casual Rides to Committed Members  
**Translating Bike-Share Usage Patterns into Marketing Decisions**

## Quick Summary
- **Goal:** Identify how casual riders and annual members use Cyclistic bikes differently and recommend ways to convert casual riders into members.
- **Approach:** Cleaned and merged trip data, created ride length + weekday features, and compared usage patterns by user type.
- **Outcome:** Clear behavioral differences emerged that support targeted conversion campaigns.


## Project Overview
Cyclistic is a bike-share company seeking to grow its base of annual members. While casual riders already demonstrate engagement with the product, the business challenge is understanding *how* their usage differs from members—and what those differences reveal about conversion opportunities.

This analysis examines historical trip data to identify behavioral patterns between casual riders and annual members, with a focus on translating those patterns into actionable marketing insights.

---

## Business Question
**How do annual members and casual riders use Cyclistic bikes differently, and what do those differences suggest for membership growth strategies?**

---

## Stakeholders
- Director of Marketing  
- Marketing Analytics Team  
- Executive Leadership  

---

## Data Sources
- Divvy Trips Q1 2019  
- Divvy Trips Q1 2020  

These public datasets, provided by Motivate International Inc., are used as a proxy for Cyclistic’s historical trip data. Personally identifiable rider information is excluded to ensure privacy.

---
## Data Standardization Notes
Divvy datasets differ across years. Older data uses `Subscriber`/`Customer`, while newer data uses `member`/`casual`.
For consistency, rider types were standardized to two categories:
- Subscriber → member
- Customer → casual

Ride IDs were coerced to character type to prevent merge issues across files.

---

## Tools & Technologies
- R (Posit Cloud)
- tidyverse: dplyr, lubridate, ggplot2
- CSV data files

---

## Data Preparation & Analytical Decisions
The datasets required careful preparation before analysis due to structural differences across years.
A curated R script illustrating key data cleaning and feature engineering steps is included in the `scripts/` folder.

Key decisions included:
- Standardizing column names between the 2019 and 2020 datasets  
- Recreating derived variables (ride length and day of week) to ensure consistency  
- Removing rides with invalid or negative durations  
- Exporting a cleaned, merged dataset for stable downstream analysis  

These steps were taken deliberately to support valid comparisons and reduce the risk of misleading conclusions.

---

## Analysis Summary
Several clear behavioral differences emerged:

- **Annual members** take significantly more rides overall, with usage concentrated during weekdays  
- **Casual riders** take fewer rides but with substantially longer durations  
- Casual rider activity peaks on weekends, while member usage is more evenly distributed across the workweek  

These patterns suggest two distinct usage modes: routine, purpose-driven travel among members and leisure-oriented usage among casual riders.

---

📄 **Written Case Study Report**  
- [Word Document](reports/Cyclistic_Case_Study_Analysis.docx)

📊 **Executive Summary Presentation**  
- [View PDF](slides/Cyclistic_Case_Study_Presentation.pdf)  
- [Download PPTX](slides/Cyclistic_Case_Study_Presentation.pptx)


---

## Visual Highlights
*(Visuals included in the repository and presentation)*

- Average Ride Length by Day of Week and User Type  
- Number of Rides by Day of Week and User Type  

Each visualization was designed to emphasize behavioral differences rather than raw volume alone.

---

## Key Insights
- Ride **frequency** and **duration** tell different stories—and both are necessary to understand rider intent  
- Casual riders already demonstrate strong product engagement through longer ride durations  
- The primary barrier to conversion appears to be commitment rather than awareness  

---

## Recommendations

**1. Focus membership marketing on peak casual usage periods**  
Weekend-timed promotions align with when casual riders are most engaged.

**2. Introduce short-term or trial memberships**  
Lower-commitment options can bridge the gap between casual usage and annual plans.

**3. Use behavior-based digital targeting**  
Align in-app messaging and digital ads with leisure-oriented usage patterns to improve relevance.

---

## Limitations
- Analysis is limited to Q1 data and may not capture full seasonal variation  
- Geographic and repeat-rider patterns were not explored due to scope constraints  
- Results are directionally informative rather than predictive  

---

## Future Exploration
With additional data, further analysis could include:
- Full-year seasonal trends  
- Station-level and geographic behavior patterns  
- Repeat casual rider conversion signals  

---

## Analyst Perspective
This project emphasized careful handling of real-world data inconsistencies and thoughtful interpretation over surface-level metrics. Rather than treating data preparation as a mechanical step, analytical decisions were made intentionally to support reliable insights and business-relevant conclusions.

---

## How to Reproduce
1. Load cleaned dataset from `data_clean/divvy_2019_2020_clean.csv`  
2. Run analysis scripts in `/scripts`  
3. Generate visuals using `ggplot2`  

---

*This case study was completed as part of the Google Data Analytics Professional Certificate capstone.*
