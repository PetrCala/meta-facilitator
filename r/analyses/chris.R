source("libs/read_data/index.R")
source("libs/clean_data/index.R")
source("libs/df_utils.R")
source("analyses/utils.R")
source("analyses/steps/get_pcc.R")
source("METADATA.R")

#' Given the data of a 
get_chris_meta_flavours <- function(df) {

}

chrisAnalyse <- function(...) {
    message("Running the chris analysis")
    analysis <- METADATA$analyses$chris
    analysis_name <- analysis$analysis_name

    msg <- c() # A vector of messages to log at the end

    # Clean the data
    message("Preprocessing and cleaning data...")
    df <- readAnalysisData(analysis_name = analysis_name)
    df <- cleanData(df = df, analysis_name = analysis_name)


    # Run analysis steps
    message("Calculating statistics...")
    # This subsets the analysis to pcc studies only
    df <- getPCC(df = df, analysis_name = analysis_name, messages=msg, ...)
    n_studies <- getNumberOfStudies(df = df)

    analyseSingleChrisStudy <- function(single_study_data) {

            out <- c(1)
            return(out)
    }

    # df_out <- apply(df, 1, analyseSingleChrisStudy)
    df_out <- c("temp")

    results <- data.frame(matrix(ncol=0, nrow=nrow(pcc_df)))

    message("Exporting results...")
    saveAnalysisResults(
        df = df_out,
        analysis_name = analysis_name,
        analysis_messages = c("hello", "world")
    )
}
