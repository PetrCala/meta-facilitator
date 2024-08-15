#!/bin/bash

# This script clears the cache folder

set -e

. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if [ -d "$CACHE_DIR" ]; then
  info "Clearing cache..."
  rm -rf "$CACHE_DIR"
  success "Cache cleared!"
else
  info "No cache found."
fi
