import os
import pandas as pd
from src.const import CONST
from src.paths import PATHS
from src.types import AnalysisName, DfName
from src.cache import get_or_load_data
from src.libs.read_data import load_data_from_source


class Analysis:
    """A base class representing any analysis."""

    def __init__(self, name: AnalysisName, df_name: DfName, cache_key: str):
        """A constructor for the Analysis class."""
        self.name = name
        self.df_name = df_name
        self.data_path = os.path.join(PATHS.DATA_DIR, df_name)  # full path to data
        self.data_cache_key = cache_key

    def load_data(self, use_cache: bool = True) -> pd.DataFrame:
        """Load the raw source data for this analysis and return it as a pd.DataFrame."""
        if use_cache:
            return get_or_load_data(self.data_cache_key, self.data_path)
        return load_data_from_source(self.data_path)

    def clean_data(self, df: pd.DataFrame = None) -> pd.DataFrame:
        if not isinstance(df, pd.DataFrame):
            df = self.load_data(use_cache=True)
        pass

    def get_results(self, clean_df: pd.DataFrame = None) -> any:
        """Get the results of the analysis using the clean data frame."""
        if not isinstance(clean_df, pd.DataFrame):
            clean_df = self.clean_data()  # Automatically loads the data too
        return clean_df  # TODO this should return results

    def save_results(self, results: any) -> None:
        pass

    def run_analysis(self, save_results: bool = True, verbose: bool = True) -> any:
        """Main method for running the whole analysis pipeline, from a raw data frame,
        to a fully analyzed data frame.

        Args:
        - save_results (bool, Optional): If True, save the results. Defaults to True.
        - verbose (bool, Optional): If True, print information about the analysis run.
            Defaults to True.
        """
        results = self.get_results()
        if save_results:
            self.save_results(results)
        if verbose:
            print("The analysis for", self.name, "is complete.")
            print("Find the results in", "...")
        return results
