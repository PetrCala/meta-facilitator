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
  echo "  apply           Choose a configuration file to use for the application"
  echo "  copy            Copy an existing configuration file"
  echo "  current         Print information about the current configuration file"
  echo "  validate        Validate a configuration file"
  echo "  remove          Delete a configuration file"
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

# Validate the configuration file based on its name
validate_config_file() {
  local CONFIG_NAME="$1"
  if [[ "$CONFIG_NAME" == "current" ]] || [[ -z $CONFIG_NAME ]]; then
    CONFIG_NAME="$(get_current_config_file)"
  fi
  local CONFIG_FILE_PATH="$CONFIG_DIR/$CONFIG_NAME.yaml"
  config_file_exists "$CONFIG_NAME"
  # TODO
  # success "Configuration file '$CONFIG_NAME.yaml' is valid"
}

# Run the config setup prompt sequence and return the name of the new configuration file.
run_config_setup() {
  NAME="new_config" # Name of the new configuration file
  touch "$CONFIG_DIR/$NAME.yaml"
  echo "$NAME"
}

# Setup a new configuration file
setup_config_file() {
  if [[ ! -d "$CONFIG_DIR" ]]; then
    info "Creating configuration directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
  fi

  # "text": "setwd('/Users/jf41513/code/meta/meta-facilitator')\nsource('R/run.R')\u000D"
  # Rscript "scripts/test.R"
  R --interactive --no-save --no-init-file -e "readline('Hello, world!')"
  # -e "source('scripts/test.R')"
  #   <<EOT
  #   source("scripts/test.R")
  # EOT

  # "scripts/test.R"

  # cd $R_DIR

  # local CONFIG_NAME="$(
  #   R --interactive --no-save --quiet <<EOT
  #     source("base/config.R")
  #     create_new_setup_file()
  # EOT
  # )"
  # local CONFIG_NAME="$(Rscript -e "source(\"base/config.R\")" -e "create_new_setup_file()")"

  # run_r_script_interactively "$RUN_FILE_PATH"
  # echo "Config name: $CONFIG_NAME"

  # local CONFIG_NAME="$(run_config_setup)"
  # local PARSE_SCRIPT_PATH="$CONFIG_SRC_DIR/parse_config.R"
  # local CONFIG_NAME="$(Rscript "libs/config/parse_config.R")"

  # Rscript "$RUN_FILE_PATH" "$@"
  # validate_config_file "$CONFIG_NAME"
  # success "Configuration file '$CONFIG_NAME.yaml' created"
}

# Function to get the name of the configuration file currently in use
# The name is expected to contain the .yaml suffix
get_current_config_file_name() {
  if [[ -f "$CONFIG_FILE_PATH" ]]; then
    SOURCE_FILE_NAME="$(yq '.headers.source_file' "$CONFIG_FILE_PATH")"

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

# Function to remove a configuration file
remove_config_file() {
  local CONFIG_NAME="$1"
  config_file_exists "$CONFIG_NAME"

  local CONFIG_FILE_PATH="$CONFIG_DIR/$CONFIG_NAME.yaml"
  rm "$CONFIG_FILE_PATH"
  success "Configuration file '$CONFIG_NAME.yaml' was deleted"
}

# Function to choose a configuration file to use
apply_config_file() {
  local CONFIG_NAME="$1"
  config_file_exists "$CONFIG_NAME"

  VALIDATION_OUTCOME=$(validate_config_file "$CONFIG_NAME")
  [[ ! -z $VALIDATION_OUTCOME ]] && error_exit "$VALIDATION_OUTCOME"

  SOURCE_FILE_NAME="$CONFIG_NAME.yaml"

  # Apply the configuration file
  cp "$CONFIG_DIR/$SOURCE_FILE_NAME" "$CONFIG_FILE_PATH"

  # Add the name of the source file to the configuration file headers
  yq -i e ".headers.source_file = \"$SOURCE_FILE_NAME\"" "$CONFIG_FILE_PATH"

  NEW_CONFIG_NAME="$(yq '.headers.name' "$CONFIG_FILE_PATH")"

  success "'$NEW_CONFIG_NAME' configuration applied (source: $SOURCE_FILE_NAME)"
}

# Function to copy a configuration file
copy_config_file() {
  local CONFIG_NAME="$1"
  local NEW_CONFIG_NAME="$2"
  config_file_exists "$CONFIG_NAME"

  local CONFIG_FILE_PATH="$CONFIG_DIR/$CONFIG_NAME.yaml"
  local NEW_CONFIG_FILE_PATH="$CONFIG_DIR/$NEW_CONFIG_NAME.yaml"

  if [[ -f "$NEW_CONFIG_FILE_PATH" ]]; then
    error_exit "Configuration file '$NEW_CONFIG_NAME.yaml' already exists"
  fi

  cp "$CONFIG_FILE_PATH" "$NEW_CONFIG_FILE_PATH"
  success "Configuration file '$CONFIG_NAME.yaml' copied to '$NEW_CONFIG_NAME.yaml'"
}

# Function to list all configuration files
list_config_files() {
  local FILES="$(ls "$CONFIG_DIR"/*.yaml)"

  echo "Available configuration files:"
  for file in $FILES; do
    is_in_use=false
    [[ "$(basename $file)" == "$(get_current_config_file_name)" ]] && is_in_use=true
    extract_yaml_metadata "$file" "$is_in_use"
  done
}

# Function to print a YAML node
print_yaml_node() {
  local NODE_NAME="$1"
  local YAML_FILE="$2"

  echo "$YAML_FILE"
  if yq e ".$NODE_NAME" "$YAML_FILE" &>/dev/null; then
    yq e ".$NODE_NAME" "$YAML_FILE"
  else
    error "'$NODE_NAME' node does not exist in $YAML_FILE."
  fi
}

show_current_config_file() {
  if [[ -f "$CONFIG_FILE_PATH" ]]; then
    print_yaml_node "headers" "$CONFIG_FILE_PATH"
  else
    info "No configuration file is currently in use"
  fi
}

# Function to show the contents of a configuration file
show_config_file() {
  local CONFIG_NAME="$1"
  if [[ "$CONFIG_NAME" == "current" ]] || [[ -z $CONFIG_NAME ]]; then
    show_current_config_file
  else
    config_file_exists "$CONFIG_NAME"
    print_yaml_node "headers" "$CONFIG_DIR/$CONFIG_NAME.yaml"
  fi
}

if [[ $# -eq 0 ]]; then
  show_help
  exit 1
fi

# Main switch-case to handle commands
case "$1" in
setup)
  setup_config_file
  ;;
copy)
  shift
  [[ -z "$1" ]] && error_exit "Please provide the name of the configuration file to copy"
  copy_config_file "$1" "$2"
  ;;
current)
  print_current_config_file_name
  ;;
validate)
  shift
  validate_config_file "$1"
  ;;
apply)
  shift
  [[ -z "$1" ]] && error_exit "Please provide the name of the configuration file to use"
  apply_config_file "$1"
  ;;
remove)
  shift
  [[ -z "$1" ]] && error_exit "Please provide the name of the configuration file to remove"
  remove_config_file "$1"
  ;;
show)
  shift
  show_config_file "$1"
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
