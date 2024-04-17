#!/bin/bash

set -e

# Static
R_DIR_NAME="r"
R_SCRIPTS_DIR_NAME="src"
SETUP_ENV_FILE_NAME="setup_env.R"

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPTS_DIR/shellUtils.sh"

info "Setting up the R environment..."

ROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$ROJECT_ROOT_REL")
R_DIR="$PROJECT_ROOT/src/$R_DIR_NAME" # src/r/
# R_SRC_DIR="$R_DIR/$R_SCRIPTS_DIR_NAME" # src/r/src

SETUP_ENV_FILE_PATH="$R_DIR/$SETUP_ENV_FILE_NAME"

# Setup the R environment
Rscript "$SETUP_ENV_FILE_PATH"

info "Finished setting up the R environment."
