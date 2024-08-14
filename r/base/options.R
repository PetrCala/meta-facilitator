box::use(
  yaml,
  base / paths[PATHS],
  base / const[CONST]
)

#' Recursively parse the YAML structure and set options with a prefix
#'
#' @param options_list A list of options
#' @param prefix A prefix to use for the options
#' @return NULL
set_prefixed_options <- function(options_list, prefix) {
  config_file <- PATHS$R_CONFIG_YAML
  if (!file.exists(config_file)) {
    rlang::abort(paste(config_file, "file not found"))
  }
  for (name in names(options_list)) {
    value <- options_list[[name]]
    if (is.list(value)) {
      # If the value is a list, recursively process it
      set_prefixed_options(value, paste(prefix, name, sep = "."))
    } else {
      # Set the option with the full prefixed name
      option_name <- paste(prefix, name, sep = ".")
      options(option_name = value)
    }
  }
}

#' @title Options
#' @description
#' This object contains the options that are used in the project.
#' @export
OPTIONS <- yaml::read_yaml(PATHS$R_CONFIG_YAML)

# Set options with the package name prefix
set_prefixed_options(OPTIONS, CONST$PACKAGE_NAME)
