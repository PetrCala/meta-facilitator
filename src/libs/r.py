import sys
import os
import subprocess
import pandas as pd
from src.paths import PATHS


def ensure_r_folders_exist():
    """Create the input and output folders for R scripts if they don't exist."""
    if not os.path.exists(PATHS.R_DIR_IN):
        os.makedirs(PATHS.R_DIR_IN)
    if not os.path.exists(PATHS.R_DIR_OUT):
        os.makedirs(PATHS.R_DIR_OUT)


def run_r_script(action: str, *args):
    """Run an R script to process data. Specify an action to execute with optional args and kwargs.
    The function does not accept kwargs. All arguments are passed to the R script as
    positional arguments in the sequence they are defined.


    Args:
    - action (str): The action to perform in the R script.
    - args: The arguments to pass to the R script.


    Example:
    >>> run_r_script("add", 3, 5)  # For adding two numbers
    >>> run_r_script("greet", Alice")  # For greeting a user
    """
    # Handle paths
    ensure_r_folders_exist()
    entrypoint_path = f"{PATHS.R_SCRIPTS_PATH}/{PATHS.R_ENTRYPOINT}"

    # Construct the command to execute the R script
    command = ["Rscript", entrypoint_path, action]

    # Add positional arguments dynamically
    for arg in args:
        try:
            arg = str(arg)
        except ValueError:
            raise ValueError("Arguments must be convertible to strings.")
        command.append(arg)

    # Execute the command
    result = subprocess.run(command, capture_output=True, text=True)

    # Check for errors
    if result.returncode != 0:
        print("Error running R script:\n", result.stderr)
    else:
        print("R script output:\n", result.stdout)

    # if not df_in.empty:
    #     if not os.path.exists(full_path_out):
    #         print(f"Output file not found: {full_path_out}")
    #         sys.exit(1)
    #     return pd.read_csv(full_path_out)

    return None
