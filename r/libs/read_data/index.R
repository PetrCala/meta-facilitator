source("libs/read_data/utils.R")
source("METADATA.R")
source("PATHS.R")


#' getDataPath function
#'
#' This function returns the path of the data file for a given analysis.
#'
#' @param analysis_name [character] Name of the analysis.
#' @returns [character] Path of the data file for the given analysis.
getDataPath <- function(analysis_name) {
    data_dir <- PATHS$DIR_DATA
    source_df <- METADATA$analyses[[analysis_name]]$source_df
    path <- file.path(data_dir, source_df)
    if (!(file.exists(path))) {
        message(
            paste(
                "The data file for the analysis",
                analysis_name,
                "not found under the following path:",
                path
            )
        )
        stop("Missing analysis data file.")
    }
    return(path)
}

#' readDataCustom function
#'
#' This function reads data from a given source path, infers the decimal mark and grouping mark,
#' and checks if the data is read correctly. It specifically designed for files where data
#' begins after several non-data lines. It assumes the first non-empty line as the header line.
#' The function then identifies the first line containing numeric values after the header line
#' to infer the decimal and grouping marks. Finally, it reads the data, verifies its integrity,
#' and returns it.
#'
#' @param source_path [character] A string that is the path of the file to be read.
#'
#' @return Returns a data frame if the data is read successfully, otherwise it stops
#'         execution with an error message.
#'
#' @examples
#' \dontrun{
#' # To read a file, just pass the path of the file
#' data <- readDataCustom("/path/to/your/data.txt")
#' print(data)
#' }
#'
#' @seealso
#' \code{\link[utils]{read.delim}}, \code{\link[utils]{readLines}}
#'
#' @export
readDataCustom <- function(source_path, separators = NA) {
    # Validate the file existence and infer the separators
    if (!file.exists(source_path)) {
        stop(paste("The", source_path, "file not found."))
    }
    if (all(is.na(separators))) {
        separators <- identifyCsvSeparators(source_path)
    }
    decimal_mark <- separators$decimal_mark
    grouping_mark <- separators$grouping_mark
    # Read data
    data_out <- read_delim(
        source_path,
        locale = locale(
            decimal_mark = decimal_mark,
            grouping_mark = grouping_mark,
            tz = "UTC"
        ),
        show_col_types = FALSE # Quiet warnings
    )
    # Check if data is read correctly
    if (is.data.frame(data_out) && length(dim(data_out)) == 2) {
        print(paste("Data loaded successfully from the following source:", source_path))
    } else {
        stop("Error in reading data.")
    }
    # Return the data
    invisible(data_out)
}
