from typing import Any, List
from src.const import CONST
from src.analyses.chris.chris import Chris
from src.libs.classes import Analysis
from src.types import AnalysisName


class Analyses:
    """
    A class representing the set of all available analyses.
    """

    analysis_mapping = {
        CONST.ANALYSIS_NAMES.CHRIS: Chris,
    }

    def __init__(self):
        """Constructor for the Analyses class."""
        for name, analysis in self.analysis_mapping.items():
            setattr(self, name, analysis())

    def keys(self) -> List[AnalysisName]:
        return list(self.analysis_mapping.keys())

    def values(self) -> List:
        return list(self.analysis_mapping.values())

    def __getattr__(self, name: AnalysisName) -> Analysis:
        """
        Get an analysis by name. If the analysis is not found,
        raise an AttributeError.
        """
        if name in self.keys():
            return getattr(self, name)
        raise AttributeError(f"Analysis {name} not found.")


ANALYSES = Analyses()
"""
A set of all available analyses.
"""
