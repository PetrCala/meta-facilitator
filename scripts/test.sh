#!/bin/bash

set -e

TEST_DIR_NAME="tests"
R_DIR_NAME="R"

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPTS_DIR/shellUtils.sh"

PROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$PROJECT_ROOT_REL")

R_FOLDER_PATH="$PROJECT_ROOT/$R_DIR_NAME"
TEST_FOLDER_PATH="$PROJECT_ROOT/$TEST_DIR_NAME"

cd $R_FOLDER_PATH

# Make the invocation recognize the environment as test
export TESTTHAT=true

Rscript -e "devtools::test('$TEST_FOLDER_PATH')"
# Rscript -e "source('$ENTRYPOINT_PATH')" "test"

unset TESTTHAT

success "Done."

exit 0
