from typing import NamedTuple

CleanColumns = NamedTuple(
    "CleanColumns",
    [
        ("EFFECT", str),
        ("SE", str),
    ],
)

CLEAN_COLUMNS = CleanColumns(
    EFFECT="effect",
    SE="se",
)
"""A set of columns that are required for the analysis."""


AnalysedColumns = NamedTuple(
    "AnalysedColumns",
    [
        ("N_EST", str),
        ("MEAN", str),
        ("MEDIAN", str),
        ("UWLS", str),
        ("WAAP_UWLS", str),
        ("PET_PEESE", str),
        ("AK", str),
        ("RE_DL_TAU_2", str),
        ("MSE_UWLS", str),
        ("PSS", str),
        ("E_SIG", str),
    ],
)

ANALYSED_COLUMNS = AnalysedColumns(
    N_EST="n_est",
    MEAN="mean",
    MEDIAN="median",
    UWLS="uwls",
    WAAP_UWLS="waap_uwls",
    PET_PEESE="pet_peese",
    AK="ak",
    RE_DL_TAU_2="re_dl_tau_2",
    MSE_UWLS="mse_uwls",
    PSS="pss",
    E_SIG="e_sig",
)
"""A set of columns in the analysed data frame."""
