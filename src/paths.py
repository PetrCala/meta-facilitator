import os
from typing import NamedTuple
from src.types import AnalysisName, DfName


class DataFrames(NamedTuple):
    CHRIS: DfName = "chris_data.xlsx"


class Paths(NamedTuple):
    SRC_DIR = os.path.dirname(__file__)
    PROJECT_ROOT = os.path.dirname(SRC_DIR)
    OUTPUT_DIR = os.path.join(PROJECT_ROOT, "output")
    METADATA = os.path.join(SRC_DIR, "metadata.json")
    DATA_DIR = os.path.join(PROJECT_ROOT, "data")
    DATA_FRAMES = DataFrames()


PATHS = Paths()
"""
A class representing static paths in the project.

Usage:
>>> from src.paths import PATHS
>>> print(PATHS.PROJECT_ROOT) # /path/to/project/root
"""
