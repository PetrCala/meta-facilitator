#' Set working directory based on a script path
setWorkingDirectory <- function(script_path = NULL) {
    if (is.null(script_path)) {
        cat("Please provide the full path to the script.\n")
    } else {
        script_directory <- dirname(script_path)
        setwd(script_directory)
        cat("Working directory set to:", script_directory, "\n")
    }
}
