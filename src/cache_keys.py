from typing import NamedTuple


class CacheKeys(NamedTuple):
    """
    A class representing the paths used for caching.
    """

    BASE_DIR: str = "./cache"
    TEST_DATA: str = "test-data"


CACHE_KEYS = CacheKeys()
"""
Do not import this directly. Instead, use

>>> from src.const import CONST
>>> print(CONST.CACHE_KEYS.TEST_DATA) # ./test-data.csv
"""
