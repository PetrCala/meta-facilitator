import pandas as pd
from python.const import CONST
from python.types import AnalysisName


def get_source_col_dict(metadata: dict, analysis_name: AnalysisName) -> dict:
    """Return a dictionary of source columns for a given analysis.

    Example:
    >>> from src.const import CONST
    >>> metadata = read_metadata()
    >>> cols = get_source_col_dict(metadata, CONST.ANALYSIS_NAMES.CHRIS)
    >>> print(cols)
    >>> # {'effect': 'Effect', 'se': 'Standard Error', ...}
    """
    return metadata[CONST.METADATA_KEYS.ANALYSES][analysis_name][
        CONST.METADATA_KEYS.ANALYSES_SOURCE_COLS
    ]
