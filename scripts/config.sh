#!/bin/bash

# A list of potential commands
# setup - Create a new configuration file, use the base configuration file as a template and allow the user to modify various settings. By default, a copy will be created, with individual unique things such as name, author, project, etc.
# copy - Copy an existing configuration file to a new location. Pretty much setup, but the base configuration file is already created by the user.
# validate - Validate that a configuration file is correct and can be used by the application.
# use - Choose a configuration file to use for the application. Each time the application is run, the configuration file will be loaded.
# destroy - Delete a configuration file. This will remove the configuration file from the system.
# show - Show the contents of a configuration file. This will display the contents of the configuration file to the user.
# list - List all configuration files. This will display all configuration files that are available to the user.

set -e

. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

#' Choose a configuration file to use for the application. Each time the application is run, the configuration file will be loaded.
use() {
  CONFIG_FILE=$1

  if [[ -z $CONFIG_FILE ]]; then
    error "No configuration file provided"
    error "Usage: $0 use <config_file_name>"
    exit 1
  fi

  CONFIG_FILE_PATH="$CONFIG_DIR/$CONFIG_FILE"

  if [[ ! -f $CONFIG_FILE_PATH ]]; then
    error "Configuration file not found: '$CONFIG_FILE'."
    error "Make sure this file exists in the $CONFIG_DIR directory."
    exit 1
  fi

  info "Using a configuration file '$CONFIG_FILE'"

  # TODO
  sed -i '' -e 's/configuration_file: .*/configuration_file \"$CONFIG_FILE\"/' $METADATA_FILE_PATH

}

# Function to display help
show_help() {
  echo "Usage: $0 <command> [args]"
  echo
  echo "Commands:"
  echo "  use             Choose a configuration file to use for the application"
  echo "  help            Display this help message"
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Main switch-case to handle commands
case "$1" in
use)
  shift
  use "$@"
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
