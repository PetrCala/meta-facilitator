from typing import NamedTuple

CleanColumns = NamedTuple(
    "CleanColumns",
    [
        ("STUDY", str),
        ("EFFECT_TYPE", str),
        ("EFFECT", str),
        ("SE", str),
        ("SAMPLE_SIZE", str),
        ("DF", str),
    ],
)

CLEAN_COLUMNS = CleanColumns(
    STUDY="study",
    EFFECT_TYPE="effect_type",
    EFFECT="effect",
    SE="se",
    SAMPLE_SIZE="sample_size",
    DF="df",
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
        ("PCC_VAR", str),
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
    PCC_VAR="pcc_var",
)
"""A set of columns in the analysed data frame."""
