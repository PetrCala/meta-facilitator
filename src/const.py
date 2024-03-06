from typing import NamedTuple, Literal
from src.cache_keys import CACHE_KEYS
from src.libs.extensions import ALLOWED_DATA_EXTENSIONS


class Const(NamedTuple):
    """
    A class representing constant values.
    """

    PROJECT_NAME: str = "meta-facilitator"
    PROJECT_NAME_VERBOSE: str = "Meta Facilitator"
    DATE_FORMAT: str = "%Y-%m-%d"
    ALLOWED_DATA_EXTENSIONS = ALLOWED_DATA_EXTENSIONS
    CACHE_KEYS = CACHE_KEYS


CONST = Const()
"""
A class representing constant values.

Usage:
>>> from src.const import CONST
>>> print(CONST.DATE_FORMAT) # "%Y-%m-%d"
"""
