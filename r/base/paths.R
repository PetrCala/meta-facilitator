#' Get the full directory of the currently sourced script
#'
#' @return [character] The directory of the currently sourced script.
#' @example
#' \dontrun{
#' dir <- get_script_directory()
#' }
get_script_directory <- function() {
  # Check all calls in the call stack
  calls <- sys.calls()
  for (i in rev(seq_along(calls))) {
    call <- calls[[i]]
    # Check if the call is a source() function call
    if (typeof(call) == "language" && deparse(call[[1]]) == "source") {
      # Extract the first argument which should be the filename
      source_path <- call[[2]]
      if (is.character(source_path)) {
        # Return the directory of the sourced file
        return(dirname(normalizePath(source_path)))
      }
    }
  }

  # If no source() is found, it may be direct execution or interactive usage
  # Fall back to the current working directory or potentially other heuristics
  return(getwd())
}

DIR_R <- getwd() # Assume this points to meta-facilitator/R folder
PROJECT_ROOT <- dirname(DIR_R)

#' A list of paths used in the project
#'
#' @example
#' \dontrun{
#' box::use(base/paths[PATHS])
#' print(PATHS$PROJECT_ROOT)
#' }
PATHS <- list(
  # Root files
  PROJECT_ROOT = dirname(DIR_R),
  DIR_R = DIR_R,
  DIR_DATA = file.path(PROJECT_ROOT, "data"),
  DIR_OUTPUT = file.path(PROJECT_ROOT, "output"),
  DIR_CACHE = file.path(PROJECT_ROOT, "_cache"),

  # R files
  R_ENTRYPOINT = file.path(DIR_R, "entrypoint.R"),
  R_METADATA_YAML = file.path(DIR_R, "metadata.yaml"),
  R_METADATA = file.path(DIR_R, "METADATA.R"),
  R_CONST = file.path(DIR_R, "CONST.R"),
  R_PATHS = file.path(DIR_R, "PATHS.R"),
  R_ACTIONS = file.path(DIR_R, "actions.R")
)

box::export(PATHS)
