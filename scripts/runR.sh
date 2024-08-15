#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ARGS_STR=""

if [[ ! -z "$@" ]]; then
  ARGS_STR=" with these args: '$*'"
fi

info "Invoking the run file$ARGS_STR..."

Rscript "$RUN_FILE_PATH" "$@"

# Alternatively, you can run the script interactively
# This, however, still does not support debugging
# run_r_script_interactively "$RUN_FILE_PATH"

# Capture the exit status of the Rscript command
EXIT_STATUS=$?

# Return to the terminal with the exit status
exit $EXIT_STATUS
