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
    df <- df[, relevant_colnames]

    # Rename the columns
    colnames(df) <- names(source_cols)

    return(df)
}
