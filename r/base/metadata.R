box::use(
    yaml,
    base / paths[PATHS]
)

#' Read the metadata.json file and return it as a list
read_metadata <- function() {
    if (!file.exists(PATHS$R_METADATA_YAML)) {
        rlang::abort("metadata.json file not found")
    }
    metadata <- yaml::read_yaml(PATHS$R_METADATA_YAML)
    return(metadata)
}

#' A constant holding the metadata
#' @export
METADATA <- read_metadata()
