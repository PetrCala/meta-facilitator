box::use(
  base / metadata[METADATA],
  libs / df_utils[get_number_of_studies],
  analyses / steps / get_pcc[get_pcc],
  analyses / utils[get_analysis_metadata, save_analysis_results],
  libs / clean_data / index[clean_data],
  libs / read_data / index[read_analysis_data],
)

#' Given the data of a
get_chris_meta_flavours <- function(df) {

}

chris_analyse <- function(...) {
  logger::log_info("Running the chris analysis")
  analysis <- METADATA$analyses$chris
  analysis_name <- analysis$analysis_name

  msg <- c() # A vector of messages to log at the end

  # Clean the data
  logger::log_info("Preprocessing and cleaning data...")
  df <- read_analysis_data(analysis_name = analysis_name)
  df <- clean_data(df = df, analysis_name = analysis_name)


  # Run analysis steps
  logger::log_info("Calculating statistics...")
  # This subsets the analysis to pcc studies only
  df <- get_pcc(df = df, analysis_name = analysis_name, messages = msg, ...)
  n_studies <- get_number_of_studies(df = df)

  # analyseSingleChrisStudy <- function(single_study_data) {

  #         out <- c(1)
  #         return(out)
  # }

  # df_out <- apply(df, 1, analyseSingleChrisStudy)
  df_out <- c("temp")

  # results <- data.frame(matrix(ncol=0, nrow=nrow(pcc_df)))

  logger::log_info("Exporting results...")
  save_analysis_results(
    df = df_out,
    analysis_name = analysis_name,
    analysis_messages = c("hello", "world")
  )
}

box::export(chris_analyse)
