box::use(
  libs / file_utils[validate_folder_existence, write_txt_file],
  base / metadata[METADATA],
  base / paths[PATHS],
  base / const[CONST],
)


#' Based on an analysis name, get that analysis metadata
#'
#' @return [list] The analysis metadata
get_analysis_metadata <- function(analysis_name) {
  if (!analysis_name %in% names(METADATA$analyses)) {
    rlang::abort(
      paste("The analysis name", analysis_name, "is not in the METADATA."),
      class = "unknown_analysis"
    )
  }
  return(METADATA$analyses[[analysis_name]])
}


#' Save the analysis results to the output folder
#'
#' TODO: Add arguments after the function has been finalized
save_analysis_results <- function(df, analysis_name, analysis_messages) {
  # Create the output folder
  output_folder <- PATHS$DIR_OUTPUT
  time_info <- format(Sys.time(), CONST$DATE_ONLY_FORMAT)
  analysis_folder <- paste0(analysis_name, "_", time_info)
  results_folder <- file.path(output_folder, analysis_folder)
  validate_folder_existence(folder_name = results_folder)

  logger::log_info("Saving the results to ", results_folder)

  # Save the results
  utils::write.csv(df, file.path(results_folder, CONST$ANALYSIS_RESULTS_FILE_NAME), row.names = FALSE)
}

box::export(
  get_analysis_metadata,
  save_analysis_results
)
