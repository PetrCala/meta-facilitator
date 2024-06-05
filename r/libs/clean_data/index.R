box::use(
    analyses / utils[get_analysis_metadata],
    libs / utils[is_empty],
    libs / df_utils[get_number_of_studies, assign_na_col],
)

#' Return the list of column names for a given analysis
#'
#' @param analysis_name [character] The name of the analysis
#' @example
#' cols <- get_analysis_cols_list("chris")
#' print(cols)
#' # list(effect = "Effect", se = "Standard Error", ...)
get_analysis_cols_list <- function(analysis_name) {
    analysis_metadata <- get_analysis_metadata(analysis_name)
    cols <- analysis_metadata$cols
    if (is_empty(cols)) {
        rlang::abort(
            paste("The analysis metadata does not contain any columns for analysis", analysis_name),
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
check_for_missing_cols <- function(df, expected_cols) {
    missing_cols <- setdiff(expected_cols, colnames(df))
    if (length(missing_cols) > 0) {
        rlang::abort(
            paste("The data frame is missing the following columns:", missing_cols),
            class = "missing_columns_error"
        )
    }
}


#' Clean a data frame for analysis
clean_data <- function(df, analysis_name) {
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

    return(df)
}

box::export(
    get_analysis_cols_list,
    check_for_missing_cols,
    clean_data
)
