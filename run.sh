#!/bin/sh

# Function to display help
show_help() {
    echo "Usage: $0 <command> [args]"
    echo
    echo "Commands:"
    echo "  R               Invoke the R entrypoint script"
    echo "  lint            Lint all files in the R folder"
    echo "  merge           Merge the currently checked out git branch with another one, and push the changes to the remote repository"
    echo "  setup           Setup the environment"
    echo "  test            Run all tests"
    echo "  help            Display this help message"
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Main switch-case to handle commands
case "$1" in
R)
    shift
    sh scripts/runR.sh "$@"
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
