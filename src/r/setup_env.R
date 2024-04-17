source("src/r/CONST.R")

source(CONST$FILES$ENV)
cat("Setting up the environment.")
tryCatch(
    {
        setupEnv()
    },
    error = function(e) {
        message("Error setting up the environment:")
        message(e)
    }
)
cat("Environment setup complete.")
