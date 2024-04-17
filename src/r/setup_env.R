source("src/r/CONST.R")

source(CONST$FILES$ENV)
message("Setting up the environment.")
tryCatch(
    {
        setupEnv()
    },
    error = function(e) {
        message("Error setting up the environment:")
        message(e)
    }
)
message("Environment setup complete.")
