import pandas as pd
from src.const import CONST
from src.libs.clean_data import get_source_col_dict
from src.libs.read_data import read_metadata, get_metadata_cols
from src.types import AnalysisName


class CleanDf:
    """
    Take a data frame, clean it, and prepare all the necessary columns.
    """

    def __init__(self, df: pd.DataFrame, analysis_name: AnalysisName):
        self.df = df
        self.analysis_name = analysis_name
        self.metadata = read_metadata()
        self.source_cols = get_source_col_dict(
            metadata=self.metadata, analysis_name=self.analysis_name
        )
        self.preprocess()
        self.validate()

    @property
    def clean_df_cols(self) -> list[str]:
        """A property representing the columns of the clean data frame."""
        return get_metadata_cols(
            key=CONST.METADATA_KEYS.CLEAN_DF_COLS,
            expected_cols=list(CONST.CLEAN_COLUMNS._asdict().values()),
        )

    def check_source_cols_existence(self) -> None:
        """Check that all columns defined in metadata exist in the raw data frame."""
        missing_cols = set(self.source_cols.values()) - set(self.df.columns)
        if missing_cols:
            raise ValueError(f"Missing columns in the raw data frame: {missing_cols}")

    def rename_columns(self):
        """Rename relevant columns to fit the expected form."""
        for new_name, src_name in self.source_cols.items():
            if src_name in self.df.columns:
                self.df.rename(columns={src_name: new_name}, inplace=True)

    def subset_to_relevant_columns(self):
        """Select only the relevant columns for analysis."""
        relevant_columns = self.source_cols.keys()
        self.df = self.df[relevant_columns]

    # def remove_missing_values(self):
    #     """Remove rows with missing values."""
    #     self.df.dropna(inplace=True)

    # def encode_categoricals(self):
    #     """Dummy encode categorical variables. Adjust as needed."""
    #     categorical_cols = self.df.select_dtypes(include=["object", "category"]).columns
    #     self.df = pd.get_dummies(self.df, columns=categorical_cols, drop_first=True)

    # def normalize_numericals(self):
    #     """Normalize numerical columns. Adjust as needed."""
    #     numerical_cols = self.df.select_dtypes(include=["int64", "float64"]).columns
    #     scaler = StandardScaler()
    #     self.df[numerical_cols] = scaler.fit_transform(self.df[numerical_cols])

    def validate_columns(self):
        """Ensure that all columns are valid.

        This method should be called at the end of the preprocessing pipeline.
        """
        required_cols = self.clean_df_cols
        missing_cols = set(required_cols) - set(self.df.columns)
        if missing_cols:
            raise ValueError(
                f"Missing columns during data preprocessing: {missing_cols}"
            )

    def preprocess(self):
        """Run all preprocessing steps."""
        self.check_source_cols_existence()
        self.rename_columns()
        self.subset_to_relevant_columns()
        # self.remove_missing_values()
        # self.encode_categoricals()
        # self.normalize_numericals()

    def validate(self):
        """Validate the results of the preprocessing pipeline."""
        self.validate_columns()
