#' @title Constants
#' @description
#' This objects contains constants that are used in the project.
#' @note
#' This scripts should not be handling any non-script like imports/export through box, as it is used when setting up the initial environment. To avoid this, one would have to define the initial packages outside this script.
#' @export
CONST <- list(
  PROJECT_NAME = "meta-facilitator",
  DATE_FORMAT = "%Y-%m-%d %H:%M:%S",
  DATE_ONLY_FORMAT = "%Y-%m-%d",
  ANALYSIS_INFO_FILE_NAME = "info.txt", # Text file with analysis results
  ANALYSIS_RESULTS_FILE_NAME = "results.csv" # CSV file with analysis results
)
