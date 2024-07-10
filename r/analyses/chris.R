box::use(
  dplyr[`%>%`],
  stats[model.frame], # For dplyr
  pcc_calc = calc / pcc,
  base / metadata[METADATA],
  libs / df_utils[get_number_of_studies],
  analyses / steps / get_pcc[get_pcc_data],
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
  study <- as.character(unique(df$study))

  # Random Effects - regressor is PCC SE, i.e. sqrt of PCC variance
  # re1 <- plm::plm(effect ~ sqrt(pcc_var_1), data = df, model = "random")
  # re2 <- plm::plm(effect ~ sqrt(pcc_var_2), data = df, model = "random")

  # UWLS
  uwls1 <- pcc_calc$uwls(df, se = sqrt(df[["pcc_var_1"]]))
  uwls2 <- pcc_calc$uwls(df, se = sqrt(df[["pcc_var_2"]]))

  # UWLS+3
  uwls3 <- pcc_calc$uwls3(df)

  # Hunter and Schmidt

  # Fisher's z

  # Summary statistics

  return(data.frame(
    study = study,
    uwls1_est = uwls1$est,
    uwls1_t_value = uwls1$t_value,
    uwls2_est = uwls2$est,
    uwls2_t_value = uwls2$t_value,
    uwls3_est = uwls3$est,
    uwls3_t_value = uwls3$t_value
  ))
}

#' @export
chris_analyse <- function(...) {
  logger::log_info("Running the chris analysis")
  analysis <- METADATA$analyses$chris
  analysis_name <- analysis$analysis_name

  # Clean the data
  logger::log_debug("Preprocessing and cleaning data...")
  df <- read_analysis_data(analysis_name = analysis_name)
  df <- clean_data(df = df, analysis_name = analysis_name)
  logger::log_info(paste("Rows after data cleaning:", nrow(df)))

  # Run analysis steps
  logger::log_debug("Calculating statistics...")
  # This subsets the analysis to pcc studies only
  n_studies <- get_number_of_studies(df = df)

  # Run the PCC analysis
  pcc_df <- get_pcc_data(df = data.table::copy(df), analysis_name = analysis_name, ...)
  pcc_list <- lapply(split(pcc_df, pcc_df$study), get_chris_meta_flavours)
  pcc_df_out <- do.call(rbind, pcc_list)

  logger::log_debug("Exporting results...")
  save_analysis_results(
    df = pcc_df_out,
    analysis_name = analysis_name,
    analysis_messages = c("hello", "world")
  )
}
