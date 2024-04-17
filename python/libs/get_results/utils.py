import pandas as pd
from python.const import CONST


def get_n_studies(df: pd.DataFrame) -> int:
    """Get the number of studies in the data frame."""
    return len(df[CONST.CLEAN_COLUMNS.STUDY].value_counts())


def get_single_ma_statistics(df: pd.DataFrame) -> pd.DataFrame:
    """Given a meta-analysis data, generate a row of statistics that characterizes it fully.

    Return this row as a pandas data frame.
    """
    # df.Filename()
    pass
