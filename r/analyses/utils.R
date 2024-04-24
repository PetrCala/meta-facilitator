source("libs/read_data/index.R")

#' readAnalysisData function
#'
#' This function reads the data for a given analysis and returns it as a data frame.
readAnalysisData <- function(
    analysis_name) {
    message("Reading the data for the analysis ", analysis_name)
    df_path <- getDataPath(analysis_name = analysis_name)
    df <- readDataCustom(source_path = df_path)
    return(df)
}
