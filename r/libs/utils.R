box::use(
  base/metadata[METADATA]
)

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
    rlang::abort("Please specify an action to execute. Use --help for more information.")
  }

  if (!(action %in% names(run_args))) {
    rlang::abort(
      paste(
            "Unknown action:", action,
            "\nPlease choose from the following actions:", paste(names(run_args), collapse = ", ")
      )
    )
  }
  return(METADATA$run_args[[action]])
}


#' Validate Conditions
#'
#' This function validates input conditions. It checks that each argument is 
#' a single logical value (TRUE or FALSE).
#' If any condition is invalid or does not hold, the function aborts with an 
#' appropriate error message including the failed condition and a backtrace.
#'
#' @param ... Any number of logical conditions.
#'
#' @return NULL. The function is called for its side effects.
#' @export
#'
#' @examples
#' validate(1 == 1, 2 == 2, is.function(print))
#' # The following examples will abort with an error and print a backtrace
#' # validate(FALSE)
#' # validate(TRUE, FALSE, FALSE)
#' # validate("not a condition")
validate <- function(...) {
  options(
    rlang_backtrace_on_error = "full",
    error = rlang::entrace
  )
  
  conditions <- list(...)
  conditions_expr <- as.list(substitute(list(...)))[-1]
  
  # Validate each condition
  for (i in seq_along(conditions)) {
    cond <- conditions[[i]]
    cond_expr <- deparse(conditions_expr[[i]])
    if (!is.logical(cond) || length(cond) != 1) {
      rlang::abort(
        message = paste("Condition must be a single logical value (TRUE or FALSE):", cond_expr),
        .subclass = "validation_error"
      )
    }
    if (!cond) {
      rlang::abort(
        message = paste("Condition did not hold:", cond_expr),
        .subclass = "validation_error"
      )
    }
  }
}


box::export(
  getRunArgs,
  isEmpty,
  isFunctionCall,
  validate
)
