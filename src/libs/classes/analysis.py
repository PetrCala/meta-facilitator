import os
import pandas as pd
from src.paths import PATHS
from src.cache import get_or_load_data
from src.libs.read_data import load_data_from_source
from src.libs.write_data import save_analysis_results
from .clean_df import CleanDf
from .get_results import GetResults
from src.types import AnalysisName, DfName, Results


class Analysis:
    """A base class representing any analysis."""

    def __init__(
        self,
        analysis_name: AnalysisName,
        df_name: DfName,
        cache_key: str,
        get_dfs_fun: callable,
    ):
        """A constructor for the Analysis class."""
        self.analysis_name = analysis_name
        self.df_name = df_name
        self.data_path = os.path.join(PATHS.DATA_DIR, df_name)  # full path to data
        self.data_cache_key = cache_key
        self.get_dfs_fun = get_dfs_fun  # Function to get the results data frames

    def load_data(self, use_cache: bool = True) -> pd.DataFrame:
        """Load the raw source data for this analysis and return it as a pd.DataFrame."""
        if use_cache:
            return get_or_load_data(self.data_cache_key, self.data_path)
        return load_data_from_source(self.data_path)

    def clean_data(self, df: pd.DataFrame = None) -> pd.DataFrame:
        """Clean the raw data frame so that it can be analysed."""
        if not isinstance(df, pd.DataFrame):
            df = self.load_data(use_cache=True)
        return CleanDf(df=df, analysis_name=self.analysis_name).df

    def get_results(self, clean_df: pd.DataFrame = None) -> Results:
        """Get the results of the analysis using the clean data frame."""
        if not isinstance(clean_df, pd.DataFrame):
            clean_df = self.clean_data()  # Automatically loads the data too
        return GetResults(
            df=clean_df, analysis_name=self.analysis_name, get_dfs_fun=self.get_dfs_fun
        ).results

    def save_results(self, results: Results) -> None:
        """Save the results of the analysis in the output folder."""
        save_analysis_results(results=results, analysis_name=self.analysis_name)

    def run_analysis(self, save_results: bool = True, verbose: bool = True) -> any:
        """Main method for running the whole analysis pipeline, from a raw data frame,
        to a fully analyzed data frame.

        Args:
        - save_results (bool, Optional): If True, save the results. Defaults to True.
        - verbose (bool, Optional): If True, print information about the analysis run.
            Defaults to True.
        """
        print("Getting results...")
        results = self.get_results()
        if save_results:
            print("Saving results...")
            self.save_results(results)
        if verbose:
            print(
                f"The analysis for '{self.analysis_name}' is complete.\n"
                f"Results: {results.metadata._asdict()}\n"
                f"Find all the results in: {PATHS.OUTPUT_DIR}"
            )
        return results
