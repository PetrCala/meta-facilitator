#!/usr/bin/env Rscript

#' Box import linter
#'
#' Force box imports across the project
#'  - Use 'box::' for importing modules
box_import_linter <- function(source_file) {
  lapply(ids_with_token(source_file, "SYMBOL_PACKAGE"), function(id) {
    token <- with_id(source_file, id)
    if (token$text != "box::") {
      Lint(
        filename = source_file$filename,
        line_number = token$line1,
        column_number = token$col1,
        type = "style",
        message = "Use 'box::' for importing modules",
        line = source_file$lines[token$line1]
      )
    }
  })
}

#' Trailing comma linter
#'
#' Ensure there are no trailing commas in box::export statements
#' @export
trailing_comma_linter <- lintr::Linter(function(source_file) {
  is_a_trailing_comma_line <- function(line) {
    grepl(",\\)$", line)
  }
  is_within_export_statement <- FALSE
  should_fail <- FALSE
  lints <- lapply(seq_along(source_file$lines), function(line_number) {
    line <- source_file$lines[[line_number]]
    contains_box_export <- function(line) grepl("box::export\\(", line)

    # If the export block has not been reached yet, continue
    if (contains_box_export(line)) {
      is_within_export_statement <- TRUE
    }
    if (!(is_within_export_statement)) {
      return(NULL)
    }
    has_a_closing_parenthesis <- grepl("\\)$", line)
    if (!has_a_closing_parenthesis) {
      return(NULL)
    }
    # Check only once the export block closing parenthesis has been reached
    # If a trailing comma is found, return a lint
    if (is_a_trailing_comma_line(line)) {
      should_fail <- TRUE
    } else if (!(contains_box_export(line))) {
      # If the previous line ends with a comma, return a lint
      previous_line <- source_file$lines[[line_number - 1]]
      if ((grepl("^\\s*,$", previous_line))) {
        should_fail <- TRUE
      }
    }
    if (!should_fail) {
      return(lintr::Lint(
        filename = source_file$filename,
        line_number = line_number,
        column_number = nchar(line) - nchar(gsub(".*,(\\s*\\))$", "\\1", line)) + 1,
        type = "style",
        message = "Trailing comma found in box::export statement",
        line = line,
        ranges = list(c(nchar(line) - nchar(gsub(".*,(\\s*\\))$", "\\1", line)), nchar(line) - nchar(gsub(".*,(\\s*\\))$", "\\1", line)) + 1))
      ))
    }
    # Otherwise all is well
    return(NULL)
  })

  return(do.call(c, lints))
})

box_object_usage_linter <- lintr::Linter(function(source_file) {
  linter <- lintr::object_usage_linter()
  lints <- linter$lint(source_file)

  # Filter out lints for objects imported via box::use
  box_imports <- source_file$parsed_content %>%
    dplyr::filter(token == "SYMBOL_PACKAGE" & text == "box") %>%
    dplyr::pull(line1)

  filtered_lints <- lints %>%
    dplyr::filter(!line %in% box_imports)

  return(filtered_lints)
})

# Define a custom linter function that uses the custom linters
# custom_linters <- lintr::lint_dir()(
#     trailing_comma_linter = trailing_comma_linter
#     # box_object_usage_linter = box_object_usage_linter
# )

# # Function to lint a directory
# lint_directory <- function(dir) {
#     lints <- lintr::lint_dir(path = dir, linters = custom_linters)
#     print(lints)
# }

# # Get directory from command line argument
# args <- commandArgs(trailingOnly = TRUE)
# if (length(args) != 1) {
#     stop("Please provide exactly one directory path as an argument.")
# }
# dir <- args[1]

# # Lint the directory
# lint_directory(dir = dir)
