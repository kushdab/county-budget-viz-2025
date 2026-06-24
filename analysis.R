# County Budget Visualization Suite 2025
# Purpose: Analyzing resource allocation across 47 counties
# Author: Data Analysis Team

library(tidyverse)
library(scales)
library(patchwork)

# 1. Data Simulation / Loading
# Generating synthetic treasury data representing 47 counties for the 2025 fiscal year
set.seed(2025)
counties <- c("Mombasa", "Kwale", "Kilifi", "Tana River", "Lamu", "Taita Taveta", 
              "Garissa", "Wajir", "Mandera", "Marsabit", "Isiolo", "Meru", 
              "Tharaka-Nithi", "Embu", "Kitui", "Machakos", "Makueni", "Nyandarua", 
              "Nyeri", "Kirinyaga", "Murang'a", "Kiambu", "Turkana", "West Pokot", 
              "Samburu", "Trans Nzoia", "Uasin Gishu", "Elgeyo-Marakwet", "Nandi", 
              "Baringo", "Laikipia", "Nakuru", "Narok", "Kajiado", "Kericho", 
              "Bomet", "Kakamega", "Vihiga", "Bungoma", "Busia", "Siaya", 
              "Kisumu", "Homa Bay", "Migori", "Kisii", "Nyamira", "Nairobi")

regions <- c("Coast", "North Eastern", "Eastern", "Central", "Rift Valley", "Western", "Nyanza", "Nairobi")

budget_data <- data.frame(
  county_name = counties,
  region = sample(regions, 47, replace = TRUE),
  total_allocation = runif(47, 5e9, 35e9),
  actual_expenditure = 0,
  healthcare_pct = runif(47, 0.15, 0.30),
  infrastructure_pct = runif(47, 0.20, 0.40),
  education_pct = runif(47, 0.10, 0.25)
) %>%
  mutate(actual_expenditure = total_allocation * runif(47, 0.75, 0.95))

# 2. Data Processing & Metrics
summary_stats <- budget_data %>%
  group_by(region) %>%
  summarise(
    avg_allocation = mean(total_allocation),
    total_region_budget = sum(total_allocation),
    efficiency_ratio = mean(actual_expenditure / total_allocation)
  ) %>% 
  arrange(desc(total_region_budget))

# 3. Visualization Suite

# Plot A: Top 10 Counties by Budget Allocation
p1 <- budget_data %>%
  slice_max(total_allocation, n = 10) %>%
  ggplot(aes(x = reorder(county_name, total_allocation), y = total_allocation, fill = region)) +
  geom_col(show.legend = TRUE) +
  coord_flip() +
  scale_y_continuous(labels = unit_format(unit = "B", scale = 1e-9)) +
  labs(
    title = "Top 10 High-Budget Counties (2025)",
    subtitle = "Allocations in Billions (KES)",
    x = "County",
    y = "Budget Allocation"
  ) +
  theme_minimal()

# Plot B: Budget vs Expenditure Correlation
p2 <- ggplot(budget_data, aes(x = total_allocation, y = actual_expenditure)) +
  geom_point(aes(color = region), size = 3, alpha = 0.7) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  scale_x_continuous(labels = unit_format(unit = "B", scale = 1e-9)) +
  scale_y_continuous(labels = unit_format(unit = "B", scale = 1e-9)) +
  labs(
    title = "Budget Utilization Efficiency",
    subtitle = "Allocated vs Actual Spending",
    x = "Allocated Budget",
    y = "Actual Expenditure"
  ) +
  theme_light()

# Plot C: Sectoral Breakdown Distribution
p3 <- budget_data %>%
  pivot_longer(cols = ends_with("_pct"), names_to = "Sector", values_to = "Percentage") %>%
  ggplot(aes(x = Sector, y = Percentage, fill = Sector)) +
  geom_boxplot() +
  scale_y_continuous(labels = percent) +
  labs(
    title = "Priority Sector Allocation Variance",
    x = "Sector",
    y = "Percentage of Total Budget"
  ) +
  theme_classic() + 
  theme(legend.position = "none")

# 4. Export and Output
cat("--- County Budget Analysis 2025 Report ---\n")
cat("Total National Budget Allocated:", sum(budget_data$total_allocation) / 1e9, "Billion\n")
cat("Average Utilization Rate:", mean(budget_data$actual_expenditure / budget_data$total_allocation) * 100, "%\n")

# Combine plots and save
final_viz <- (p1 | p2) / p3 +
  plot_annotation(title = "Public Treasury Report: 2025 County Resource Allocation",
                  theme = theme(plot.title = element_text(size = 18, face = "bold")))

ggsave("budget_analysis_2025.png", final_viz, width = 14, height = 10)
message("Analysis complete. visualization saved to budget_analysis_2025.png")