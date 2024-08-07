box::use(
  base / metadata[METADATA],
  base / paths[PATHS],
  base / const[CONST],
  libs / file_utils[validate_folder_existence, write_txt_file],
  libs / validation[is_char_vector_or_empty],
  libs / string[pluralize],
)


#' Based on an analysis name, get that analysis metadata
#'
#' @return [list] The analysis metadata
#' @export
get_analysis_metadata <- function(analysis_name) {
  if (!analysis_name %in% names(METADATA$analyses)) {
    rlang::abort(
      paste("The analysis name", analysis_name, "is not in the METADATA."),
      class = "unknown_analysis"
    )
  }
  return(METADATA$analyses[[analysis_name]])
}

#' Log various information about the data frame
#'
#' @param df [data.frame] The data frame to log information about
#' @param colnames_to_analyse [character] The column names to analyse
#' @export
log_dataframe_info <- function(df, colnames_to_analyse = NULL) {

  logger::log_info(paste("The data frame has", nrow(df), "rows and", ncol(df), "columns"))

  if (!is.null(colnames_to_analyse)) {
    is_char_vector_or_empty(colnames_to_analyse, throw_error = TRUE)
    for (colname in colnames_to_analyse) {
      plural_colname <- pluralize(word = colname)
      n_ <- length(unique(df[[colname]]))
      logger::log_info(paste0("Unique ", plural_colname, ": ", n_))
    }
  }
}



#' Save the analysis results to the output folder
#'
#' @param df [data.frame] The data frame to run the analysis upon
#' @param analysis_name [character] The name of the analysis
#' @return NULL - The results are saved to the output folder
#' @export
save_analysis_results <- function(df, analysis_name) {
  # Create the output folder
  output_folder <- PATHS$DIR_OUTPUT
  time_info <- format(Sys.time(), CONST$DATE_ONLY_FORMAT)
  analysis_folder <- paste0(analysis_name, "_", time_info)
  results_folder <- file.path(output_folder, analysis_folder)
  validate_folder_existence(folder_name = results_folder)

  # Save the results
  logger::log_debug("Saving the results to ", results_folder)
  utils::write.csv(df, file.path(results_folder, CONST$ANALYSIS_RESULTS_FILE_NAME), row.names = FALSE)
  logger::log_info(paste("Results can be found under", results_folder))
}
