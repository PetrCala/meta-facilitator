#' Assign NA to a column in a data frame
assignNACol <- function(df, colname) {
    df[[colname]] <- rep(NA, nrow(df))
    return(df)
}



#' Get the number of studies in an analysis data frame.
#'
#' @param df [data.frame] The analysis data frame.
#' @param study_colname [str] The column name holding names of all studies.
#' @return [int] The number of studies.
getNumberOfStudies <- function(df) {
    if (!"study" %in% colnames(df)) {
        abort("The data frame does not have a 'study' column.", class = "missing_study_column")
    }
    return(length(table(df$study)))
}
