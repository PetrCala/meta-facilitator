# This scripts should not be handling any imports/export through box, as it is used when setting up the initial environment. To avoid this, one would have to define the initial packages outside this script.
CONST <- list(
  PROJECT_NAME = "meta-facilitator",
  DATE_FORMAT = "%Y-%m-%d %H:%M:%S",
  ANALYSIS_INFO_FILE_NAME = "info.txt", # Text file with analysis results
  ANALYSIS_RESULTS_FILE_NAME = "results.csv", # CSV file with analysis results
  INITIAL_PACKAGES = c(
    "box",
    "rstudioapi",
    "devtools",
    "pbapply"
  ),
  # A list of packages that should not be attached through 'library'
  NON_ATTACHED_PACKAGES = c(
    "box"
  ),
  PACKAGES = list(
    "cachem" = "1.0.8",
    "data.table" = "1.15.4",
    "devtools" = "2.4.5",
    "dplyr" = NA,
    "logger" = NA,
    "memoise" = "2.0.1",
    "plm" = "2.6-4",
    "readr" = "2.1.5",
    "readxl" = "0.1.1",
    "rlang" = "1.1.3",
    "testthat" = "3.2.1",
    "yaml" = "2.3.8"
  )
)
