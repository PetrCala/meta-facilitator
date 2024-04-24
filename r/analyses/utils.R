source("METADATA.R")


#' Based on an analysis name, get that analysis metadata
#'
#' @return [list] The analysis metadata
getAnalysisMetadata <- function(analysis_name) {
    if (!analysis_name %in% names(METADATA$analyses)) {
        stop(paste("The analysis name", analysis_name, "is not in the METADATA."))
    }
    return(METADATA$analyses[[analysis_name]])
}
