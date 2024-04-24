source("libs/read_data/index.R")
source("libs/clean_data/index.R")
source("analyses/utils.R")
source("analyses/steps/get_pcc.R")
source("METADATA.R")

chris_analyse <- function(...) {
    message("Running the chris analysis")
    analysis <- METADATA$analyses$chris
    analysis_name <- analysis$analysis_name

    # Clean the data
    df <- readAnalysisData(analysis_name = analysis_name)
    df <- cleanData(df = df, analysis_name = analysis_name)

    # Run analysis steps
    getPCC(df = df, analysis_name = analysis_name, ...)

    saveAnalysisResults(
        df = df,
        analysis_name = analysis_name,
        analysis_messages = c("hello", "world")
    )
}
