library(tidyverse)

# Read in ion data for each site in Bisley, Puerto Rico
q1_data <- read_csv("data/QuebradaCuenca1-Bisley.csv")
q2_data <- read_csv("data/QuebradaCuenca2-Bisley.csv")
q3_data <- read_csv("data/QuebradaCuenca3-Bisley.csv")
mpr_data <- read_csv("data/RioMameyesPuenteRoto.csv")

# Calculate the moving average for each site at 9 week windows
source("R/moving-average.R")

q1_mov_ave <- moving_average(q1_data)
q2_mov_ave <- moving_average(q2_data)
q3_mov_ave <- moving_average(q3_data)
mpr_mov_ave <- moving_average(mpr_data)

# Combine all sites into one data frame
bisley_mov_ave <- bind_rows(q1_mov_ave, q2_mov_ave, q3_mov_ave, mpr_mov_ave)

# Convert ions and concentrations to separate columns for plotting
bisley_mov_ave_long <- bisley_mov_ave |>
  pivot_longer(
    cols = c(k_mgl, no3n_ugl, mg_mgl, ca_mgl, nh4n_ugl),
    names_to = "ion",
    values_to = "concentration"
  )

write_csv(bisley_mov_ave_long, "output/bisley_mov_ave_long.csv")
