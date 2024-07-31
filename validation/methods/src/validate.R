validate_vector <- function(custom_vector, expected_vector) {
  if (length(custom_vector) != length(expected_vector)) {
    stop("The custom vector and the expected vector are not of the same length.")
  }

  if (!identical(class(custom_vector), class(expected_vector))) {
    stop("The custom vector and the expected vector are not of the same type.")
  }

  if (!all.equal(custom_vector, expected_vector)) {
    stop("The custom vector and the expected vector are not equal.")
  }

  message("Validation successful.")
}

validate_method <- function(custom_results, expected_results) {
  if (!identical(custom_results, expected_results)) {
    message("The custom results and the expected results are not identical.")
    message("Custom results:")
    message(paste("Estimate:", custom_results$est))
    message(paste("T-value:", custom_results$t_value))
    message("Expected results:")
    message(paste("Estimate:", expected_results$est))
    message(paste("T-value:", expected_results$t_value))
    message("\n")
  } else {
    message("Validation successful.\n")
  }
}