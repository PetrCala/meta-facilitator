library("rlang")
source("analyses/utils.R")
source("libs/df_utils.R")
source("libs/utils.R")

#' Return the list of column names for a given analysis
#'
#' @param analysis_name [character] The name of the analysis
#' @example
#' cols <- getAnalysisColsList("chris")
#' print(cols)
#' # list(effect = "Effect", se = "Standard Error", ...)
getAnalysisColsList <- function(analysis_name) {
    analysis_metadata <- getAnalysisMetadata(analysis_name)
    cols <- analysis_metadata$cols
    if (isEmpty(cols)) {
        stop(paste("The analysis metadata does not contain any columns for analysis", analysis_name))
    }
    return(cols)
}

#' Check that a data frame contains all the expected columns
#'
#' @param df [data.frame] The data frame to check
#' @param expected_cols [character] The list of expected column names
#' @example
#' checkForMissingCols(df, c("Effect", "Standard Error", "Lower CI", "Upper CI"))
#' # Throws an error if any of the columns are missing
checkForMissingCols <- function(df, expected_cols) {
    missing_cols <- setdiff(expected_cols, colnames(df))
    if (length(missing_cols) > 0) {
        stop(paste("The data frame is missing the following columns:", missing_cols))
    }
}


#' Clean a data frame for analysis
cleanData <- function(df, analysis_name) {
    source_cols <- getAnalysisColsList(analysis_name)

    # Replace missing columns with NAs
    for (colname in names(source_cols)) {
        df_colname <- source_cols[[colname]] # How the column is named in the data frame
        if (isEmpty(df_colname)) {
            df <- assignNACol(df, colname)
        }
    }

    # Subset to relevant colnames - use colname if available, column source if not
    getColname <- function(col) source_cols[[col]] %||% col
    relevant_colnames <- unlist(lapply(names(source_cols), getColname))
    checkForMissingCols(df, relevant_colnames) # Validate cols are present before subsetting
    df <- df[, relevant_colnames]

    # Rename the columns
    colnames(df) <- names(source_cols)

    return(df)
}
