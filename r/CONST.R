CONST <- list(
    PROJECT_NAME = "meta-facilitator",
    DATE_FORMAT = "%Y-%m-%d %H:%M:%S",
    ANALYSIS_INFO_FILE_NAME = "info.txt", # Text file with analysis results
    ANALYSIS_RESULTS_FILE_NAME = "results.csv", # CSV file with analysis results
    INITIAL_PACKAGES = c(
        "rstudioapi",
        "devtools",
        "pbapply"
    ),
    PACKAGES = list(
        "cachem" = "1.0.8",
        "devtools" = "2.4.5",
        "memoise" = "2.0.1",
        "readr" = "2.1.5",
        "readxl" = "0.1.1",
        "rlang" = "1.1.3",
        "testthat" = "3.2.1",
        "yaml" = "2.3.8"
    )
)
