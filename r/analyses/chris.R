source("libs/read_data/index.R")
source("analyses/utils.R")
source("METADATA.R")

chris_analyse <- function(...) {
    message("Running the chris analysis")
    analysis <- METADATA$analyses$chris
    analysis_name <- analysis$analysis_name
    df <- readAnalysisData(analysis_name = analysis_name)
    print(head(df))
}
