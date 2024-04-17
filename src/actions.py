from src.analyses import ANALYSES
from src.libs.classes import Analysis
from src.explore import explore as explore_main
from src.types import AnalysisName


def run_analysis(analysis_name: AnalysisName, *args, **kwargs):
    """Run an analysis based on its name. The function utilizes the
    local metadata to determine the arguments to run the analysis with."""
    analysis: Analysis = ANALYSES.__getattr__(analysis_name)
    print(f"Running the analysis {analysis_name}...")
    analysis.run_analysis()


def explore(*args, **kwargs):
    """Run the exploration script."""
    explore_main(*args, **kwargs)
