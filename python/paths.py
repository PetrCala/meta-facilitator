import os
from typing import NamedTuple
from python.types import AnalysisName, DfName


class DataFrames(NamedTuple):
    CHRIS: DfName = "chris_data.xlsx"


class Paths(NamedTuple):
    SRC_DIR = os.path.dirname(__file__)
    PROJECT_ROOT = os.path.dirname(SRC_DIR)
    OUTPUT_DIR = os.path.join(PROJECT_ROOT, "output")
    R_DIR = os.path.join(PROJECT_ROOT, "r")
    R_DIR_IN = os.path.join(R_DIR, "input")
    R_DIR_OUT = os.path.join(R_DIR, "output")
    R_SCRIPTS_PATH = os.path.join(SRC_DIR, "r")
    R_ENTRYPOINT = "entrypoint.R"
    RESULTS_JSON_FILENAME = "results.json"
    METADATA = os.path.join(PROJECT_ROOT, "metadata.json")
    DATA_DIR = os.path.join(PROJECT_ROOT, "data")
    DATA_FRAMES = DataFrames()


PATHS = Paths()
"""
A class representing static paths in the project.

Usage:
>>> from src.paths import PATHS
>>> print(PATHS.PROJECT_ROOT) # /path/to/project/root
"""
