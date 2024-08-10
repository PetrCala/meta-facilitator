box::use(
  base / paths[PATHS],
  base / options[OPTIONS],
  analyses / index[ANALYSES],
  libs / test_utils[run_tests_recursively],
  reporters = testing / reporters,
)

#' This is a placeholder function to demonstrate the usage of actions, and will be removed fruther on.
add <- function(x, y) {
  tryCatch(
    {
      x <- as.numeric(x)
      y <- as.numeric(y)
    },
    error = function(e) {
      rlang::abort("Please provide numeric values for x and y")
    }
  )
  print(paste("Sum is", x + y))
}

#' @export
run_analysis <- function(analysis_name, ...) {

  if (!length(analysis_name)) {
    rlang::abort("Please provide an analysis name")
  }

  logger::log_debug(paste("Analysing", analysis_name, "data"))

  analysis_name <- toupper(analysis_name)

  if (!(analysis_name %in% names(ANALYSES))) {
    rlang::abort(
      paste(
        "Unknown analysis:", analysis_name,
        "\nMust be one of the following:", paste(names(ANALYSES), collapse = ", ")
      ),
      class = "unknown_analysis"
    )
  }

  do.call(ANALYSES[[analysis_name]], args = list(...))

  logger::log_success("Analysis complete")
}


#' @export
run_tests <- function(...) {
  # Silence the package startup messages, and warnings from 'box'
  Sys.setenv(TESTTHAT = "true")
  suppressWarnings(suppressPackageStartupMessages(library(testthat)))
  test_dir_path <- PATHS$DIR_TESTS

  reporter <- NULL
  if (OPTIONS$tests$silent_reporter) {
    reporter <- testthat::ProgressReporter$new(show_praise = FALSE)
  }
  # reporter <- reporters$dot_reporter$new() # use custom

  run_tests_recursively(test_dir_path, reporter = reporter)
}

#' A list of executable actions for the run.R
#' @export
ACTIONS <- list(
  add = add,
  analyse = run_analysis,
  test = run_tests
)
