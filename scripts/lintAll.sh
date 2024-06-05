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
source "$SCRIPTS_DIR/shellUtils.sh"

ROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$ROJECT_ROOT_REL")

# Set the default lint path for when no arguments are provided
LINT_PATH="$PROJECT_ROOT/$LINT_DIRECTORY_NAME"

# Use the provided directory if available in the argument
if [ $# -eq 1 ]; then
    LINT_PATH=$(get_abs_path "$1")
fi

# Lint all R files in the directory
Rscript -e "lintr::lint_dir('$LINT_PATH')"

# Exit with the status of the last command
exit $?
