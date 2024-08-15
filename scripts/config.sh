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
  CONFIG_NAME=$1

  CHOSEN_CONFIG_FILE="$CONFIG_NAME.yaml"

  if [[ -z $CHOSEN_CONFIG_FILE ]]; then
    error "No configuration file provided"
    error "Usage: $0 use <config_file_name>"
    exit 1
  fi

  CHOSEN_CONFIG_FILE_PATH="$CONFIG_DIR/$CHOSEN_CONFIG_FILE"

  if [[ ! -f $CHOSEN_CONFIG_FILE_PATH ]]; then
    error "Configuration file not found: '$CHOSEN_CONFIG_FILE'."
    error "Make sure this file exists in the $CONFIG_DIR directory."
    exit 1
  fi

  cp $CHOSEN_CONFIG_FILE_PATH $CONFIG_FILE_PATH

  # Load the configuration variables into memory
  eval $(parse_yaml $CHOSEN_CONFIG_FILE_PATH "CUSTOM_CONFIG_")

  if [[ -z "$CUSTOM_CONFIG_name" ]]; then
    error "Missing configuration name in the configuration file '$CHOSEN_CONFIG_FILE'"
    exit 1
  fi

  info "Configuration '$CUSTOM_CONFIG_name' is now in use (source: $CHOSEN_CONFIG_FILE)"
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
