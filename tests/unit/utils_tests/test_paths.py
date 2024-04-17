import pytest
from python.paths import PATHS
from python.const import CONST


class TestPaths:
    """Test paths module."""

    def test_project_root(self):
        """Test project root path."""
        assert CONST.PROJECT_NAME in PATHS.PROJECT_ROOT
