#!/usr/bin/env Rscript

#' This script serves as an entrypoint to invoke the R actions either from the command line,
#' or from an interactive R session.
#'
#' Usage
#' - From a command line, run `Rscript entrypoint.R <action> <args>`
#'  or
#' - Specify the desired action in metadata.json and run the script inside an R session.

# Static
run_dir <- "meta-facilitator/R"
new_dir <- NULL

# Ensure the correct working directory regardless of invocation type
if (exists(".vsc.getSession")) {
    message("Running in VS Code")
    session <- .vsc.getSession()
    new_dir <- dirname(session$file)
} else if (interactive()) {
    message("Running in interactive mode") # Assume RStudio
    current_document_path <- suppressWarnings(rstudioapi::getActiveDocumentContext()$path)
    new_dir <- dirname(current_document_path)
} else {
    message("Running in non-interactive mode")
    args <- commandArgs(trailingOnly = FALSE)
    # Iterate through arguments to find the "--file" followed by the script path
    script_path <- NULL
    for (i in seq_along(args)) {
        if (grepl("--file", args[i])) {
            script_path <- sub("^--file=", "", args[i]) # The script path points to the 'r' folder
            break
        }
    }
    if (is.null(script_path)) {
        rlang::abort("Could not find the script path in the arguments. Try specifying the script path using --file=<path> argument.")
    }
    new_dir <- dirname(script_path)
    # action <- args[1]
    # run_args <- args[-1]
}
setwd(new_dir) # Fails if any of the conditions fail to attribute a new_dir

# Check that the current WD ends with the expected directory substring
if (!grepl(paste0(run_dir, "$"), getwd())) {
    rlang::abort("Failed to set the working directory to the correct location. Try running the script again.")
}

# Set up the path for module imports
options(box.path = getwd())

# Relative paths are sourced only after the WD is set correctly
box::use(
    actions / index[ACTIONS],
    actions / utils[getAction],
)

action <- getAction() # Get the action name from the metadata

# Convert the rest of the arguments to a list to be passable into the do.call
# arg_list <- as.list(run_args)

do.call(ACTIONS[[action]], list())
