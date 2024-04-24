#' Assign NA to a column in a data frame
assignNACol <- function(df, colname) {
    df[[colname]] <- rep(NA, nrow(df))
    return(df)
}
