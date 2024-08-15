#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

info "Setting up the R environment..."

# Setup the R environment
cd $R_DIR
Rscript "$SETUP_ENV_FILE_PATH"

info "Finished setting up the R environment."
