# County Budget Viz 2025

A comprehensive R-based visualization suite for analyzing public treasury reports across 47 administrative counties.

## Features
- Synthetic data generation for 2025 fiscal projections.
- Regional budget aggregation and efficiency metrics.
- Sector-specific (Health, Education, Infrastructure) priority analysis.
- Multi-panel visualization export.

## Requirements
- R 4.0+
- Libraries: `tidyverse`, `scales`, `patchwork`

## Usage
1. Ensure you have the required libraries installed:
   ```r
   install.packages(c('tidyverse', 'scales', 'patchwork'))
   ```
2. Run the main analysis script:
   ```bash
   Rscript analysis.R
   ```
3. View the generated `budget_analysis_2025.png` file.