import pandas as pd
from src.const import CONST


def load_data_from_source(path: str) -> pd.DataFrame:
    """Read data from a file under the given path. The data has
    to be in one of the allowed file extensions.

    Raise an error if the file does not exist under the given path.
    """
    file_extension = path.split(".")[-1].lower()
    if file_extension not in CONST.ALLOWED_DATA_EXTENSIONS:
        raise ValueError(f"Unsupported file extension: {file_extension}")

    try:
        if file_extension == CONST.ALLOWED_DATA_EXTENSIONS.CSV:
            df = pd.read_csv(path)
        elif file_extension == CONST.ALLOWED_DATA_EXTENSIONS.XLSX:
            df = pd.read_excel(path)
        elif file_extension == CONST.ALLOWED_DATA_EXTENSIONS.JSON:
            df = pd.read_json(path)
        return df
    except FileNotFoundError:
        raise FileNotFoundError(f"File not found at path: {path}")
