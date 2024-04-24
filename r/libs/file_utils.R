#' Create a folder in the working directory if it does not exist yet
#'
#' @param folder_name [character] Name of the folder. Specify in the format
#' "./<name_of_the_folder>/
#' @param require_existence [logical] Only check the existence of the folder.
#'  Raise an error in case the folder does not exist.
validateFolderExistence <- function(folder_name, require_existence = FALSE) {
    if (!file.exists(folder_name)) {
        if (require_existence) {
            stop(paste("The folder", folder_name, "must exist in the working directory."))
        }
        dir.create(folder_name, recursive = TRUE)
    }
}


#' Input a vector of file names, that should be located in the folder
#' of the main script, and validate that all are indeed present.
#' Print out a status message after the validation.
#'
#' @param files[vector] A vector of strings.
validateFiles <- function(files) {
    for (file in files) {
        if (!file.exists(file)) {
            stop(paste0(file, " does not exist or could not be located.
                  Please make sure to include it in the working directory."))
        }
    }
    print("All necessary files located successfully.")
}
