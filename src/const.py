from typing import NamedTuple, Literal
from src.cache_keys import CACHE_KEYS
from src.libs.extensions import ALLOWED_DATA_EXTENSIONS
from src.columns import CLEAN_COLUMNS, ANALYSED_COLUMNS
from src.types import AnalysisName


class MetadataKeys(NamedTuple):
    CLEAN_DF_COLS: str = "clean_df_cols"
    ANALYSED_DF_COLS: str = "analysed_df_cols"
    ANALYSES: str = "analyses"
    ANALYSES_SOURCE_COLS: str = "source_cols"


class AnalysisNames(NamedTuple):
    """
    A class representing the names of the analyses.
    """

    CHRIS: AnalysisName = "Chris"


class Const(NamedTuple):
    """
    A class representing constant values.
    """

    PROJECT_NAME: str = "meta-facilitator"
    PROJECT_NAME_VERBOSE: str = "Meta Facilitator"
    DATE_FORMAT: str = "%Y-%m-%d"
    TIME_FORMAT: str = "%H:%M:%S"
    DATE_TIME_FORMAT: str = f"{DATE_FORMAT} {TIME_FORMAT}"
    ALLOWED_DATA_EXTENSIONS = ALLOWED_DATA_EXTENSIONS
    CACHE_KEYS = CACHE_KEYS
    ANALYSED_COLUMNS = ANALYSED_COLUMNS
    CLEAN_COLUMNS = CLEAN_COLUMNS
    ANALYSIS_NAMES = AnalysisNames()
    METADATA_KEYS = MetadataKeys()


CONST = Const()
"""
A class representing constant values.

Usage:
>>> from src.const import CONST
>>> print(CONST.DATE_FORMAT) # "%Y-%m-%d"
"""
