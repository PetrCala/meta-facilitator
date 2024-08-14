box::use(
  dplyr[`%>%`],
  stats[model.frame], # For dplyr
  pcc_calc = calc / pcc,
  base / options[get_option],
  analyses / steps / get_pcc[get_pcc_data],
  analyses / utils[get_analysis_options, save_analysis_results, log_dataframe_info],
  libs / string[find_string_using_substring],
  libs / clean_data / index[clean_data],
  libs / read_data / index[read_analysis_data],
  libs / cache / index[run_cached_function],
)

#' Calculate the flavours (statistics) of a single analysis data and return these as a vector
#' Iterate with this function over a set of meta analyses to get the results
#'
#' @param df [data.frame] The single meta-analysis data frame
#' @param idx [vector] A numeric vector to index the results
#' @return [vector] A vector of the flavour results
get_chris_metaflavours <- function(df) {
  # Get the name of the meta-analysis
  meta <- unique(df$meta)
  stopifnot(length(meta) == 1) # Extra check

  logger::log_debug(paste("Calculating PCC statistics for", meta))

  # Select the calculation methods
  re_method <- get_option("methods.re_method")
  re_method_fishers_z <- get_option("methods.re_method_fishers_z")

  # Get the standard errors - silence NaNs
  suppressWarnings(se_ <- sqrt(df[["pcc_var"]]))

  results <- list(meta = as.character(meta))
  # Define the various methods to calculate the PCC
  methods <- list(
    re = pcc_calc$re(df, method = re_method),
    uwls = pcc_calc$uwls(df),
    uwls3 = pcc_calc$uwls3(df),
    hsma = pcc_calc$hsma(df),
    fishers_z = pcc_calc$fishers_z(df, method = re_method_fishers_z)
  )

  for (method in names(methods)) {
    res <- methods[[method]]
    results[[paste0(method, "_est")]] <- res$est
    results[[paste0(method, "_t_value")]] <- res$t_value
  }

  sum_stats <- pcc_calc$pcc_sum_stats(df, log_results = FALSE)

  results <- c(results, sum_stats)

  # Some elements might be numeric(0) here - replace with NA to allow for data frame conversion
  results <- lapply(results, function(x) if (length(x) == 0) NA else x)

  return(as.data.frame(results))
}

#' @export
chris_analyse <- function(...) {
  logger::log_info("Running the chris analysis")
  analysis <- get_option("analyses.chris")
  analysis_name <- analysis$analysis_name

  # Clean the data
  df <- read_analysis_data(analysis_name = analysis_name)
  logger::log_info("Rows in the raw data frame: ", nrow(df))

  df <- run_cached_function(
    f = clean_data,
    df = df,
    analysis_name = analysis_name,
    clean_names = get_option("general.clean_names"),
    recalculate_t_value = get_option("general.recalculate_t_value")
  )

  meta_substring <- get_option("general.use_single_meta_analysis")
  if (is.character(meta_substring)) {
    meta_to_use <- find_string_using_substring(unique(df$meta), meta_substring)
    logger::log_info("Subsetting to data of only ", meta_to_use)
    df <- df[df$meta == meta_to_use, ]
  }

  # Run the PCC analysis - use pcc studies only
  pcc_df <- run_cached_function(
    f = get_pcc_data,
    df = data.table::copy(df),
    analysis_name = analysis_name,
    fill_dof = get_option("general.fill_dof"),
    ...
  )
  log_dataframe_info(df = pcc_df, colnames_to_analyse = c("study", "meta"))

  get_flavours <- function() lapply(split(pcc_df, pcc_df$meta), get_chris_metaflavours)
  # pcc_list <- run_cached_function(f=get_flavours) # Cached
  pcc_list <- get_flavours() # Non-cached
  pcc_df_out <- do.call(rbind, pcc_list)

  # Add a row for the full data frame
  pcc_df$meta <- "All meta-analyses" # The pcc_df object can be reused here
  pcc_full_df <- get_chris_metaflavours(pcc_df)
  pcc_df_out <- rbind(pcc_df_out, pcc_full_df)

  # Add an index
  if (get_option("analyses.chris.unique.add_idx_column")) {
    idx <- seq_len(nrow(pcc_df_out))
    pcc_df_out <- cbind(idx, pcc_df_out)
    colnames(pcc_df_out)[1] <- "idx"
  }

  save_analysis_results(
    df = pcc_df_out,
    analysis_name = analysis_name
  )
}
