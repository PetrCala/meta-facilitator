import pandas as pd
from src.libs.validation import validate_column
from src.columns import ANALYSED_COLUMNS


@validate_column
def get_mean(df: pd.DataFrame, col: str) -> float:
    """Get the mean of a column in a DataFrame."""
    return df[col].mean()


@validate_column
def get_median(df: pd.DataFrame, col: str) -> float:
    """Get the median of a column in a DataFrame."""
    return df[col].median()


@validate_column
def get_uwls(df: pd.DataFrame, col: str) -> dict:
    # TODO
    return {}
    # q1 = df[col].quantile(0.25)
    # q3 = df[col].quantile(0.75)
    # iqr = q3 - q1
    # return {"upper": q3 + 1.5 * iqr, "lower": q1 - 1.5 * iqr}


@validate_column
def get_waap_uwsl(df: pd.DataFrame, col: str) -> dict:
    # TODO
    return {}
    # q1 = df[col].quantile(0.25)
    # q3 = df[col].quantile(0.75)
    # iqr = q3 - q1
    # return {"upper": q3 + 3 * iqr, "lower": q1 - 3 * iqr}


@validate_column
def get_pet_peese(df: pd.DataFrame, col: str) -> dict:
    # TODO
    return {}
    # q1 = df[col].quantile(0.25)
    # q3 = df[col].quantile(0.75)
    # iqr = q3 - q1
    # return {"upper": q3 + 2 * iqr, "lower": q1 - 2 * iqr}


@validate_column
def get_ak(df: pd.DataFrame, col: str) -> dict:
    # TODO
    return {}
    # q1 = df[col].quantile(0.25)
    # q3 = df[col].quantile(0.75)
    # iqr = q3 - q1
    # return {"upper": q3 + 1.5 * iqr, "lower": q1 - 1.5 * iqr}
