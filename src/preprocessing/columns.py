from typing import NamedTuple

AnalysisColumns = NamedTuple(
    "AanalysisColumns",
    [
        ("EFFECT", str),
        ("SE", str),
    ],
)
"""A set of columns that are required for the analysis."""

ANALYSIS_COLUMNS = AnalysisColumns(
    EFFECT="effect",
    SE="se",
)
