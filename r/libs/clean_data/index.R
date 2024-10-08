box::use(
  base / options[OPTIONS],
  analyses / utils[get_analysis_options],
  libs / utils[is_empty],
  libs / validation[validate, assert, validate_columns],
  libs / clean_data / fill[fill_missing_values, fill_dof_using_pcc],
  libs / df_utils[get_number_of_studies, assign_na_col],
)

#' Return the list of column names for a given analysis
#'
#' @param analysis_name [character] The name of the analysis
#' @example
#' cols <- get_analysis_cols_list("chris")
#' print(cols)
#' # list(effect = "Effect", se = "Standard Error", ...)
#' @export
get_analysis_cols_list <- function(analysis_name) {
  analysis_options <- get_analysis_options(analysis_name)
  cols <- analysis_options$cols
  if (is_empty(cols)) {
    rlang::abort(
      paste("The analysis options does not contain any columns for analysis", analysis_name),
      class = "missing_columns_error"
    )
  }
  return(cols)
}

#' Check that a data frame contains all the expected columns
#'
#' @param df [data.frame] The data frame to check
#' @param expected_cols [character] The list of expected column names
#' @example
#' check_for_missing_cols(df, c("Effect", "Standard Error", "Lower CI", "Upper CI"))
#' # Throws an error if any of the columns are missing
#' @export
check_for_missing_cols <- function(df, expected_cols) {
  missing_cols <- setdiff(expected_cols, colnames(df))
  if (length(missing_cols) > 0) {
    rlang::abort(
      paste("The data frame is missing the following columns:", missing_cols),
      class = "missing_columns_error"
    )
  }
}

#' Convert selected columns to numeric
convert_columns_to_numeric <- function(df, cols) {
  logger::log_info(paste("Converting the following columns to numeric values:", paste(cols, collapse = ", ")))
  for (col in cols) {
    if (col %in% names(df)) {
      df[[col]] <- as.numeric(as.character(df[[col]]))
    } else {
      logger::log_warn(paste("Column", col, "does not exist in the dataframe"))
    }
  }
  return(df)
}

#' Drop observations with a missing effect
drop_rows_with_missing_values <- function(df, cols = c("effect")) {
  missing_rows <- rep(FALSE, nrow(df))
  for (col in cols) {
    if (!col %in% colnames(df)) {
      logger::log_warn(paste0("Unknown column name: ", col, ". Skipping NA values check..."))
    } else {
      missing_rows <- missing_rows | is.na(df[col])
    }
  }
  logger::log_info(paste("Dropping", sum(missing_rows), "rows where at least one of these columns is missing a value:", paste(cols, collapse = ", ")))

  return(
    df[!missing_rows, ]
  )
}

#' Recalculate the t-value based on the effect and se columns
recalculate_t_value <- function(df) {
  logger::log_debug("Recalculating t-values...")
  validate_columns(df, c("effect", "se"))
  assert(sum(is.na(df$effect)) == 0, "The 'effect' column contains missing values")
  assert(sum(is.na(df$se)) == 0, "The 'se' column contains missing values")
  t_values <- df$effect / df$se
  t_values[is.infinite(t_values)] <- NA
  df$t_value <- t_values
  return(df)
}

#' Convert string columns to valid R names (remove special characters)
clean_names <- function(df) {
  logger::log_debug("Cleaning names...")
  df$study <- make.names(df$study)
  df$meta <- make.names(df$meta)
  return(df)
}


#' Clean a data frame for analysis
#'
#' @param df [data.frame] The data frame to clean
#' @param analysis_name [character] The name of the analysis
#' @param clean_names [logical] Whether to clean the names of the studies and files. Defaults to TRUE
#' @param recalculate_t_value [logical] Whether to recalculate the t-value based on the effect and se columns. Defaults to TRUE
#' @param fill_dof [logical] Whether to fill missing degrees of freedom using the PCC method. Defaults to TRUE
#' @export
clean_data <- function(
  df,
  analysis_name,
  clean_names = TRUE,
  recalculate_t_value = TRUE,
  fill_dof = TRUE
) {
  logger::log_debug("Cleaning data...")
  source_cols <- get_analysis_cols_list(analysis_name)

  # Replace missing columns with NAs
  for (colname in names(source_cols)) {
    df_colname <- source_cols[[colname]] # How the column is named in the data frame
    if (is_empty(df_colname)) {
      df <- assign_na_col(df, colname)
    }
  }

  # Subset to relevant colnames - use colname if available, column source if not
  get_colname <- function(col) source_cols[[col]] %||% col
  relevant_colnames <- unlist(lapply(names(source_cols), get_colname))
  check_for_missing_cols(df, relevant_colnames) # Validate cols are present before subsetting
  df <- df[, relevant_colnames]

  # Rename the columns
  colnames(df) <- names(source_cols)

  # Drop NA values
  df <- drop_rows_with_missing_values(df, cols = c("effect", "se"))

  # Ensure numeric values
  df <- convert_columns_to_numeric(df, cols = c("effect", "se", "sample_size", "dof"))

  # Fill missing studies
  df <- fill_missing_values(df = df, target_col = "study", columns = c("author1", "year"), missing_value_prefix = "Missing study")

  if (clean_names) {
    df <- clean_names(df = df) # Clean names of studies and files
  }

  if (recalculate_t_value) {
    df <- recalculate_t_value(df = df) # Recalculate t-values
  }

  logger::log_info(paste("Rows after data cleaning:", nrow(df)))

  return(df)
}
