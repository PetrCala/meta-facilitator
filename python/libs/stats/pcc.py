import pandas as pd
from python.columns import CLEAN_COLUMNS


def get_pcc_var(df: pd.DataFrame, offset: int) -> pd.Series:
    """Calculate the PCC variance."""
    pcc = df[CLEAN_COLUMNS.EFFECT]
    sample_size = df[CLEAN_COLUMNS.SAMPLE_SIZE]
    df_value = df[CLEAN_COLUMNS.DF]
    non_null_df = df_value.notnull()

    numerator = (1 - pcc**2) ** 2
    denominator = sample_size - 7
    denominator[non_null_df] = df_value[non_null_df] - offset
    return numerator / denominator
