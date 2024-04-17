from src.libs.r import run_r_script


def explore():
    """Explore the data."""
    run_r_script("add", 1, 3)


if __name__ == "__main__":
    explore()
