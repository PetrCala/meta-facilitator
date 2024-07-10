box::use(
  base / metadata[METADATA],
  base / paths[PATHS]
)

#' Setup logging for the project
#' @export
setup_logging <- function() {
  logger::log_appender(logger::appender_console) # Console logger

  log_to_console_only <- METADATA$options$log_to_console_only

  if (!log_to_console_only) {
    log_file <- file.path(PATHS$DIR_R, METADATA$options$log_file_name)

    logger::log_appender(logger::appender_file(log_file, max_files = 1L), index = 2)
  }
}
