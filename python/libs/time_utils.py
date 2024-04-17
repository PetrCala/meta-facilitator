import pandas as pd


def calculate_time_taken(start_time: pd.Timestamp, end_time: pd.Timestamp) -> str:
    """Calculate the time taken between two timestamps and return it as a string."""
    time_taken = end_time - start_time
    time_taken_seconds = time_taken.total_seconds()
    if time_taken_seconds < 60:
        return f"{time_taken_seconds:.2f} seconds"
    time_taken_minutes = time_taken_seconds / 60
    return f"{time_taken_minutes:.2f} minutes, {time_taken_seconds:.2f} seconds"
