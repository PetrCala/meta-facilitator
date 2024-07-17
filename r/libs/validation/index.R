#' Check if x is a vector and either empty or all characters
#'
#' @param x [any] The object to check
#' @param throw_error [logical] Whether to throw an error if the check fails
#' @return boolean indicating whether or not x is a character vector or empty
#' @export
is_char_vector_or_empty <- function(x, throw_error = FALSE) {
  is_empty <- is.vector(x) && (length(x) == 0 || is.character(x))
  if (throw_error && !is_empty) {
    rlang::abort("The object is not a character vector or empty")
  }
  return(is_empty)
}
