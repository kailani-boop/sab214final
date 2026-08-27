# The input to this function should be a data frame containing stream chemistry data
# with a Sample_ID and Sample_Date column
moving_average <- function(site_data) {
  # Initialize a tibble to contain the results
  result <- tibble(
    site_id = site_data$Sample_ID[1],
    window_start = seq(
      from = ymd(site_data$Sample_Date[1]),
      to = ymd(site_data$Sample_Date[nrow(site_data)]),
      by = "9 weeks"
    ),
    k_mgl = NA,
    no3n_ugl = NA,
    mg_mgl = NA,
    ca_mgl = NA,
    nh4n_ugl = NA
  )

  # Fill in the iterator and sequence
  for (i in 1:nrow(result)) {
    # Create variables for the start and end of the current window
    w1 <- result$window_start[i]
    w2 <- result$window_start[i] + weeks(9)

    # Create a logical vector, called "in_window", that says which samples are inside the window
    # Hint: you'll compare sample dates to the start and end of the window
    in_window <- site_data$Sample_Date >= w1 &
      site_data$Sample_Date < w2

    # Use indexing to pull out the ion concentrations that fall inside the window
    k_window <- site_data$K[in_window]
    no3n_window <- site_data$`NO3-N`[in_window]
    mg_window <- site_data$Mg[in_window]
    ca_window <- site_data$Ca[in_window]
    nh4n_window <- site_data$`NH4-N`[in_window]

    # Calculate the mean of each ion concentration and fill in the result
    result$k_mgl[i] <- mean(k_window, na.rm = TRUE)
    result$no3n_ugl[i] <- mean(no3n_window, na.rm = TRUE)
    result$mg_mgl[i] <- mean(mg_window, na.rm = TRUE)
    result$ca_mgl[i] <- mean(ca_window, na.rm = TRUE)
    result$nh4n_ugl[i] <- mean(nh4n_window, na.rm = TRUE)
  }
  return(result)
}
