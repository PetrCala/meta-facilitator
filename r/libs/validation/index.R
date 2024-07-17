#' Check if x is a vector and either empty or all characters
#'
#' @param x [any] The object to check
#' @return boolean indicating whether or not x is a character vector or empty
#' @export
is_char_vector_or_empty <- function(x) {
  is.vector(x) && (length(x) == 0 || is.character(x))
}
