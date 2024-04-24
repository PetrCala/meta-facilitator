#!/usr/bin/env Rscript

#' This script serves as an entrypoint to invoke the R actions either from the command line,
#' or from an interactive R session.
#'
#' Usage
#' - From a command line, run `Rscript entrypoint.R <action> <args>`
#'  or
#' - Specify the desired action in metadata.json and run the script inside an R session.

library("rstudioapi")

# Static
run_dir <- "meta-facilitator/r"
wd <- getwd()


# Ensure the correct working directory regardless of invocation type
if (interactive()) {
    message("Running in interactive mode")
    setwd(dirname(getActiveDocumentContext()$path)) # Change WD to this document directory
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
        stop("Could not find the script path in the arguments. Try specifying the script path using --file=<path> argument.")
    }
    setwd(dirname(script_path))
    # action <- args[1]
    # run_args <- args[-1]
}

# Check that the current WD ends with the expected directory substring
if (!grepl(paste0(run_dir, "$"), getwd())) {
    stop("Failed to set the working directory to the correct location. Try running the script again.")
}

# Relative paths are sourced only after the WD is set correctly
source("actions/utils.R")

action <- getAction() # Get the action name from the metadata

# Convert the rest of the arguments to a list to be passable into the do.call
# arg_list <- as.list(run_args)

do.call(ACTIONS[[action]], list())
