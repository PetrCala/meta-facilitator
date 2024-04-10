import sys
from src.actions import run_analysis

MAIN_ACTIONS = {
    "run-analysis": run_analysis,
}


def main(args):
    if not args:
        raise ValueError(
            "Please choose an action. Usage: python main.py <action> [--additional-args]"
        )
    action = args[0]
    if not action in MAIN_ACTIONS:
        raise ValueError(
            f"Action {action} not found. Must be one of {', '.join(MAIN_ACTIONS.keys())}"
        )
    MAIN_ACTIONS[action](*args[1:])  # Call the action with the renamining args


if __name__ == "__main__":
    args = sys.argv[1:]
    main(args)
