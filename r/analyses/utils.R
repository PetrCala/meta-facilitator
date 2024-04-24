library("rlang")
source("METADATA.R")


#' Based on an analysis name, get that analysis metadata
#'
#' @return [list] The analysis metadata
getAnalysisMetadata <- function(analysis_name) {
    if (!analysis_name %in% names(METADATA$analyses)) {
        abort(
            paste("The analysis name", analysis_name, "is not in the METADATA."),
            class = "unknown_analysis"
        )
    }
    return(METADATA$analyses[[analysis_name]])
}
