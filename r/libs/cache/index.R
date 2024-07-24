box::use(
  base / paths[PATHS],
  base / metadata[METADATA],
  base / const[CONST],
  libs / utils[validate],
  libs/ cache / utils[create_cache_key],
)

#' Capture the output and logs of an expression:
#' - The function captures and returns all output (e.g., messages, errors, and print statements)
#'   that is produced when evaluating the provided expression.
#' - Used after calling cached functions for printing verbose output that would otherwise
#'    get silenced.
#'
#' @param expr [expression] The expression to evaluate
#' @return [character] A character vector containing the lines of output produced by the expression
#' @export
capture_output_and_logs <- function(expr) {
  con <- textConnection("captured", "w", local = TRUE)
  sink(con, type = "output")
  sink(con, type = "message")
  on.exit({
    sink(type = "output")
    sink(type = "message")
    close(con)
  })
  force(expr)
  captured
}

#' Cache a function using the memoise package if so desired
#'
#' Input a function and memoise it based on disk cache if caching is on.
#' If not, return the function as is instead.
#'
#' @param f [function] The function to be memoised.
#' @param is_cache_on [logical] Indicates whether cache should be used.
#' @param cache_path [character] Path to the folder where cache should be stored.
#'  Defaults to './_cache/'.
#' @param cache_age [numeric] In seconds, how long the cache should exist after creation.
#'  They get deleted with every script run. Defaults to 3600 (1 hour).
#' @return Function. Memoised or not, based on the is_cache_on parameter.
#' @export
cache_if_needed <- function(
  f,
  is_cache_on,
  cache_path = PATHS$DIR_CACHE,
  cache_age = METADATA$cache_handling$cache_age
) {
  # Validate input
  validate(
    is.function(f),
    is.logical(is_cache_on),
    is.character(cache_path),
    is.numeric(cache_age)
  )
  # Main
  if (is_cache_on) {
    # Get the disk cache
    disk_cache <- cachem::cache_disk(dir = cache_path, max_size = 1e9, max_age = cache_age)
    return(memoise::memoise(f, cache = disk_cache))
  } else {
    return(f)
  }
}


#' Process a log message and log it using the logger package
#'
#' @details This function serves to re-process a message which might be a log. In case it is, simply relogging it would cause the log metadata to be duplicated. This function parses the message, determines its severity, and logs it using the logger package.
#'
#' @param message [character] The log message to process
#' @export
relog_a_message <- function(message) {
  # Check if the message contains a log level and a timestamp
  if (grepl(CONST$LOG_PATTERN, message)) {
    # Extract the log level, timestamp, and actual message
    log_parts <- regmatches(message, regexec(CONST$LOG_PATTERN, message))

    # Get the log level and the rest of the message
    log_level <- log_parts[[1]][2]
    log_content <- sub(CONST$LOG_PATTERN, "", message)

    log_content <- trimws(log_content)

    # Log the message using the logger package based on the severity level
    switch(
      log_level,
      "DEBUG" = logger::log_debug(log_content),
      "INFO" = logger::log_info(log_content),
      "WARN" = logger::log_warn(log_content),
      "ERROR" = logger::log_error(log_content),
      "FATAL" = logger::log_fatal(log_content),
      # If none of the levels match, just print it
      base::cat(message)
    )
  } else {
    base::cat(message) # Print if not a log message
  }
}


#' Run a cached function by using the function call from cache_if_needed.
#'
#' Input the function call from cache_if_needed, specify the user parameters list, and run the function. All logs which are ran during the initial call to the function are cached together with the function, and then fetched/printed during the subsequent calls.
#'
#' @param fun [function] Cached (or bare) function that should be called.
#' @inheritDotParams The parameters to pass to the function call
#' @return The returned object from the function call.
#' @example
#' run_cached_function(
#'    f = read_excel,
#'    sheet = sheet_name),
#' )
#' @export
run_cached_function <- function(f, ...) {
  # Validate input
  validate(is.function(f))
  # Save the parameters for cleaner code
  use_cache <- METADATA$cache_handling$use_cache
  cache_folder <- PATHS$DIR_CACHE
  cache_age <- METADATA$cache_handling$cache_age
  if (!use_cache) {
    # Do not capture output if caching is turned off (e.g., when debugging)
    res <- f(...)
    return(res)
  }
  fun_name <- deparse(substitute(f)) # Name of the invoked function

  # Define the function to call based on cache information
  cached_function <- cache_if_needed(f, use_cache, cache_folder, cache_age)

  # Capture verbose output to print in case it gets silenced
  msg <- capture_output_and_logs(
    # Call the function with parameters
    res <- cached_function(...)
  )

  # Use a disk just for logs
  cache_disk <- cachem::cache_disk(
    dir = PATHS$DIR_CACHE, # NULL == temporary cache
    max_size = 1024 * 1024^2  # 1 GB
  )

  # Retrieve from the log disk
  get_cache <- function(key) as.character(cache_disk$get(key))

  log_cache_key <- create_cache_key(list("log", fun_name, ...)) # Deterministic

  # Store the message if the function was not cached,
  # otherwise get the message from the cache (empty character if empty)
  if (length(msg) > 0) {
    logger::log_debug("Storing the logs in the cache with key ", log_cache_key)
    cache_disk$set(log_cache_key, msg)
  } else {
    logger::log_debug("Getting the logs from the cache with key ", log_cache_key)
    msg <- get_cache(log_cache_key)
  }
  for (m in msg) {
    relog_a_message(m)
  }

  return(res)
}
