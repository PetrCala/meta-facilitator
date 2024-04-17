# process_data.R
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]


# Read the input data frame
df <- read.csv(input_file)

# Data preprocessing steps here

# Write the processed data frame back to a new file
write.csv(df, output_file, row.names = FALSE)
