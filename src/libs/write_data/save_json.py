import json


def save_dict_as_json(obj: dict, path: str) -> None:
    """Save a dictionary as a JSON file. Provide the full path to the file."""
    with open(path, "w") as file:
        json.dump(obj, file)
