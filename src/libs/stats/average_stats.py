import pandas as pd
from src.libs.validation import validate_column


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


def get_average_effect_stats(df: pd.DataFrame, col: str) -> dict:
    """Get the average effect stats of a column in a DataFrame.

    These include: mean, median, UWLS, WAAP_UWSL, PET_PEESE, and AK.
    """
    return {
        "mean": get_mean(df, col),
        "median": get_median(df, col),
        "uwls": get_uwls(df, col),
        "waap_uwsl": get_waap_uwsl(df, col),
        "pet_peese": get_pet_peese(df, col),
        "ak": get_ak(df, col),
    }
