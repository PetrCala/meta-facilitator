source("METADATA.R")

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


#' Check whether an object is empty.
isEmpty <- function(obj) {
    type_obj <- typeof(obj)

    result <- switch(type_obj,
        logical = all(!obj),
        integer = length(obj) == 0 || all(is.na(obj)),
        double = length(obj) == 0 || all(is.na(obj)), # Treat numeric as double
        character = length(obj) == 0 || any(obj == ""),
        list = length(obj) == 0,
        NULL = TRUE,
        data.frame = is.data.frame(obj) && nrow(obj) == 0,
        factor = length(obj) == 0 || all(is.na(obj)),
        # Default case if none of the above types match
        {
            if (is.na(obj)) {
                TRUE # Single NA values are considered empty
            } else {
                FALSE # If it's a different type and not NA, it's not empty
            }
        }
    )

    # Return the result
    return(result)
}


#' Get the run arguments for a given action
getRunArgs <- function(action) {
  run_args <- METADATA$run_args

  if (is.null(action)) {
    stop("Please specify an action to execute. Use --help for more information.")
  }

  if (!(action %in% names(run_args))) {
    stop_msg <- paste(
      "Unknown action:", action,
      "\nPlease choose from the following actions:", paste(names(run_args), collapse = ", ")
    )
    stop(stop_msg)
  }
  return(METADATA$run_args[[action]])
}