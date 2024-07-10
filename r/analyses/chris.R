box::use(
  dplyr[`%>%`],
  stats[model.frame], # For dplyr
  calc = calc / index,
  base / metadata[METADATA],
  libs / df_utils[get_number_of_studies],
  analyses / steps / get_pcc[get_pcc],
  analyses / utils[get_analysis_metadata, save_analysis_results],
  libs / clean_data / index[clean_data],
  libs / read_data / index[read_analysis_data],
)

#' Calculate the flavours (statistics) of a single analysis data and return these as a vector
#' Iterate with this function over a set of meta analyses to get the results
#'
#' @param df [data.frame] The single meta-analysis data frame
#' @return [vector] A vector of the flavour results
get_chris_meta_flavours <- function(df) {
  # Random Effects - regressor is PCC SE, i.e. sqrt of PCC variance
  re1 <- plm::plm(df$effect ~ sqrt(df$pcc_var_1), data = df, model = "random")
  re2 <- plm::plm(df$effect ~ sqrt(df$pcc_var_2), data = df, model = "random")

  # UWSL
  uwls1 <- 1

  return(data.frame(re1 = 1, re2 = 2))
}

chris_analyse <- function(...) {
  logger::log_info("Running the chris analysis")
  analysis <- METADATA$analyses$chris
  analysis_name <- analysis$analysis_name

  # Clean the data
  logger::log_info("Preprocessing and cleaning data...")
  df <- read_analysis_data(analysis_name = analysis_name)
  df <- clean_data(df = df, analysis_name = analysis_name)


  # Run analysis steps
  logger::log_info("Calculating statistics...")
  # This subsets the analysis to pcc studies only
  df <- get_pcc(df = df, analysis_name = analysis_name, ...)
  n_studies <- get_number_of_studies(df = df)

  # df_out <- df %>%
  #   dplyr::group_by(study) %>%
  #   dplyr::summarise(get_chris_meta_flavours(dplyr::group_data()))
  df_out <- data.frame(c())

  logger::log_info("Exporting results...")
  save_analysis_results(
    df = df_out,
    analysis_name = analysis_name,
    analysis_messages = c("hello", "world")
  )
}

box::export(chris_analyse)
