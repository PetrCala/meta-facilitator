CONST <- list(
    FILES = list(
        ENTRYPOINT = "src/r/entrypoint.R",
        SETUP_ENV = "src/r/setup_env.R",
        ENV = "src/r/src/env.R",
        PACKAGE = "src/r/src/packages.R"
    ),
    INITIAL_PACKAGES = c(
        "rstudioapi",
        "devtools",
        "pbapply"
    ),
    PACKAGES = list(
        "optparse" = NA
    )
)
