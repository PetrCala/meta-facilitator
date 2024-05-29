box::use(
    libs/file_utils[validateFolderExistence, writeTxtFile],
    base/metadata[METADATA],
    base/paths[PATHS],
    base/const[CONST],
)


#' Based on an analysis name, get that analysis metadata
#'
#' @return [list] The analysis metadata
getAnalysisMetadata <- function(analysis_name) {
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
saveAnalysisResults <- function(df, analysis_name, analysis_messages) {
    # Create the output folder
    output_folder <- PATHS$DIR_OUTPUT
    time_info <- format(Sys.time(), CONST$DATE_FORMAT)
    analysis_folder <- paste0(analysis_name, "_", time_info)
    results_folder <- file.path(output_folder, analysis_folder)
    validateFolderExistence(folder_name = results_folder)

    message("Saving the results to ", results_folder)

    # Save the results
    writeTxtFile(analysis_messages, file.path(results_folder, CONST$ANALYSIS_INFO_FILE_NAME))
    # TODO enable this
    # write.csv(df, file.path(results_folder, CONST$ANALYSIS_RESULTS_FILE_NAME), row.names = FALSE)
}

box::export(
    getAnalysisMetadata,
    saveAnalysisResults
)