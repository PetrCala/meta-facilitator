#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

export TESTTHAT=true

TEST_FOLDER_PATH="$PROJECT_ROOT/$TEST_DIR_NAME"

cd $R_DIR

Rscript -e "
source('$RUN_FILE_NAME');
" test

unset TESTTHAT

exit 0
