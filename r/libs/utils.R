box::use(
  base / options[OPTIONS]
)

#' Check whether an object is a function call (created using 'call').
#' Return a boolean to indicate this.
#'
#' @param obj [any] The object to evaluate
#' @return [logical] TRUE if the object is a function call, FALSE otherwise
#' @export
is_function_call <- function(obj) {
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
#' @export
is_empty <- function(obj) {
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

#' Convert a number to a percentage
#'
#' @param x [numeric] The number to convert
#' @return [character] The number as a percentage
#' @export
to_perc <- function(x) {
  return(paste0(round(x * 100, 2), "%"))
}
