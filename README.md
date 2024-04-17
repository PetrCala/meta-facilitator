<div align="center">
    <h1>
        Meta Facilitator
    </h1>
</div>

Streamline data preprocessing for meta-analysis exploration

<!-- ### Table of Contents -->

# Prerequisites

To run the analysis, you must have several applications installed on your device. These include:

- Python: [install here](https://www.python.org/downloads/)
- R: [install here](https://cran.r-project.org)

To verify the installation was successful, run the following commands in your terminal:

```
python --version
R --version
```

All of these should print out the version of the relevant executable. If not, refer to the installation guides.

# How to run

1. Clone the repository using

```bash
git clone https://github.com/PetrCala/meta-facilitator.git
```

2. Navigate to the project root

```bash
cd meta-facilitator
```

3. Run the following commands to setup your local environment:

```bash
chmod +x ./scripts/setup.sh
./scripts/setup.sh
```

4. Choose an action to run out of the [Available Actions section](#available-actions). Run it using:

```bash
Rscript entrypoint.R <action> [--args]
```

For example, to run the Chris analysis, do

```bash
Rscript entrypoint.R analyse Chris
```

5. Find the results in ...

# Available actions

Here is a list of all the currently supported actions:

- **`analyse`**: Run a full analysis of a dataset.
  - _Args_:
    - Analysis name - e.g., `Chris`,...
  - _Example_:
    - `python main.py analyse Chris`
- **`r`**: Call an R script:
  - _Args_:
    - R action name - e.g., `add`, `subtract`,...
    - Arguments passed to the R action
  - _Example_:
    - `python main.py r add 1 2`

Here is a list of all currently available analyses is:

- `Chris`
