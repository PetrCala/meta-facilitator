box::use(
  yaml,
  base / paths[PATHS]
)

#' Read the options.json file and return it as a list
read_options <- function() {
  if (!file.exists(PATHS$R_OPTIONS_YAML)) {
    rlang::abort("options.json file not found")
  }
  options <- yaml::read_yaml(PATHS$R_OPTIONS_YAML)
  return(options)
}

#' A constant holding the options
#' @export
OPTIONS <- read_options()
