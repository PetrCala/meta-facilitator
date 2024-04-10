from src.analyses import ANALYSES
from src.classes import Analysis
from src.types import AnalysisName


def run_analysis(analysis_name: AnalysisName, *args, **kwargs):
    """Run an analysis based on its name. The function utilizes the
    local metadata to determine the arguments to run the analysis with."""
    analysis: Analysis = ANALYSES.__getattr__(analysis_name)
    print(f"Running the analysis {analysis_name}...")
    analysis.run_analysis()
