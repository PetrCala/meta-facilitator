box::use(
  base / paths[PATHS],
  analyses / index[ANALYSES],
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

  logger::log_info(paste("Analysing", analysis_name, "data"))

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

run_tests <- function(...) {
  # Silence the package startup messages, and warnings from 'box'
  suppressWarnings(suppressPackageStartupMessages(library(testthat)))
  test_dir_path <- PATHS$DIR_TESTS
  Sys.setenv(TESTTHAT = "true")
  testthat::test_dir(test_dir_path)
}

#' A list of executable actions for the entrypoint.R
ACTIONS <- list(
  add = add,
  analyse = run_analysis,
  test = run_tests
)

box::export(ACTIONS)
