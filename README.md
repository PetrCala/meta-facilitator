<div align="center">
    <h1>
        Meta Facilitator
    </h1>
</div>

Streamline data preprocessing for meta-analysis exploration

### Table of Contents

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

1. Navigate to the project root

```bash
cd meta-facilitator
```

2. Run the following commands to setup your local environment:

```bash
chmod +x ./scripts/setup.sh
./scripts/setup.sh
```

3. Select an analysis you want to run. The list of currently available analyses is:

- `Chris`

4. In a terminal window, execute the command

```bash
python main.py run-analysis <analysis-name>
```

5. Find the results in ...
