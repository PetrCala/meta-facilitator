import pandas as pd
from src.const import CONST
from src.libs.read_data import read_metadata, get_metadata_cols
from src.libs.get_results import get_n_studies
from src.libs.time_utils import calculate_time_taken
from src.types import AnalysisName, Results, ResultsMetadata


class GetResults:
    """
    Take a clean data frame, analyse it, and return the results.
    """

    def __init__(
        self, df: pd.DataFrame, analysis_name: AnalysisName, get_dfs_fun: callable
    ):
        self.df = df
        self.analysis_name = analysis_name
        self.get_dfs_fun = get_dfs_fun
        self.start_time = pd.Timestamp.now()
        self.metadata = read_metadata()
        self.results: Results = self.get_results()

    @property
    def analysed_df_cols(self) -> list[str]:
        """A property representing the columns of an analysed data frame."""
        return get_metadata_cols(
            key=CONST.METADATA_KEYS.ANALYSED_DF_COLS,
            expected_cols=list(CONST.ANALYSED_COLUMNS._asdict().values()),
        )

    def get_results_metadata(self) -> ResultsMetadata:
        """Get the metadata of the analysis results."""
        return ResultsMetadata(
            analysis_name=self.analysis_name,
            time=pd.Timestamp.now().strftime(CONST.DATE_TIME_FORMAT),
            time_taken=calculate_time_taken(self.start_time, pd.Timestamp.now()),
            n_studies=get_n_studies(self.df),
        )

    def get_results_dfs(self) -> dict[str, pd.DataFrame]:
        """Get the data frames of the analysis results."""
        return self.get_dfs_fun(df=self.df)

    def get_results(self) -> Results:
        """Get the results of the analysis."""
        return Results(
            metadata=self.get_results_metadata(),
            dfs=self.get_results_dfs(),
        )
