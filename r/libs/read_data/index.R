library("readxl")
library("readr")
library("rlang")
source("libs/read_data/utils.R")
source("libs/cache/index.R")
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
        abort("Missing analysis data file.", class = "missing_data_file")
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
        abort(
            paste("The", source_path, "file not found."),
            class = "missing_file"
        )
    }
    # Read data
    data_out <- read_delim(
        source_path,
        locale = locale(
            decimal_mark = METADATA$locale$decimal_mark,
            grouping_mark = METADATA$locale$grouping_mark,
            tz = METADATA$locale$tz
        ),
        show_col_types = FALSE # Quiet warnings
    )
    # Check if data is read correctly
    if (is.data.frame(data_out) && length(dim(data_out)) == 2) {
        print(paste("Data loaded successfully from the following source:", source_path))
    } else {
        abort(
            "Error in reading data. Try modifying your locale settings in the metadata.yaml file.",
            class = "data_read_error"
        )
    }
    # Return the data
    invisible(data_out)
}


#' readAnalysisData function
#'
#' This function reads the data for a given analysis and returns it as a data frame.
readAnalysisData <- function(
    analysis_name) {
    message("Reading the data for the analysis ", analysis_name)
    df_path <- getDataPath(analysis_name = analysis_name)
    analysis_metadata <- getAnalysisMetadata(analysis_name)
    sheet_name <- analysis_metadata$source_sheet
    df <- runCachedFunction(
        f = read_excel, # Possibly generalize in the future (use .csv, .txt., ...)
        verbose_function = function(...) {
            "Finished reading the data."
        },
        df_path,
        sheet = sheet_name
    )
    # Tibble to DF - possibly abstract away in the future
    df_names <- names(df)
    df <- as.data.frame(df)
    colnames(df) <- df_names
    return(df)
}
