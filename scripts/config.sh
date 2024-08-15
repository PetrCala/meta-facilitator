#!/bin/bash

set -e

# Developer help:
#   CONFIG_NAME = name of the configuration file without the .yaml suffix
#   CONFIG_FILE_NAME = name of the configuration file with the .yaml suffix

. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Function to display help
show_help() {
  echo "Usage: $0 <command> [args]"
  echo
  echo "Commands:"
  echo "  setup           Create a new configuration file from a template"
  echo "  copy            Copy an existing configuration file"
  echo "  current         Print information about the current configuration file"
  echo "  validate        Validate a configuration file"
  echo "  use             Choose a configuration file to use for the application" # DONE
  echo "  remove          Delete a configuration file"                            # DONE
  echo "  show            Show the contents of a configuration file"
  echo "  list            List all configuration files"
  echo "  help            Display this help message"
}

# Function to print an error message and exit
error_exit() {
  error "Error: $1"
  # show_help
  exit 1
}

# Function to check if a configuration file exists
config_file_exists() {
  local CONFIG_NAME="$1"
  local CONFIG_FILE_PATH="$CONFIG_DIR/$CONFIG_NAME.yaml"

  if [[ ! -f "$CONFIG_FILE_PATH" ]]; then
    error_exit "Configuration file not found: '$CONFIG_NAME.yaml'"
  fi
}

# Function to load a configuration file
load_config_file() {
  local CONFIG_NAME="$1"
  local CONFIG_FILE_PATH="$CONFIG_DIR/$CONFIG_NAME.yaml"
  config_file_exists "$CONFIG_NAME"

  eval "$(parse_yaml "$CONFIG_FILE_PATH" "CUSTOM_CONFIG")"
}

# Function to get the name of the configuration file currently in use
# The name is expected to contain the .yaml suffix
get_current_config_file_name() {
  if [[ -f "$CONFIG_FILE_PATH" ]]; then
    eval "$(parse_yaml "$CONFIG_FILE_PATH" "CONFIG_IN_USE")"
    SOURCE_FILE_NAME="$CONFIG_IN_USE__headers__source_file"

    if [[ -z $SOURCE_FILE_NAME ]]; then
      error_exit "Could not determine the source file of the current configuration. Try running 'config use' again"
    fi

    echo "$SOURCE_FILE_NAME"
  else
    error_exit "No configuration file is currently in use"
  fi
}

# Function to get the name of the configuration file currently in use without the .yaml suffix
get_current_config_file() {
  CURRENT_CONFIG_FILE="$(get_current_config_file_name)"
  CURRENT_CONFIG_FILE="${CURRENT_CONFIG_FILE%.yaml}"
  echo "$CURRENT_CONFIG_FILE"
}

print_current_config_file_name() {
  CURRENT_CONFIG="$(get_current_config_file_name)"
  info "Current configuration file: '$CURRENT_CONFIG'"
}

# Function to print configuration information based on the full path to a configuration file
print_config_info() {
  local CONFIG_NAME="$1"
  load_config_file "$CONFIG_NAME"

  CONFIG_HEADERS=$(compgen -v | grep -E "^CUSTOM_CONFIG__headers")
  echo $CONFIG_HEADERS
}

# Function to remove a configuration file
remove_config_file() {
  local CONFIG_NAME="$1"
  config_file_exists "$CONFIG_NAME"

  local CONFIG_FILE_PATH="$CONFIG_DIR/$CONFIG_NAME.yaml"
  rm "$CONFIG_FILE_PATH"
  success "Configuration file '$CONFIG_NAME.yaml' was deleted"
}

# Function to choose a configuration file to use
use_config_file() {
  local CONFIG_NAME="$1"
  config_file_exists "$CONFIG_NAME"

  cp "$CONFIG_DIR/$CONFIG_NAME.yaml" "$CONFIG_FILE_PATH"
  load_config_file "$CONFIG_NAME"

  if [[ -z "$CUSTOM_CONFIG__headers__name" ]]; then
    error_exit "Missing configuration name in the configuration file '$CONFIG_NAME.yaml'"
  fi

  success "Configuration '$CUSTOM_CONFIG__headers__name' is now in use (source: $CONFIG_NAME.yaml)"
}

# Function to list all configuration files
list_config_files() {
  echo "Available configuration files:"
  ls "$CONFIG_DIR"/*.yaml | xargs -n 1 basename
}

# Function to show the contents of a configuration file
show_config_file() {
  local CONFIG_NAME="$1"
  config_file_exists "$CONFIG_NAME"

  cat "$CONFIG_DIR/$CONFIG_NAME.yaml"
}

show_current_config_file() {
  if [[ -f "$CONFIG_FILE_PATH" ]]; then
    CURRENT_CONFIG_FILE="$(get_current_config_file)"
    show_config_file "$CURRENT_CONFIG_FILE"
  else
    info "No configuration file is currently in use"
  fi
}

if [[ $# -eq 0 ]]; then
  show_help
  exit 1
fi

# Main switch-case to handle commands
case "$1" in
setup)
  # Implement the setup logic here
  ;;
copy)
  [[ -z "$1" ]] && error_exit "Please provide the name of the configuration file to copy"
  # Implement the copy logic here
  ;;
current)
  print_current_config_file_name
  ;;
validate)
  shift
  [[ -z "$1" ]] && error_exit "Please provide the name of the configuration file to validate"
  # Implement the validate logic here
  ;;
use)
  shift
  [[ -z "$1" ]] && error_exit "Please provide the name of the configuration file to use"
  use_config_file "$1"
  ;;
remove)
  shift
  [[ -z "$1" ]] && error_exit "Please provide the name of the configuration file to remove"
  remove_config_file "$1"
  ;;
show)
  shift
  [[ -z "$1" ]] && error_exit "No configuration file provided"

  if [[ "$1" == "current" ]]; then
    show_current_config_file
  else
    show_config_file "$1"
  fi
  ;;
list)
  list_config_files
  ;;
help)
  show_help
  ;;
*)
  error_exit "Unknown command: $1"
  ;;
esac
