#!/bin/bash

set -e

TEST_DIR="tests"

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPTS_DIR/shellUtils.sh"

ROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$ROJECT_ROOT_REL")

cd $PROJECT_ROOT

Rscript -e "devtools::test('$TEST_DIR')"

success "Done."

exit 0
