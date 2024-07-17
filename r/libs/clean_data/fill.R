box::use(
  rlang[sym],
  dplyr[`%>%`, across, all_of, mutate, select, lag, first, row_number],
  stats[model.frame], # For dplyr
  libs / validation / index[is_char_vector_or_empty],
)

#' Detect changes in specified columns of a data frame.
#'
#' @note This function should always be used in conjunction with `modify_missing_values`, or functions of similar purpose.
#' @param data [data.frame] The input data frame.
#' @param columns [character] A vector of column names to detect changes in.
#' @return [data.frame] A data frame with additional columns for change detection.
detect_changes <- function(data, columns) {
  # Create the expression for detecting changes
  change_expr <- paste0(
    "(", columns, " != lag(", columns, ", default = first(", columns, ")))"
  )
  change_expr <- paste(change_expr, collapse = " | ")

  # Construct the mutate expression as a string
  change_expr <- paste0("mutate(change = ", change_expr, ")")

  # Evaluate the change expression separately
  data <- eval(parse(text = paste0("data %>% ", change_expr)), envir = environment())

  # Continue with the rest of the pipeline
  data <- data %>%
    mutate(change = ifelse(row_number() == 1, TRUE, change)) %>%
    mutate(change_count = cumsum(change))

  return(data)
}

#' Modify missing values in a data frame based on changes in specified columns.
#'
#' @param df [data.frame] The input data frame.
#' @param target_col [character] The column to modify if it is NA.
#' @param columns [character] A vector of column names to detect changes in.
#' @param missing_value_prefix [character] The prefix to use for missing values.
#'  The default is "missing value".
#' @return [data.frame] The modified data frame with updated missing values.
#' @export
modify_missing_values <- function(df, target_col, columns = c(), missing_value_prefix = "missing value") {
  logger::log_debug("Filling missing study names...")
  if (!is_char_vector_or_empty(columns)) {
    rlang::abort("The columns parameter must be a character vector or empty")
  }
  # No values to modify by
  if (length(columns) == 0) {
    df[[target_col]] <- missing_value_prefix
    return(df)
  }
  df <- detect_changes(df, columns) %>%
    # Modify the column if it is NA
    mutate(!!sym(target_col) := ifelse(is.na(!!sym(target_col)), paste(missing_value_prefix, change_count), !!sym(target_col))) %>%
    # Drop the helper columns
    select(-change, -change_count)

  return(df)
}


# #' Fill missing values in a dataframe's 'study' column based on the variability in other columns
# #'
# #' @details Each time any of the values in the variable columns changes, the 'study' column is updated with a new value. This value is arbitrary, such as 'Missing Study 1', 'Missing Study 2', etc.
# #'
# #' @param df [data.frame] The data frame to fill
# #' @param variable_cols [character] The list of columns to use for filling the 'study' column
# #' @return [data.frame] The modified data frame
# #' @example
# #' df <- fill_study_name(df, c("Year published", "Sample size"))
# #' @export
# fill_study_name_loop <- function(df, variable_cols = c()) {
#   logger::log_debug("Filling missing study names...")
#   if (!is_char_vector_or_empty(variable_cols)) {
#     rlang::abort("The variable_cols parameter must be a character vector or empty")
#   }
#   study_col <- df$study
#   if (sum(is.na(study_col)) == 0) {
#     return(df)
#   }
#   # No values to modify by
#   if (length(variable_cols) == 0) {
#     df$study <- "Missing Study"
#     return(df)
#   }
#   change_count <- 0
#   previous_values <- rep(NA, length(variable_cols))
#   for (i in seq_len(nrow(df))) {
#     current_values <- df[i, variable_cols]

#     # Check whether values in the variable cols have changed
#     if (!all(current_values == previous_values, na.rm = TRUE)) {
#       change_count <- change_count + 1
#       previous_values <- current_values
#     }

#     # Modify study col if it is NA
#     if (is.na(df[i, "study"])) {
#       df[i, "study"] <- paste("Missing Study", change_count)
#     }
#   }
#   if (sum(is.na(df$study)) > 0) {
#     rlang::abort("Failed to fill all missing study names")
#   }
#   return(df)
# }
