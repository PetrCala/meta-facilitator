import json
from src.paths import PATHS


def read_metadata() -> dict:
    """Read the metadata.json file and return it as a dictionary."""
    with open(PATHS.METADATA, "r") as f:
        return json.load(f)


def get_metadata_cols(key: str, expected_cols: list[str]) -> list[str]:
    """Helper method to get the columns from metadata based on the given key."""
    metadata = read_metadata()
    cols = list(metadata[key].keys())
    if not set(cols) == set(expected_cols):
        raise ValueError(
            f"The data frame input columns are not correct.\nExpected: {expected_cols}.\nGot: {cols}"
        )
    return cols
