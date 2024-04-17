#!/usr/bin/env Rscript

source("src/r/CONST.R")
source(CONST$FILES$ACTIONS)

args <- commandArgs(trailingOnly = TRUE)
action <- args[1]
rest <- args[-1]

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
arg_list <- as.list(rest)

do.call(ACTIONS[[action]], arg_list)
