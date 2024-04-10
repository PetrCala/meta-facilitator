import pandas as pd
from src.columns import ANALYSED_COLUMNS
from .source.average_stats import (
    get_mean,
    get_median,
    get_uwls,
    get_waap_uwsl,
    get_pet_peese,
    get_ak,
)


def get_effect_stats(df: pd.DataFrame, col: str) -> dict:
    """Calculate statistics related to the study effect."""
    return {
        ANALYSED_COLUMNS.MEAN: get_mean(df, col),
        ANALYSED_COLUMNS.MEDIAN: get_median(df, col),
        ANALYSED_COLUMNS.UWLS: get_uwls(df, col),
        ANALYSED_COLUMNS.WAAP_UWLS: get_waap_uwsl(df, col),
        ANALYSED_COLUMNS.PET_PEESE: get_pet_peese(df, col),
        ANALYSED_COLUMNS.AK: get_ak(df, col),
        ANALYSED_COLUMNS.PCC_VAR: 0.0,
    }
