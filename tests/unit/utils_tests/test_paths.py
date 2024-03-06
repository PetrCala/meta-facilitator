import pytest
from src.paths import PATHS
from src.const import CONST


class TestPaths:
    """Test paths module."""

    def test_project_root(self):
        """Test project root path."""
        breakpoint()
        assert CONST.PROJECT_NAME in PATHS.PROJECT_ROOT
