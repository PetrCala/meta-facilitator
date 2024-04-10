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

    # Override the static array of columns specific to the Chris pipeline
    columns = [
        "n_est",
        "mean",
        "median",
        "uwls",
        "waap_uwls",
        "pet_peese",
        "ak",
        "re_dl_tau_2",
        "mse_uwls",
        "pss",
        "e_sig",
    ]

    # Override the static descriptions for each column specific to the Chris pipeline
    descriptions = {
        "n_est": "The number of estimates (k)",
        "mean": "The simple mean (or average)",
        "median": "The median",
        "uwls": "UWLS",
        "waap_uwls": "WAAP-UWLS",
        "pet_peese": "PET-PEESE",
        "ak": "AK",
        "re_dl_tau_2": "RE DL's tau^2",
        "mse_uwls": "The MSE from UWLS",
        "pss": "PSS",
        "e_sig": "Esig",
    }
