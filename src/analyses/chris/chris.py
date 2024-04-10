import pandas as pd
from src.const import CONST
from src.paths import PATHS
from src.libs.classes import Analysis
from .get_ess_results import get_ess_results
from .get_pcc_results import get_pcc_results


def get_dfs_fun(df: pd.DataFrame) -> dict[str, pd.DataFrame]:
    """Get the data frames of the analysis results."""
    return {
        "pcc": get_pcc_results(df),
        "ess": get_ess_results(df),
    }


class Chris(Analysis):
    """
    A class for the Chris pipeline data, extending the generic Anaysis class.
    """

    def __init__(self):
        """A constructor for the Chris class."""
        super().__init__(
            analysis_name=CONST.ANALYSIS_NAMES.CHRIS,
            df_name=PATHS.DATA_FRAMES.CHRIS,
            cache_key=CONST.CACHE_KEYS.CHRIS,
            get_dfs_fun=get_dfs_fun,
        )
