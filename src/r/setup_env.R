source("src/r/src/env.R")

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
