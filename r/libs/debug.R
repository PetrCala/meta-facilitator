#' Determine whether a function call is being made in a debug more or not
#'
#' @return [boolean] TRUE if the function call is being made in a debug mode,
#'  FALSE otherwise.
is_debugging <- function() {
    any(sapply(sys.calls(), function(x) as.character(x)[[1]] %in% c("browser", "debug")))
}
