import os
from typing import NamedTuple


class Paths(NamedTuple):
    SRC_DIR = os.path.dirname(__file__)
    PROJECT_ROOT = os.path.dirname(SRC_DIR)
    DATA_DIR = os.path.join(PROJECT_ROOT, "data")


PATHS = Paths()
"""
A class representing static paths in the project.

Usage:
>>> from src.paths import PATHS
>>> print(PATHS.PROJECT_ROOT) # /path/to/project/root
"""
