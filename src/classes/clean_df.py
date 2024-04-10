import pandas as pd
from sklearn.preprocessing import StandardScaler
from src.const import CONST


class CleanDf:
    """
    Take a data frame, clean it, and prepare all the necessary columns.
    """

    def __init__(self, df):
        self.df = df
        self.preprocess()
        self.validate()

    def remove_missing_values(self):
        """Remove rows with missing values."""
        self.df.dropna(inplace=True)

    def encode_categoricals(self):
        """Dummy encode categorical variables. Adjust as needed."""
        categorical_cols = self.df.select_dtypes(include=["object", "category"]).columns
        self.df = pd.get_dummies(self.df, columns=categorical_cols, drop_first=True)

    def normalize_numericals(self):
        """Normalize numerical columns. Adjust as needed."""
        numerical_cols = self.df.select_dtypes(include=["int64", "float64"]).columns
        scaler = StandardScaler()
        self.df[numerical_cols] = scaler.fit_transform(self.df[numerical_cols])

    def validate_columns(self):
        """Ensure that all columns are valid.

        This method should be called at the end of the preprocessing pipeline.
        """
        required_cols = CONST.ANALYSIS_COLUMNS
        missing_cols = set(required_cols) - set(self.df.columns)
        if missing_cols:
            raise ValueError(
                f"Missing columns during data preprocessing: {missing_cols}"
            )

    def preprocess(self):
        """Run all preprocessing steps."""
        # self.remove_missing_values()
        # self.encode_categoricals()
        # self.normalize_numericals()

    def validate(self):
        """Validate the results of the preprocessing pipeline."""
        # self.validate_columns()  # Do this at the end
        pass
