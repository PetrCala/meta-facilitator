#!/bin/bash

# This script clears the cache folder

set -e

CACHE_DIR_NAME="_cache"

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPTS_DIR/shellUtils.sh"

PROJECT_ROOT_REL=$(dirname "$SCRIPTS_DIR")
PROJECT_ROOT=$(get_abs_path "$PROJECT_ROOT_REL")

CACHE_FOLDER_PATH="$PROJECT_ROOT/$CACHE_DIR_NAME"

if [ -d "$CACHE_FOLDER_PATH" ]; then
  info "Clearing cache..."
  rm -rf "$CACHE_FOLDER_PATH"
  success "Cache cleared!"
else
  info "No cache found."
fi
