box::use(
  base / metadata[METADATA],
  base / paths[PATHS],
  base / const[CONST],
)

#' Setup logging for the project
#'
#' @param log_to_console_only [logical] Whether to log to console only. Defaults to FALSE
#' @param logger_name [character] The name of the logger to use.
#' @param log_level [character] The log level to use. Choose from 'DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'.
#' @export
setup_logging <- function(
  log_to_console_only = FALSE,
  logger_name = NULL,
  log_level = "DEBUG"
) {
  # Set the logging threshold based on the input string
  if (log_level %in% names(CONST$LOG_LEVEL_MAP)) {
    logger::log_threshold(CONST$LOG_LEVEL_MAP[[log_level]])
  } else {
    rlang::abort("Invalid log level specified. Choose from 'DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'.")
  }

  logger::log_appender(logger::appender_console) # Console logger

  if (!log_to_console_only && !is.null(logger_name)) {
    log_file <- file.path(PATHS$DIR_R, logger_name)

    logger::log_appender(logger::appender_file(log_file, max_files = 1L), index = 2)
  }
}

#' Teardown the logger and remove the log file
#'
#' @param logger_name [character] The name of the logger to teardown
#' @export
teardown_logger_file <- function(logger_name) {
  # logger::remove_appender(logger_name) # This does not work
  if (file.exists(logger_name)) {
    file.remove(logger_name)
  }
}
