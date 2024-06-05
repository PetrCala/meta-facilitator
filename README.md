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

## Handling script args

Arguments can be passed to R scripts quite elegantly like so:

```R
library("optparse")

# Option parser setup
option_list <- list(
    make_option(c("-i", "--input"), type = "character", default = "input_data.csv", help = "Input file path"),
    make_option(c("-o", "--output"), type = "character", default = "output_results.csv", help = "Output file path"),
    make_option("--max_iter", type = "integer", default = 1000, help = "Maximum number of iterations"),
    make_option("--threshold", type = "numeric", default = 0.01, help = "Convergence threshold"),
    make_option("--method", type = "character", default = "BFGS", help = "Optimization method")
)

# Parse options
opt <- parse_args(OptionParser(option_list = option_list))

# Print options to verify (you would typically use these options in your analysis)
print(paste("Input:", opt$input))
print(paste("Output:", opt$output))
print(paste("Max iterations:", opt$max_iter))
print(paste("Threshold:", opt$threshold))
print(paste("Method:", opt$method))

# Here you would add your data processing and analysis code
# For example:
cat("Analysis done with method", opt$method, "with max iterations", opt$max_iter, "\n")

# [1] "Input: input_data.csv"
# [1] "Output: output_results.csv"
# [1] "Max iterations: 1000"
# [1] "Threshold: 0.01"
# [1] "Method: BFGS"
# Analysis done with method BFGS with max iterations 1000

```

## Importing modules

For any imports within the project, we use [the **box** package](https://klmr.me/box/articles/box.html). This emulates Python-like module imports, allowing us to maintain a complex, yet transparent structure of the project. Here, each script behaves as a standalone module, and only the necessary functions are imported from it. This keeps the workspace clean, as it does the source of all functions used across the project. To read more on how to use box, see [the official documentation](https://klmr.me/box/articles/box.html).

## Validating Conditions

In this project, we use the `validate` function to ensure that certain conditions hold true before proceeding with further computations or operations. The `validate` function helps in maintaining the integrity of the program by aborting execution if any condition is not met. This function is inspired by modern error handling practices in R and leverages the `rlang` package for structured error messages.

### How to Use the `validate` Function

The `validate` function checks whether each argument passed to it is either a single logical value (TRUE or FALSE). It validates each condition and aborts with an appropriate error message if any condition does not hold.

### Examples

#### Valid Conditions

```r
validate(TRUE, 1 == 1, is.function(print))
```

#### Invalid Conditions

The following examples will abort with an error message:

```r
validate(FALSE)
validate(TRUE, 1 == 2, FALSE)
validate("not a condition")
```

## Using `lintr` for Code Quality

This project uses the `lintr` package to ensure code quality and adherence to style guidelines. Below are the steps to set up and use `lintr` in this project.

### Installation

First, install the `lintr` package:

```r
install.packages("lintr")
```

### Usage

To lint all R files in your project directory, run the following command:

```r
lintr::lint_dir("path/to/your/project")
```

To lint a specific file, run:

```r
lintr::lint("path/to/your/file.R")
```

### Automate Linting (Optional)

You can automate linting using Git pre-commit hooks with the `precommit` package. First, install `precommit`:

```r
install.packages("precommit")
precommit::use_precommit()
```

Edit the `.pre-commit-config.yaml` file to include `lintr`:

```yaml
- repo: https://github.com/jimhester/lintr
  rev: v3.0.0 # Replace with the latest version
  hooks:
    - id: lintr
```

This setup will ensure that your R files are linted before every commit, helping you maintain consistent code quality.

### Additional Resources

- [lintr GitHub Repository](https://github.com/jimhester/lintr)
- [lintr Documentation](https://cran.r-project.org/web/packages/lintr/lintr.pdf)
- [box Package Documentation](https://cran.r-project.org/web/packages/box/box.pdf)
