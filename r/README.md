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
