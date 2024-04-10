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


def run_r_script(script_name: str, df_in: pd.DataFrame = None, file_name: str = None):
    """Run an R script to process data. Use an existing input file,
    and write the output to a new file. Use only relative paths,
    including the suffix. The function automatically routes
    to the R I/O folders.

    Note:
    - Assume all scripts are placed in the src/r folder.

    Args:
    - script_name: The name of the R script to run.
    - df_in: The input DataFrame to save to a file.
    - file_name: The name of the file to save the input data to.


    Example:
    >>> run_r_script("preprocess_data.R", "data.csv", "output.csv")
    """
    # Handle paths
    ensure_r_folders_exist()
    full_path_in = f"{PATHS.R_DIR_IN}/{file_name}"
    full_path_out = f"{PATHS.R_DIR_OUT}/{file_name}"
    full_script_path = f"{PATHS.R_SCRIPTS_PATH}/{script_name}"

    # Save the input file
    df_in.to_csv(full_path_in, index=False)

    # Command to execute the R script
    command = ["Rscript", full_script_path, full_path_in, full_path_out]

    # Execute the command
    result = subprocess.run(command, capture_output=True, text=True)

    # Check for errors
    if result.returncode != 0:
        print("Error running R script:", result.stderr)
    else:
        print("R script output:", result.stdout)

    if not df_in.empty:
        if not os.path.exists(full_path_out):
            print(f"Output file not found: {full_path_out}")
            sys.exit(1)
        return pd.read_csv(full_path_out)

    return None
