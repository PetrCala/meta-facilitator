import os
import pandas as pd
from src.paths import PATHS
from src.libs.write_data import save_dict_as_json
from src.types import Results, AnalysisName, ResultsMetadata


def save_analysis_results(results: Results, analysis_name: AnalysisName) -> None:
    """Save the results of the analysis in the output folder."""
    if not os.path.exists(PATHS.OUTPUT_DIR):
        os.mkdir(PATHS.OUTPUT_DIR)
    analysis_time = results.metadata.time
    results_dir_name = f"{analysis_name}_{analysis_time}"
    results_dir_path = os.path.join(PATHS.OUTPUT_DIR, results_dir_name)
    os.mkdir(results_dir_path)
    # Save the objects only if they exist. If they do not, they will be None.
    if isinstance(results.df, pd.DataFrame):
        results.df.to_excel(os.path.join(results_dir_path, PATHS.RESULTS_DATA_FILENAME))
    if isinstance(results.metadata, ResultsMetadata):
        json_path = os.path.join(results_dir_path, PATHS.RESULTS_JSON_FILENAME)
        save_dict_as_json(obj=results.metadata._asdict(), path=json_path)
