#' @export
load_options <- function() {
  option_list <- list(
    optparse::make_option(c("-i", "--input"), type = "character", default = "input_data.csv", help = "Input file path")
  )
  # Parse options
  parser <- optparse::OptionParser(option_list = option_list)
  opt <- optparse::parse_args(parser)
  # TODO
  # parser <- optparse::OptionParser(formatter = optparse::TitledHelpFormatter)
  # parser <- optparse::add_option(parser, "--generator", help = "Generator option")
  # browser()
  # parser <- optparse::add_option(c("-i", "--input"), type = "character", default = "input_data.csv", help = "Input file path")
  return(opt)
}
# load_config <- function(yaml_file) {
#   config <- yaml::yaml.load_file(yaml_file)

#   # Validate the structure and values
#   if (!is.list(config$options)) stop("options should be a list")
#   if (!is.logical(config$options$clean_names)) stop("clean_names should be a logical value")
#   if (!is.logical(config$options$log_to_console_only)) stop("log_to_console_only should be a logical value")
#   if (!is.character(config$options$log_file_name)) stop("log_file_name should be a character string")
#   if (!is.character(config$dynamic_options$log_level)) stop("log_level should be a character string")

#   if (!is.list(config$cache_handling)) stop("cache_handling should be a list")
#   if (!is.logical(config$dynamic_options$use_cache)) stop("use_cache should be a logical value")
#   if (!is.numeric(config$cache_handling$cache_age)) stop("cache_age should be a numeric value")

#   return(config)
# }
