class DataPipeline:
    """
    A generic class for data pipeline processing.

    Example usage:
    >>> # Retrieve static list of columns
    >>> columns = DataPipeline.get_columns()
    >>> print(columns)
    >>>
    >>> # Get description for a specific column
    >>> description = DataPipeline.get_column_description("mean")
    >>> print(f"Description for 'mean': {description}")
    >>>
    >>> # Get all descriptions
    >>> all_descriptions = DataPipeline.get_all_descriptions()
    >>> print(all_descriptions)
    """

    # Static array of columns - should be overridden by subclass
    columns = []

    # Static descriptions for each column - should be overridden by subclass
    descriptions = {}

    @classmethod
    def get_columns(cls):
        """Return the static list of column names."""
        if not cls.columns:
            raise NotImplementedError("Column names must be defined in the subclass.")
        return cls.columns

    @classmethod
    def get_column_description(cls, column_name):
        """Return the description of a given column name."""
        if not cls.descriptions:
            raise NotImplementedError(
                "Column descriptions must be defined in the subclass."
            )
        return cls.descriptions.get(column_name, "No description available.")

    @classmethod
    def get_all_descriptions(cls):
        """Return a dictionary of all column names and their descriptions."""
        if not cls.descriptions:
            raise NotImplementedError(
                "Column descriptions must be defined in the subclass."
            )
        return cls.descriptions
