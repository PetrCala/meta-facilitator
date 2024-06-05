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

# Add this custom linter to the default linters
linters <- with_defaults(box_import_linter = box_import_linter)
