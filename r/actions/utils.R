box::use(
  actions / index[ACTIONS],
  base / metadata[METADATA]
)


#' Validate that an action is specified and is valid
#'
#' @param action [character] The action to validate
validate_action <- function(action) {
  if (is.null(action)) {
    rlang::abort("Please specify an action to execute. Use --help for more information.", class = "no_action")
  }

  # Check if the action is valid
  if (!(action %in% names(ACTIONS))) {
    stop_msg <- rlang::abort(
      paste(
        "Unknown action:", action,
        "\nPlease choose from the following actions:", paste(names(ACTIONS), collapse = ", ")
      ),
      class = "unknown_action"
    )
  }
}

#' Retrieve an action from the metadata, and validate it
#'
#' @return [character] The action to execute
get_action <- function() {
  action <- METADATA$run$action
  validate_action(action)
  return(action)
}

#' Determine the arguments with which the script was invoked
#' In interactive mode, use the metadata run args
#' In non-interactive mode, use the command line arguments
#'
#' @return [list] A list containing the action and run arguments
#' @usage
#' args <- get_invocation_args()
#' print(args$action) # 'some-action'
#' print(args$run_args) # list('arg1', 'arg2')
get_invocation_args <- function() {

  # Use an explicit if-else statement to avoid an ifelse bug
  if (interactive()) {
    args <- METADATA$run_args
  } else {
    args <- commandArgs(trailingOnly = TRUE)
  }

  action <- args[1]
  run_args <- args[-1]
  validate_action(action)

  # If no run args are provided, return an empty list
  run_args <- ifelse(length(run_args) == 0, list(), list(run_args))

  return(list(action = action, run_args = run_args))
}

box::export(validate_action, get_action, get_invocation_args)
