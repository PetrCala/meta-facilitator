source("actions/index.R")

#' Validate that an action is specified and is valid
#'
#' @param action [character] The action to validate
validateAction <- function(action) {
    if (is.null(action)) {
        stop("Please specify an action to execute. Use --help for more information.")
    }

    # Check if the action is valid
    if (!(action %in% names(ACTIONS))) {
        stop_msg <- paste(
            "Unknown action:", action,
            "\nPlease choose from the following actions:", paste(names(ACTIONS), collapse = ", ")
        )
        stop(stop_msg)
    }
}

#' Retrieve an action from the metadata, and validate it
#'
#' @return [character] The action to execute
getAction <- function() {
    action <- METADATA$run$action
    validateAction(action)
    return(action)
}
