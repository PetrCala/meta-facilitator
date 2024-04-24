#!/bin/bash

set -e

VENV_PATH="venv"
CACHE_DIR_NAME="_cache"
SENTINEL_FILE_NAME="last_poetry_install.txt"

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPTS_DIR/shellUtils.sh"

ROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$ROJECT_ROOT_REL")
CACHE_DIR="$PROJECT_ROOT/$CACHE_DIR_NAME"
SENTINEL_FILE="$CACHE_DIR/$SENTINEL_FILE_NAME"

if ! command -v python3 &>/dev/null; then
    error "Python is not installed. Make sure to install it from https://www.python.org/downloads."
    exit 1
fi

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

if [[ ! -d $VENV_PATH ]]; then
    info "Spawning a virtual environment..."
    python3 -m venv $VENV_PATH
fi

source $VENV_PATH/bin/activate

# Install poetry into the venv

if ! command -v poetry &>/dev/null; then
    info "Installing poetry..."
    $VENV_PATH/bin/pip install -U pip setuptools
    $VENV_PATH/bin/pip install poetry
fi

# Check if the poetry.lock file is newer than the sentinel file
if [ "poetry.lock" -nt "$SENTINEL_FILE" ]; then
    info "poetry.lock has been modified since the last 'poetry install'."
    info "Installing Python dependencies..."
    poetry install
    # Update the sentinel file's timestamp
    touch "$SENTINEL_FILE"
else
    info "All Python dependencies are up-to-date."
fi

source "$SCRIPTS_DIR/setupR.sh" # Prints verbose output

success "Done."
