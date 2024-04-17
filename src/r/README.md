# Handling script args

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
