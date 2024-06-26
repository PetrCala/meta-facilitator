box::use(
  base / metadata[METADATA],
  base / paths[PATHS]
)

#' Setup logging for the project
setup_logging <- function() {
  log_to_console <- METADATA$options$log_to_console

  if (!log_to_console) {
    log_file <- file.path(PATHS$DIR_R, METADATA$options$log_file_name)

    logger::log_appender(appender = logger::appender_file(log_file, max_files = 1L))
  }
}

box::export(
  setup_logging
)
