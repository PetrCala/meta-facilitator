box::use(
  base / paths[PATHS],
  libs / validation[assert],
)

parse_config <- function(config_file = NULL) {
  if (is.null(config_file)) config_file <- PATHS$R_CONFIG_SRC
  config <- yaml::read_yaml(config_file)

  assert(is.list(config), "Config must be a list")
  assert(length(config) > 0, "Empty config")

  #' A helper function to parse a single config group
  parse_config_group <- function(group) {
    assert(is.list(group), "Config group must be a list")
    assert(length(group) > 0, "Empty config group")
    group
  }

  return(lapply(config, parse_config_group))
}

apply_config <- function(config = NULL) {
  if (is.null(config)) config <- list()
}
