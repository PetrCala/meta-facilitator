#!/bin/sh

# A list of potential commands
# setup - Create a new configuration file, use the base configuration file as a template and allow the user to modify various settings. By default, a copy will be created, with individual unique things such as name, author, project, etc.
# copy - Copy an existing configuration file to a new location. Pretty much setup, but the base configuration file is already created by the user.
# validate - Validate that a configuration file is correct and can be used by the application.
# use - Choose a configuration file to use for the application. Each time the application is run, the configuration file will be loaded.
# destroy - Delete a configuration file. This will remove the configuration file from the system.
# show - Show the contents of a configuration file. This will display the contents of the configuration file to the user.
# list - List all configuration files. This will display all configuration files that are available to the user.

# Function to display help
show_help() {
  echo "Usage: $0 <command> [args]"
  echo
  echo "Commands:"
  echo "  help            Display this help message"
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Main switch-case to handle commands
case "$1" in
help)
  show_help
  ;;
*)
  echo "Error: Unknown command: $1"
  show_help
  exit 1
  ;;
esac
