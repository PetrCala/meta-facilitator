from typing import NamedTuple
from python.types.extensions import AllowedDataExtension


class AllowedDataExtensions(NamedTuple):
    CSV: AllowedDataExtension = "csv"
    XLSX: AllowedDataExtension = "xlsx"
    JSON: AllowedDataExtension = "json"


ALLOWED_DATA_EXTENSIONS = AllowedDataExtensions()
