#!/bin/bash

set -e

# Static
R_DIR_NAME="R"
RUN_FILE_NAME="run.R"

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPTS_DIR/shellUtils.sh"

ARGS_STR=""

if [[ ! -z "$@" ]]; then
  ARGS_STR=" with these args: '$*'"
fi

info "Invoking the run file$ARGS_STR..."

ROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$ROJECT_ROOT_REL")
R_DIR="$PROJECT_ROOT/$R_DIR_NAME" # R/
# R_SRC_DIR="$R_DIR/$R_SCRIPTS_DIR_NAME" # R/src

RUN_FILE_PATH="$R_DIR/$RUN_FILE_NAME"

# Check if the R script exists
if [ ! -f "$RUN_FILE_PATH" ]; then
  echo "Run R script not found: $RUN_FILE_PATH"
  exit 1
fi

Rscript "$RUN_FILE_PATH" "$@"

# Alternatively, you can run the script interactively
# This, however, still does not support debugging
# run_r_script_interactively "$RUN_FILE_PATH"

# Capture the exit status of the Rscript command
EXIT_STATUS=$?

# Return to the terminal with the exit status
exit $EXIT_STATUS
