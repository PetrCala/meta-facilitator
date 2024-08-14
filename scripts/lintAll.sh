#!/bin/bash

# Check if a directory argument is provided
if [ $# -gt 1 ]; then
    echo "Usage: $0 [<directory>]"
    exit 1
fi

# Default directory to lint - relative to project root
LINT_DIRECTORY_NAME="R"

# Setup paths
SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")

# Ensure that the shell script can find and use 'source' by using a portable syntax
if [ -f "$SCRIPTS_DIR/shellUtils.sh" ]; then
    . "$SCRIPTS_DIR/shellUtils.sh"
else
    echo "Error: shellUtils.sh not found"
    exit 1
fi

PROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$PROJECT_ROOT_REL")

# Set the default lint path for when no arguments are provided
LINT_PATH="$PROJECT_ROOT/$LINT_DIRECTORY_NAME"

# Use the provided directory if available in the argument
if [ $# -eq 1 ]; then
    LINT_PATH=$(get_abs_path "$1")
fi

# Define the path to custom linters
CUSTOM_LINTERS_FILE_PATH="$LINT_PATH/custom_linters.R"

# Check if R and the required package are available
if ! command -v Rscript &>/dev/null; then
    echo "Error: Rscript is not installed"
    exit 1
fi

if ! Rscript -e "if (!requireNamespace('lintr', quietly = TRUE)) quit(status = 1)" &>/dev/null; then
    echo "Error: R package 'lintr' is not installed"
    exit 1
fi

# Lint all R files in the directory
Rscript -e "lintr::lint_dir('$LINT_PATH')"

# An option with custom linters
# Rscript -e "source('$CUSTOM_LINTERS_FILE_PATH'); lintr::lint_dir('$LINT_PATH')"

LINT_RESULT=$?

# Exit with the status of the last command
if [[ $LINT_RESULT -ne 0 ]]; then
    error "Linting failed"
    exit 1
fi

# Run custom linting functions
# Rscript -e "source(\"$CUSTOM_LINTERS_FILE_PATH\")" "$LINT_PATH"

success "Linting successful!"
