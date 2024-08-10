box::use(
  base / options[OPTIONS],
  pcc_calc = calc / pcc,
  libs / utils[is_empty, to_perc],
  analyses / utils[get_analysis_options],
  libs / clean_data / fill[fill_dof_using_pcc],
)

#' Run the PCC analysis step. Used in the Chris analysis.
#' @export
get_pcc_data <- function(df, analysis_name = "", fill_dof = TRUE, ...) {
  analysis_options <- get_analysis_options(analysis_name = analysis_name)

  # Subset to PCC studies only
  pcc_identifier <- analysis_options$unique$pcc_identifier
  if (is_empty(pcc_identifier)) {
    rlang::abort(
      paste0(
        "Unknown PCC identified for analysis ",
        analysis_name,
        ". Make sure to specify 'analyses$<name>$unique$pcc_identifier' in the options."
      ),
      class = "unknown_pcc_identifier"
    )
  }
  nrow_full <- nrow(df)
  logger::log_info("Subsetting to PCC studies only...")
  pcc_rows <- df$effect_type == pcc_identifier
  pcc_rows[is.na(pcc_rows)] <- FALSE # NA -> FALSE, just R things
  df <- df[pcc_rows, ]
  nrow_pcc <- nrow(df)
  logger::log_info("Loaded ", nrow_pcc, " PCC studies out of ", nrow_full, " rows. (", to_perc(nrow_pcc / nrow_full), " of the clean dataset)")

  if (fill_dof) { # Interpolate missing degrees of freedom
    fill_conditions <- OPTIONS$general$fill_dof_conditions
    df <- fill_dof_using_pcc(
      df = df,
      replace_existing = fill_conditions$replace_existing,
      drop_missing = fill_conditions$drop_missing,
      drop_negative = fill_conditions$drop_negative,
      drop_zero = fill_conditions$drop_zero
    )
  }

  # Calculate the PCC variance
  df$pcc_var <- pcc_calc$pcc_variance(df = df, offset = 0)

  # Drop observations for which variance could not be calculated or is infinite
  n_rows_before <- nrow(df)
  drop_pcc_rows <- function(df_, condition_vector, reason) {
    if (any(condition_vector)) {
      logger::log_warn(paste("Identified", sum(condition_vector), "rows for which PCC variance", reason, "Dropping these rows..."))
      return(df_[!condition_vector, ])
    }
    return(df_)
  }

  na_rows <- is.na(df$pcc_var)
  df <- drop_pcc_rows(df, na_rows, "could not be calculated.")

  inf_rows <- is.infinite(df$pcc_var)
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
