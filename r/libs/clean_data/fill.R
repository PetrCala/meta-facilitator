box::use(
  rlang[sym],
  dplyr[`%>%`, across, all_of, mutate, select, lag, first, row_number],
  stats[model.frame], # For dplyr
  libs / validation / index[is_char_vector_or_empty],
  libs / utils[validate],
  dof_calc = calc / dof,
)


#' Modify missing values in a data frame based on changes in other columns
#'
#' @description This function modifies missing values in a data frame based on changes in other columns. If the target column is NA, it is updated with a new value. The new value is a prefix followed by a number that increments each time any of the values in the variable columns changes.
#'
#' @param df [data.frame] The input data frame.
#' @param target_col [character] The column to modify if it is NA.
#' @param columns [character] A vector of column names to detect changes in.
#' @param missing_value_prefix [character] The prefix to use for missing values.
#'  The default is "missing value".
#' @return [data.frame] The modified data frame with updated missing values.
#' @example
#' df <- data.frame(
#'  author = c("A", "A", "B", "B", "C"),
#'  year = c(2000, 2000, 2000, 2001, 2002),
#'  study = c("A2000", NA, "B2000", NA, NA)
#' )
#' new_df <- fill_missing_values(df, "study", c("author", "year"), "Missing study")
#' @export
fill_missing_values <- function(df, target_col, columns = c(), missing_value_prefix = "missing value") {
  logger::log_debug(paste0("Filling missing values for col", target_col, "..."))
  if (!is_char_vector_or_empty(columns)) {
    rlang::abort("The columns parameter must be a character vector or empty")
  }
  # No values to modify by
  if (length(columns) == 0) {
    df[[target_col]] <- missing_value_prefix
    return(df)
  }

  # Create the expression for detecting changes
  change_expr <- paste0(
    "(", columns, " != lag(", columns, ", default = first(", columns, ")))"
  )
  change_expr <- paste(change_expr, collapse = " & ")

  # Construct the mutate expression as a string
  change_expr <- paste0("mutate(change = ", change_expr, ")")

  # Evaluate the change expression separately
  df <- eval(parse(text = paste0("df %>% ", change_expr)), envir = environment())
  df$change[is.na(df$change)] <- FALSE # NA -> FALSE

  # Continue with the rest of the pipeline
  df <- df %>%
    mutate(change = ifelse(row_number() == 1, TRUE, change)) %>%
    mutate(change_count = cumsum(change)) %>%
    # Modify the column if it is NA
    mutate(!!sym(target_col) := ifelse(is.na(!!sym(target_col)), paste(missing_value_prefix, change_count), !!sym(target_col))) %>%
    select(-change, -change_count)

  invalid_value <- paste(missing_value_prefix, "NA")
  if (invalid_value %in% df[[target_col]]) {
    rlang::abort("The target column contains invalid values. Check the fill function.")
  }

  return(df)
}

#' Fill missing degrees of freedom based on t-values and PCCs
#'
#' @note Only use this function for interpolating missing degrees of freedom of PCC-type effects. The formula does not work for other effect types.
#' @param df [data.frame] The input data frame.
#' @return [data.frame] The modified data frame with updated degrees of freedom.
#' @export
fill_dof_using_pcc <- function(df) {
  # validate(all("effect", "se", "t_value") %in% colnames(df), "The input data frame must contain columns 'effect', 'se', and 't_value'.")
  pcc <- df$effect
  t_values <- df$t_value
  dof <- df$dof

  fillable_rows <- is.na(dof) & !is.na(t_values) & !is.na(pcc)
  if (sum(fillable_rows) == 0) {
    return(df)
  }
  df[fillable_rows, "dof"] <- dof_calc$calculate_dof(
    t_value = t_values[fillable_rows],
    pcc = pcc[fillable_rows]
  )

  unfilled_rowcount <- sum(is.na(df$dof))
  logger::log_info(paste("Filled", sum(fillable_rows), "missing degrees of freedom. Could not fill", unfilled_rowcount, "rows. Dropping these rows..."))
  df <- df[!is.na(df$dof), ]

  return(df)
}
