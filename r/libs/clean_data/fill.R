box::use(
  libs / validation / index[is_char_vector_or_empty]
)

#' Fill missing values in a dataframe's 'study' column based on the variability in other columns
#'
#' @details Each time any of the values in the variable columns changes, the 'study' column is updated with a new value. This value is arbitrary, such as 'Missing Study 1', 'Missing Study 2', etc.
#'
#' @param df [data.frame] The data frame to fill
#' @param variable_cols [character] The list of columns to use for filling the 'study' column
#' @return [data.frame] The modified data frame
#' @example
#' df <- fill_study_name(df, c("Year published", "Sample size"))
#' @export
fill_study_name <- function(df, variable_cols = c()) {
  logger::log_debug("Filling missing study names...")
  if (!is_char_vector_or_empty(variable_cols)) {
    rlang::abort("The variable_cols parameter must be a character vector or empty")
  }
  study_col <- df$study
  if (sum(is.na(study_col)) == 0) {
    return(df)
  }
  # No values to modify by
  if (length(variable_cols) == 0) {
    df$study <- "Missing Study"
    return(df)
  }
  change_count <- 0
  previous_values <- rep(NA, length(variable_cols))
  for (i in seq_len(nrow(df))) {
    current_values <- df[i, variable_cols]

    # Check whether values in the variable cols have changed
    if (!all(current_values == previous_values, na.rm = TRUE)) {
      change_count <- change_count + 1
      previous_values <- current_values
    }

    # Modify study col if it is NA
    if (is.na(df[i, "study"])) {
      df[i, "study"] <- paste("Missing Study", change_count)
    }
  }
  if (sum(is.na(df$study)) > 0) {
    rlang::abort("Failed to fill all missing study names")
  }
  return(df)
}
