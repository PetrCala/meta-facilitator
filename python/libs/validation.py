import pandas as pd
from functools import wraps


def validate_column(func: callable) -> callable:
    """
    Decorator function that validates the existence of a column in a DataFrame before calling the original function.

    Args:
        func (callable): The original function to be decorated.

    Returns:
        callable: The decorated function.

    """

    @wraps(func)
    def wrapper(df, col, *args, **kwargs):
        validate_col_exists(df, col)  # Perform validation
        return func(df, col, *args, **kwargs)  # Call the original function

    return wrapper


def validate_col_exists(df: pd.DataFrame, col: str) -> None:
    """Validate that a column exists in a DataFrame.
    If it does not, raise a ValueError.
    """
    if not isinstance(df, pd.DataFrame):
        raise TypeError("df must be a pandas DataFrame")
    if not isinstance(col, str):
        raise TypeError("col must be a string")
    if col not in df.columns:
        raise ValueError(f"{col} is not a column in the DataFrame")
