box::use(
  pcc_calc = calc / pcc,
  libs / utils[is_empty],
  libs / df_utils[get_number_of_studies],
  analyses / utils[get_analysis_metadata]
)

#' Run the PCC analysis step. Used in the Chris analysis.
#' @export
get_pcc_data <- function(df, analysis_name = "", ...) {
  analysis_metadata <- get_analysis_metadata(analysis_name = analysis_name)

  # n_studies_full <- get_number_of_studies(df = df)

  # Subset to PCC studies only
  pcc_identifier <- analysis_metadata$unique$pcc_identifier
  if (is_empty(pcc_identifier)) {
    rlang::abort(
      paste0(
        "Unknown PCC identified for analysis ",
        analysis_name,
        ". Make sure to specify 'analyses$<name>$unique$pcc_identifier' in the metadata."
      ),
      class = "unknown_pcc_identifier"
    )
  }
  logger::log_info("Subsetting to PCC studies only")
  df <- data.table::copy(df[df$effect_type == pcc_identifier, ])
  # n_of_studies_pcc <- get_number_of_studies(df = df)

  # Calculate the PCC variance
  df$pcc_var_1 <- pcc_calc$pcc_variance(
    df = df,
    offset = 1
  )
  df$pcc_var_2 <- pcc_calc$pcc_variance(
    df = df,
    offset = 2
  )

  # Replace missing DF with 0
  # Do this after calculating the variance (the calculation needs NAs for identification)
  replace_missing_dfs_with_0 <- FALSE
  if (replace_missing_dfs_with_0) {
    missing_dfs <- is.na(df$df)
    missing_dfs_count <- sum(missing_dfs)
    if (missing_dfs_count > 0) {
      missing_dfs_perc <- missing_dfs_count / nrow(df) * 100
      logger::log_warn(paste0("Identified ", missing_dfs_count, " missing degrees of freedom in the source data (", missing_dfs_perc, "%). Converting these to 0..."))
      df$df[missing_dfs] <- 0
    }
  }

  # Drop observations for which variance could not be calculated or is infinite
  n_rows_before <- nrow(df)
  drop_pcc_rows <- function(df_, condition_vector, reason) {
    logger::log_warn(paste("Identified", sum(condition_vector), "rows for which PCC variance", reason, "Dropping these rows..."))
    return(df_[!condition_vector, ])
  }

  na_rows <- is.na(df$pcc_var_1) | is.na(df$pcc_var_2)
  df <- drop_pcc_rows(df, na_rows, "could not be calculated.")

  inf_rows <- is.infinite((df$pcc_var_1)) | is.infinite(df$pcc_var_2)
  df <- drop_pcc_rows(df, inf_rows, "was infinite.")

  # Check that the rows were dropped correctly
  n_rows_after <- nrow(df)
  should_have_dropped <- sum(na_rows) + sum(inf_rows)
  if (n_rows_after + should_have_dropped != n_rows_before) {
    rlang::abort(paste0("Something went wrong when dropping missing PCC variance rows.", "\nNrows before: ", n_rows_before, "\nNrows after: ", n_rows_after, "\nShould have dropped: ", should_have_dropped)
    )
  }

  return(df)
}



# a. RE1 & RE2: Calculate random-effects twice (report its both the estimate and t-value for each) using the SEs for equation (1) and (2). I know that R has standard routines for this.  You should probably use the REML (restricted max likelihood) flavor of RE.
