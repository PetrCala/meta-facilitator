# Source as few modules as possible to avoid initial setup errors
source("CONST.R") # can not use 'box' here, as it is not loaded yet

#' Set the CRAN mirror
setMirror <- function(mirror = NULL) {
  if (is.null(mirror)) {
    # Set the CRAN mirror to the first available mirror
    available_mirrors <- getCRANmirrors()
    mirror <- available_mirrors$URL[1]
  }
  options(repos = mirror)
}

#' Quietly execute an expression
#'
#' This function suppresses package startup messages, warnings, and messages
#' while executing an expression. It is useful for keeping the console output
#' clean when loading or installing packages.
#'
#' @param expr [expression] The expression to be executed quietly.
#'
#' @return The result of the executed expression without any messages, warnings, or package startup messages.
quietPackages <- function(expr) {
  suppressPackageStartupMessages(suppressWarnings(suppressMessages(expr)))
}

#' Load packages required for environment preparation
loadInitialPackages <- function(verbose = T) {
  # Load several packages necessary for the environment preparation
  loadInitialPackage <- function(pkg, quietly = T) {
    if (!require(pkg, quietly = quietly, character.only = T)) install.packages(pkg)
    library(pkg, quietly = quietly, character.only = T)
  }

  if (verbose) {
    cat("Loading initial packages...\n")
  }
  invisible(lapply(CONST$INITIAL_PACKAGES, function(x) suppressPackageStartupMessages(loadInitialPackage(x))))
}

#' Load and install a list of R packages
#'
#' This function checks if the specified packages are installed, installs any missing
#' packages, and then loads all of them. If an error occurs during the installation
#' or loading process, the function stops execution and displays an error message.
#'
#' Include a progress bar to track the loading process.
#'
#' @param package_list [character] A character vector of package names.
#' @param verbose [bool] If TRUE, print out verbose output about the package loading.
#'
#' @return A message indicating that all packages were loaded successfully or an error message if the process fails.
loadPackages <- function(package_list, verbose = TRUE) {
  loadInitialPackages()

  # Convert package_list to a named list with NULL versions if necessary
  if (!is.list(package_list) || is.null(names(package_list))) {
    package_list <- setNames(as.list(rep(NA, length(package_list))), package_list)
  }

  # Function to install and check each package
  install_and_check <- function(pkg, version) {
    if (verbose) {
      message <- paste0("Processing package: ", pkg, if (!is.na(version)) paste0(" (version ", version, ")") else "")
      cat(sprintf("%-100s", message)) # Add enough whitespace to make sure the whole line is cleared
      flush.console()
    }
    if (!pkg %in% rownames(installed.packages()) || (!is.na(version) && packageVersion(pkg) != version)) {
      tryCatch(
        {
          # Install specific version if provided, else install the latest version
          if (!is.na(version)) {
            devtools::install_version(pkg, version = version)
          } else {
            install.packages(pkg)
          }
        },
        error = function(e) {
          stop("\nPackage installation failed for ", pkg, ": ", e$message)
        }
      )
    }

    # Load the package
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))

    # Reset the cursor to the start of the line for the progress bar
    cat("\r")
  }

  # Loading packages
  if (verbose) {
    cat("Loading packages...\n")
  }

  # Source pbapply here to avoid initial import error when setting up the environment
  library("pbapply") 

  # Applying the function to each package with a progress bar
  pbapply::pblapply(names(package_list), function(pkg) install_and_check(pkg, package_list[[pkg]]))

  if (verbose) {
    cat("\rAll packages loaded successfully\n")
  }
}


#' Setup the R environment
setupEnv <- function() {
  tryCatch(
    {
      setMirror()
    },
    error = function(e) {
      message("Error setting the CRAN mirror:")
      message(e)
    }
  )

  tryCatch(
    {
      loadPackages(CONST$PACKAGES, verbose = TRUE) # Defined in static
    },
    error = function(e) {
      message("Error loading the packages:")
      message(e)
    }
  )
}

