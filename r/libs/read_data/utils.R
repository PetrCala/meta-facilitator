#' identifyCsvSeparators
#'
#' A rather simple function for infering separator and decimal marks
#' from a csv file.
identifyCsvSeparators <- function(source_path) {
    if (!file.exists(source_path)) {
        stop(paste("The", source_path, "file not found."))
    }
    # Read the first few lines of the data frame
    first_few_lines <- readLines(source_path, n = 20)
    # Identify header line (assuming it is the first non-empty line)
    header_line <- first_few_lines[which(nchar(trimws(first_few_lines)) > 0)][1]
    remaining_lines <- first_few_lines[first_few_lines != header_line]
    # Identify the first line after header that contains digits
    first_data_line <- ""
    for (line in remaining_lines) {
        if (all(grepl("\\D", strsplit(line, "")[[1]])) | nchar(trimws(line)) == 0) {
            next
        } else {
            first_data_line <- line
            break
        }
        stop("No rows with numeric values identified in the data. Error in reading data.")
    }
    # Use custom grouping marks for this script
    return(list(decimal_mark = ".", grouping_mark = ";"))
    # Infer decimal mark and grouping mark
    # if (';' %in% first_data_line) {
    #   return(list(decimal_mark = ',', grouping_mark = ';')) # Default Europe setting
    # } else {
    #   return(list(decimal_mark = '.', grouping_mark = ',')) # Probable other default setting
    # }
}
