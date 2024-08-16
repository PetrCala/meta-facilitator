#!/bin/bash

# Function to display help
show_help() {
  echo "Usage: $0 <command> [args]"
  echo
  echo "Commands:"
  echo "  R               Invoke the R run script"
  echo "  config           Configurate the project"
  echo "  clear-cache     Clear the cache"
  echo "  lint            Lint all files in the R folder"
  echo "  merge           Merge the currently checked out git branch with another one, and push the changes to the remote repository"
  echo "  setup           Setup the environment"
  echo "  test            Run all tests"
  echo "  help            Display this help message"
}

# Check if yq is installed

if ! command -v yq &>/dev/null; then
  echo "yq is not installed. Please install yq to use this script."
  exit 1
fi

# Check if no arguments were provided
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Main switch-case to handle commands
case "$1" in
[Rr])
  shift
  sh scripts/runR.sh "$@"
  ;;
config)
  shift
  sh scripts/config.sh "$@"
  ;;
clear-cache)
  shift
  sh scripts/clearCache.sh "$@"
  ;;
lint)
  shift
  sh scripts/lintAll.sh "$@"
  ;;
merge)
  shift
  sh scripts/mergeAndPush.sh "$@"
  ;;
setup)
  shift
  sh scripts/setup.sh "$@"
  ;;
test)
  shift
  sh scripts/test.sh "$@"
  ;;
help)
  show_help
  ;;
*)
  echo "Error: Unknown command: $1"
  show_help
  exit 1
  ;;
esac
