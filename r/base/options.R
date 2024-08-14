box::use(
  yaml,
  base / paths[PATHS],
  base / const[CONST],
  libs / validation[assert, validate]
)


#' Count Unique Names in a Nested List
#'
#' This function counts the number of unique names in a nested list. If the list has only one level,
#' it returns the number of names in that list. For nested lists, it counts the number of named elements
#' across all levels, counting the names within sublists but not the sublist nodes themselves.
#'
#' @param lst [any] The element to check.
#' @param skip_null [logical] Whether to skip NULL elements when counting. Default is FALSE
#' @return An integer representing the count of unique names in the list.
#' @examples
#' count_unique_names(list(a = 1, b = list(c = 2, d = 3))) # Returns 3
#' count_unique_names(list(a = 1, b = list(c = 2, d = 3), e = list(f = 4, g = 5))) # Returns 5
#' count_unique_names(list(a = list(x = 1, y = 2), b = list(c = 3, d = 4))) # Returns 4
#' @export
count_unique_names <- function(lst, skip_null = FALSE) {
  count <- 0
  if (!is.list(lst)) {
    return(1)
  }
  for (element in lst) {
    if (skip_null && is.null(element)) {
      next
    }
    if (is.list(element)) {
      count <- count + count_unique_names(element, skip_null = skip_null)
    } else {
      count <- count + 1
    }
  }
  return(count)
}

#' Recursively parse the YAML structure and set options to the global options namespace. Prepend each option with a custom prefix, separated by a period.
#'
#' @param options_list A list of options
#' @param prefix A prefix to use for the options
#' @return NULL
#' @example
#' set_prefixed_options(list(a = 1, b = list(c = 2, d = 3)), "prefix")
#' # Sets the following options:
#' # prefix.a = 1
#' # prefix.b.c = 2
#' # prefix.b.d = 3
set_prefixed_options <- function(options_list, prefix) {
  for (name in names(options_list)) {
    value <- options_list[[name]]
    if (is.list(value)) {
      # If the value is a list, recursively process it
      set_prefixed_options(value, paste(prefix, name, sep = "."))
    } else {
      # Set the option with the full prefixed name
      option_name <- paste(prefix, name, sep = ".")
      R.utils::setOption(option_name, value)
    }
  }
}

#' Set all options defined in the configuration YAML file into the global options
#'
#' @param options_to_set [list] A list of options to set to the global options namespace
#' @param prefix [character] A prefix to use for the options
#' @return NULL
#' @example
#' set_options(list(a = 1, b = list(c = 2, d = 3)), "prefix")
#' # Sets the following options:
#' # prefix.a = 1
#' # prefix.b.c = 2
#' # prefix.b.d = 3
set_options <- function(options_to_set, prefix) {
  assert(is.list(options_to_set), "options_to_set must be a list.")
  assert(is.character(prefix), "prefix must be a character.")

  set_prefixed_options(options_to_set, prefix)

  expected_option_count <- count_unique_names(options_to_set, skip_null = TRUE)
  options_set <- options()[grep(paste0("^", prefix), names(options()))]

  assert(
    length(options_set) == expected_option_count,
    paste0("Failed to set custom options. Detected ", expected_option_count, " options, but set ", length(options_set), ".")
  )
}

#' @title Options
#' @description
#' This object contains the options that are used in the project.
#' @export
OPTIONS <- yaml::read_yaml(PATHS$R_CONFIG_YAML)

set_options(options_to_set = OPTIONS, prefix = CONST$PACKAGE_NAME)
