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


#' Check whether an object is a function call (created using 'call').
#' Return a boolean to indicate this.
#'
#' @param obj [any] The object to evaluate
#' @return [logical] TRUE if the object is a function call, FALSE otherwise
isFunctionCall <- function(obj) {
    if (is.call(obj)) {
        func_name <- as.character(obj[[1]])
        is_valid_function_call <- exists(func_name) && is.function(get(func_name))
        if (!(is_valid_function_call)) {
            return(FALSE)
        }
    } else {
        return(FALSE)
    }
    return(TRUE)
}
