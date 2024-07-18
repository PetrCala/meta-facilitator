#' Function to run test_dir on a directory and all its subdirectories
#' @export
run_tests_recursively <- function(path, reporter = NULL) {
  # message("Testing in: ", path)
  test_results <- testthat::test_dir(path, reporter = reporter)

  # Get list of subdirectories
  subdirs <- list.dirs(path, full.names = TRUE, recursive = FALSE)

  # Exclude the top-level directory itself from the list of subdirectories
  subdirs <- subdirs[subdirs != path]

  # Recursively run tests on each subdirectory
  for (subdir in subdirs) {
    run_tests_recursively(subdir)
  }
}
