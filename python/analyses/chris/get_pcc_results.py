import copy
import pandas as pd
from python.columns import CLEAN_COLUMNS
from python.libs.stats.pcc import get_pcc_var
from python.libs.r import run_r_script
from python.paths import PATHS


def get_pcc_results(df: pd.DataFrame) -> dict:
    """Get the results of the PCC analysis."""
    df = copy.deepcopy(df)  # For safety
    df = df[df[CLEAN_COLUMNS.EFFECT_TYPE] == "correlation"]
    df = run_r_script("process_data.R", df, "pcc_results.csv")

    # df_out["pcc_var_1"] = get_pcc_var(df_calc, offset=1)
    # df_out["pcc_var_2"] = get_pcc_var(df_calc, offset=2)

    # a. RE1 & RE2: Calculate random-effects twice (report its both the estimate and t-value for each) using the SEs for equation (1) and (2). I know that R has standard routines for this.  You should probably use the REML (restricted max likelihood) flavor of RE.
    return df
