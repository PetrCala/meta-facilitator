#!/bin/bash

set -e

TEST_DIR_NAME="tests/testthat"
R_DIR_NAME="R"

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPTS_DIR/shellUtils.sh"

PROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$PROJECT_ROOT_REL")

R_FOLDER_PATH="$PROJECT_ROOT/$R_DIR_NAME"
TEST_FOLDER_PATH="$PROJECT_ROOT/$TEST_DIR_NAME"
RUN_PATH="$R_FOLDER_PATH/run.R"

cd $R_FOLDER_PATH

export TESTTHAT=true

Rscript -e "
source('$RUN_PATH');
" test

unset TESTTHAT

exit 0
