library("yaml")
source("PATHS.R")

#' Read the metadata.json file and return it as a list
readMetadata <- function() {
    if (!file.exists(PATHS$R_METADATA_YAML)) abort("metadata.json file not found")
    metadata <- read_yaml(PATHS$R_METADATA_YAML)
    return(metadata)
}

#' A constant holding the metadata
METADATA <- readMetadata()
