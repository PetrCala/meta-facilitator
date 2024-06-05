box::use(
    libs / utils[get_run_args],
    analyses / index[ANALYSES],
)

#' This is a placeholder function to demonstrate the usage of actions, and will be removed fruther on.
add <- function(x, y) {
    tryCatch(
        {
            x <- as.numeric(x)
            y <- as.numeric(y)
        },
        error = function(e) {
            rlang::abort("Please provide numeric values for x and y")
        }
    )
    print(paste("Sum is", x + y))
}

#' @export
run_analysis <- function(analysis_name = NULL, ...) {
    run_args <- get_run_args("analyse")

    if (is.null(analysis_name)) {
        message("Reading analysis name from metadata")
        analysis_name <- run_args$analysis_name
    }

    message(paste("Analysing", analysis_name, "data"))

    analysis_name <- toupper(analysis_name)

    if (!(analysis_name %in% names(ANALYSES))) {
        rlang::abort(
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

run_tests <- function(...) {
    # devtools::test("$TEST_DIR")
    print("hello, world!")
    return(NULL)
}

#' A list of executable actions for the entrypoint.R
ACTIONS <- list(
    add = add,
    analyse = run_analysis,
    test = run_tests
)

box::export(ACTIONS)
