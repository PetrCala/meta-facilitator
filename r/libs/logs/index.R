box::use(
  base / metadata[METADATA],
  base / paths[PATHS]
)

#' Setup logging for the project
#' @export
setup_logging <- function(log_level = "INFO") {
  # Map input string to logger log level
  log_level_map <- list(
    "DEBUG" = logger::DEBUG,
    "INFO"  = logger::INFO,
    "WARN"  = logger::WARN,
    "ERROR" = logger::ERROR,
    "FATAL" = logger::FATAL
  )
  # Set the logging threshold based on the input string
  if (log_level %in% names(log_level_map)) {
    logger::log_threshold(log_level_map[[log_level]])
  } else {
    rlang::abort("Invalid log level specified. Choose from 'DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'.")
  }

  logger::log_appender(logger::appender_console) # Console logger

  log_to_console_only <- METADATA$options$log_to_console_only

  if (!log_to_console_only) {
    log_file <- file.path(PATHS$DIR_R, METADATA$options$log_file_name)

    logger::log_appender(logger::appender_file(log_file, max_files = 1L), index = 2)
  }
}
