source("libs/env.R")

cat("Setting up the environment.\n")
tryCatch(
    {
        setupEnv()
    },
    error = function(e) {
        message("Error setting up the environment:")
        message(e)
        quit(status = 1)
    }
)
cat("Environment setup complete.\n")
