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

box::export(get_action)
