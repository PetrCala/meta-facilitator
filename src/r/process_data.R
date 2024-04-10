# process_data.R
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

# Read the data frame
df <- read.csv(input_file)

# Data preprocessing steps here
# For example, just a placeholder operation
df$processed <- df$someColumn * 2

# Write the processed data frame back to a new file
write.csv(df, output_file, row.names = FALSE)