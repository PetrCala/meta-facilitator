#!/usr/bin/env Rscript

#' This script serves as an entrypoint to invoke the R actions either from the command line,
#' or from an interactive R session.
#'
#' Usage
#' - From a command line, run `Rscript entrypoint.R <action> <args>`
#'  or
#' - Specify the desired action in metadata.json and run the script inside an R session.

library("rstudioapi")

source("r/actions.R")
source("r/libs/read_data/metadata.R")

metadata <- readMetadata()

action <- metadata$run$action

if (interactive()) {
    # Change the working directory in interactive sessions
    if (!getwd() == dirname(getActiveDocumentContext()$path)) {
        newdir <- dirname(getActiveDocumentContext()$path)
        cat(sprintf("Setting the working directory to: %s \n", newdir))
        setwd(newdir)
    }
} else {
    print("Running in non-interactive mode")
    # args <- commandArgs(trailingOnly = TRUE)
    # action <- args[1]
    # run_args <- args[-1]
}


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

# Convert the rest of the arguments to a list to be passable into the do.call
# arg_list <- as.list(run_args)

do.call(ACTIONS[[action]], list())
