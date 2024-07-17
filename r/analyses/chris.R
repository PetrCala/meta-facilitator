box::use(
  dplyr[`%>%`],
  stats[model.frame], # For dplyr
  pcc_calc = calc / pcc,
  base / metadata[METADATA],
  libs / df_utils[get_number_of_studies],
  analyses / steps / get_pcc[get_pcc_data],
  analyses / utils[get_analysis_metadata, save_analysis_results],
  libs / clean_data / index[clean_data],
  libs / clean_data / fill[modify_missing_values],
  libs / read_data / index[read_analysis_data],
)

#' Calculate the flavours (statistics) of a single analysis data and return these as a vector
#' Iterate with this function over a set of meta analyses to get the results
#'
#' @param df [data.frame] The single meta-analysis data frame
#' @return [vector] A vector of the flavour results
get_chris_metaflavours <- function(df) {
  logger::log_debug("Calculating PCC statistics...")

  # Get the name of the meta-analysis
  meta <- unique(df$meta)
  stopifnot(length(meta) == 1) # Extra check

  results <- list(meta = as.character(meta))
  # Define the various methods to calculate the PCC
  methods <- list(
    re1 = list(est = NA, t_value = NA),
    re2 = list(est = NA, t_value = NA),
    uwls1 = pcc_calc$uwls(df, se = sqrt(df[["pcc_var_1"]])),
    uwls2 = pcc_calc$uwls(df, se = sqrt(df[["pcc_var_2"]])),
    uwls3 = pcc_calc$uwls3(df),
    hsma = pcc_calc$hsma(df),
    # fishers_z = pcc_calc$fishers_z(df)
    fishers_z = list(est = NA, t_value = NA) # TODO
  )

  for (method in names(methods)) {
    res <- methods[[method]]
    results[[paste0(method, "_est")]] <- res$est
    results[[paste0(method, "_t_value")]] <- res$t_value
  }

  sum_stats <- pcc_calc$pcc_sum_stats(df, log_results = FALSE)

  results <- c(results, sum_stats)
  return(as.data.frame(results))
}

#' @export
chris_analyse <- function(...) {
  logger::log_info("Running the chris analysis")
  analysis <- METADATA$analyses$chris
  analysis_name <- analysis$analysis_name

  # Clean the data
  df <- read_analysis_data(analysis_name = analysis_name)
  df <- clean_data(df = df, analysis_name = analysis_name)
  df <- modify_missing_values(df = df, target_col = "study", columns = c("author1", "year"), missing_value_prefix = "Missing study")

  # Run the PCC analysis - use pcc studies only
  pcc_df <- get_pcc_data(df = data.table::copy(df), analysis_name = analysis_name, ...)

  pcc_list <- lapply(split(pcc_df, pcc_df$meta), get_chris_metaflavours)
  pcc_df_out <- do.call(rbind, pcc_list)
  pcc_studies <- get_number_of_studies(df = pcc_df)
  logger::log_info(paste("Number of PCC studies:", pcc_studies))

  # Add a row for the full data frame
  pcc_df$meta <- "All meta-analyses" # The pcc_df object can be reused here
  pcc_full_df <- get_chris_metaflavours(pcc_df)
  pcc_df_out <- do.call(rbind, list(pcc_df_out, pcc_full_df))

  save_analysis_results(
    df = pcc_df_out,
    analysis_name = analysis_name
  )
}
