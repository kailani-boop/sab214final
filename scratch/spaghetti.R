library(tidyverse)

# Extract needed columns
q1_data <- read_csv("data/QuebradaCuenca1-Bisley.csv")
q2_data <- read_csv("data/QuebradaCuenca2-Bisley.csv")
q3_data <- read_csv("data/QuebradaCuenca3-Bisley.csv")
mpr_data <- read_csv("data/RioMameyesPuenteRoto.csv")

# Testing cleaning Q1
q1_clean <- q1_data |>
  select(Sample_ID, Sample_Date, K, `NO3-N`, Mg, Ca, `NH4-N`)

# Test combining all data frames
big_data <- bind_rows(q1_data, q2_data, q3_data, mpr_data)
# Select necessary columns
data_clean <- select(
  big_data,
  Sample_ID,
  Sample_Date,
  K,
  `NO3-N`,
  Mg,
  Ca,
  `NH4-N`
)


data_long <- data_clean |>
  pivot_longer(
    cols = c(K, `NO3-N`, Mg, Ca, `NH4-N`),
    names_to = "ion",
    values_to = "concentration"
  )

ggplot(
  data = data_long,
  mapping = aes(
    x = Sample_Date,
    y = concentration,
    color = Sample_ID
  )
) +
  geom_point() +
  facet_wrap(~ion)

# Find moving average of all concentrations for q1

q1_ave <- tibble(
  Sample_ID = "Q1",
  window_start = seq(
    from = ymd(q1_data$Sample_Date[1]),
    to = ymd(q1_data$Sample_Date[nrow(q1_data)]),
    by = "9 weeks"
  ),
  K = NA,
  `NO3-N` = NA,
  Mg = NA,
  Ca = NA,
  `NH4-N` = NA
)

for (i in 1:nrow(q1_ave)) {
  start_date <- q1_ave$window_start[i]
  end_date <- q1_ave$window_start[i] + weeks(9)

  window_dates <- filter(
    q1_data,
    Sample_ID == "Q1",
    Sample_Date >= start_date,
    Sample_Date < end_date
  )

  mean_k <- mean(window_dates$K, na.rm = TRUE)
  q1_ave$K[i] <- mean_k

  mean_NO3N <- mean(window_dates$`NO3-N`, na.rm = TRUE)
  q1_ave$`NO3-N`[i] <- mean_NO3N

  mean_mg <- mean(window_dates$Mg, na.rm = TRUE)
  q1_ave$Mg[i] <- mean_mg

  mean_ca <- mean(window_dates$Ca, na.rm = TRUE)
  q1_ave$Ca[i] <- mean_ca

  mean_NH4N <- mean(window_dates$`NH4-N`, na.rm = TRUE)
  q1_ave$`NH4-N`[i] <- mean_NH4N
}

q1_long <- q1_ave |>
  pivot_longer(
    cols = c(K, `NO3-N`, Mg, Ca, `NH4-N`),
    names_to = "ion",
    values_to = "concentration"
  )

ggplot(
  data = q1_long,
  mapping = aes(
    x = window_start,
    y = concentration,
    color = Sample_ID
  )
) +
  geom_line() +
  facet_wrap(~ion, scales = "free_y", ncol = 1)

# Q2 site moving averages
q2_ave <- tibble(
  Sample_ID = "Q2",
  window_start = seq(
    from = ymd(data_clean$Sample_Date[1]),
    to = ymd(data_clean$Sample_Date[nrow(data_clean)]),
    by = "9 weeks"
  ),
  K = NA,
  `NO3-N` = NA,
  Mg = NA,
  Ca = NA,
  `NH4-N` = NA
)

for (i in 1:nrow(q2_ave)) {
  start_date <- q2_ave$window_start[i]
  end_date <- q2_ave$window_start[i] + weeks(9)

  window_dates <- filter(
    data_clean,
    Sample_ID == "Q2",
    Sample_Date >= start_date,
    Sample_Date < end_date
  )

  mean_k <- mean(window_dates$K, na.rm = TRUE)
  q2_ave$K[i] <- mean_k

  mean_NO3N <- mean(window_dates$`NO3-N`, na.rm = TRUE)
  q2_ave$`NO3-N`[i] <- mean_NO3N

  mean_mg <- mean(window_dates$Mg, na.rm = TRUE)
  q2_ave$Mg[i] <- mean_mg

  mean_ca <- mean(window_dates$Ca, na.rm = TRUE)
  q2_ave$Ca[i] <- mean_ca

  mean_NH4N <- mean(window_dates$`NH4-N`, na.rm = TRUE)
  q2_ave$`NH4-N`[i] <- mean_NH4N
}
# Long q2
q2_long <- q2_ave |>
  pivot_longer(
    cols = c(K, `NO3-N`, Mg, Ca, `NH4-N`),
    names_to = "ion",
    values_to = "concentration"
  )

q1_q2 <- bind_rows(q1_long, q2_long)

ggplot(
  data = q1_q2,
  mapping = aes(
    x = window_start,
    y = concentration,
    color = Sample_ID
  )
) +
  geom_line() +
  facet_wrap(~ion, scales = "free_y", ncol = 1)

# Note: will need to create a function to make moving averages

source("R/moving-average.R")
q1_mov_ave <- moving_average(q1_data)
q2_mov_ave <- moving_average(q2_data)
q3_mov_ave <- moving_average(q3_data)
mpr_mov_ave <- moving_average(mpr_data)

all_mov_ave <- bind_rows(q1_mov_ave, q2_mov_ave, q3_mov_ave, mpr_mov_ave)

all_mov_ave_long <- all_mov_ave |>
  pivot_longer(
    cols = c(k_mgl, no3n_ugl, mg_mgl, ca_mgl, nh4n_ugl),
    names_to = "ion",
    values_to = "concentration"
  )

ggplot(
  data = all_mov_ave_long,
  mapping = aes(
    x = window_start,
    y = concentration,
    color = site_id
  )
) +
  geom_line() +
  facet_wrap(~ion, scales = "free_y", ncol = 1) +
  labs(
    subtitle = "Concentrations in Bisley, Puerto Rico streams before and after Hurricane Hugo, 9-wk moving averages.
    (a) potassium, (b) nitrate-N, (c) magnesium, (d) calcium and (e) ammonium-N. The vertical lines mark 
    the time of hurricane disturbance."
  ) +
  geom_vline(
    mapping = aes(x = ymd("1989-09-18"))
  )
