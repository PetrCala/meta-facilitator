library("rlang")
source("libs/utils.R")
source("libs/env.R")
source("analyses/index.R")

add <- function(x, y) {
    tryCatch(
        {
            x <- as.numeric(x)
            y <- as.numeric(y)
        },
        error = function(e) {
            abort("Please provide numeric values for x and y")
        }
    )
    print(paste("Sum is", x + y))
}

run_analysis <- function(analysis_name = NULL, ...) {
    run_args <- getRunArgs("analyse")

    if (is.null(analysis_name)) {
        message("Reading analysis name from metadata")
        analysis_name <- run_args$analysis_name
    }

    message(paste("Analysing", analysis_name, "data"))

    analysis_name <- toupper(analysis_name)

    if (!(analysis_name %in% names(ANALYSES))) {
        abort(
            paste(
                "Unknown analysis:", analysis_name,
                "\nMust be one of the following:", paste(names(ANALYSES), collapse = ", ")
            ),
            class = "unknown_analysis"
        )
    }
    do.call(ANALYSES[[analysis_name]], args = list(...))

    message("Analysis complete")
}

ACTIONS <- list(
    add = add,
    analyse = run_analysis
)
