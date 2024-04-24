#' Capture the output of an expression:
#' - The function captures and returns all output (e.g., messages, errors, and print statements)
#'   that is produced when evaluating the provided expression.
#' - Used after calling cached functions for printing verbose output that would otherwise
#'    get silenced.
#'
#' @param expr [expression] The expression to evaluate
#' @return [character] A character vector containing the lines of output produced by the expression
captureOutput <- function(expr) {
    con <- textConnection("captured", "w", local = TRUE)
    sink(con)
    on.exit({
        sink()
        close(con)
    })
    force(expr)
    captured
}
