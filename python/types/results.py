from typing import NamedTuple
import pandas as pd
from .analyses import AnalysisName


class ResultsMetadata(NamedTuple):
    """A named tuple representing the metadata of an analysis.

    Attributes:
    - analysis_name (AnalysisName): The name of the analysis.
    - time (str): The time the analysis was run.
    - time_taken (str): The time taken to run the analysis.
    - n_studies (int): The number of studies in the analysis.
    """

    analysis_name: AnalysisName
    time: str
    time_taken: str
    n_studies: int


class Results(NamedTuple):
    """A named tuple representing the results of an analysis."""

    metadata: ResultsMetadata
    dfs: dict[str, pd.DataFrame]
