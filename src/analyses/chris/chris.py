from src.const import CONST
from src.paths import PATHS
from src.classes import Analysis


class Chris(Analysis):
    """
    A class for the Chris pipeline data, extending the generic Anaysis class.
    """

    def __init__(self):
        """A constructor for the Chris class."""
        super().__init__(
            name=CONST.ANALYSIS_NAMES.CHRIS,
            df_name=PATHS.DATA_FRAMES.CHRIS,
            cache_key=CONST.CACHE_KEYS.CHRIS,
        )
