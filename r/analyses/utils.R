library("readxl")
source("libs/cache/index.R")
source("libs/read_data/index.R")
source("METADATA.R")

#' readAnalysisData function
#'
#' This function reads the data for a given analysis and returns it as a data frame.
readAnalysisData <- function(
    analysis_name) {
    message("Reading the data for the analysis ", analysis_name)
    df_path <- getDataPath(analysis_name = analysis_name)
    sheet_name <- METADATA$analyses[[analysis_name]]$source_sheet
    df <- runCachedFunction(
        f = read_excel, # Possibly generalize in the future (use .csv, .txt., ...)
        verbose_function = function(...) {
            "Finished reading the data."
        },
        df_path,
        sheet = sheet_name
    )
    return(df)
}
