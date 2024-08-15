#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if ! command -v R &>/dev/null; then
    error "R is not installed. Make sure to install it from https://www.cran.r-project.org."
    exit 1
fi

info "Setting up the environment..."

cd $PROJECT_ROOT

if [[ ! -d $CACHE_DIR ]]; then
    info "Creating cache directory..."
    mkdir $CACHE_DIR
fi

source "$SCRIPTS_DIR/setupR.sh" # Prints verbose output

success "Done."
