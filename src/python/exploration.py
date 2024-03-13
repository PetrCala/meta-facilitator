import os
import pandas as pd
from src.const import CONST
from src.paths import PATHS
from src.cache import get_or_load_data


def main():
    data_path = os.path.join(PATHS.DATA_DIR, "chris_data.xlsx")
    # df = get_or_load_data(CONST.CACHE_KEYS.TEST_DATA, data_path)
    df = get_or_load_data(CONST.CACHE_KEYS.TEST_DATA, data_path)


if __name__ == "__main__":
    main()
