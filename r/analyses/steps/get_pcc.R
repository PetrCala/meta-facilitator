box::use(
  calc = calc / index,
  libs / utils[is_empty],
  libs / df_utils[get_number_of_studies],
  analyses / utils[get_analysis_metadata]
)

#' Run the PCC analysis step. Used in the Chris analysis.
get_pcc <- function(df, analysis_name = "", ...) {
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
  df$pcc_var_1 <- calc$pcc_variance(
    pcc = df$effect,
    sample_size = df$sample_size,
    dof = df$df,
    offset = 1
  )
  df$pcc_var_2 <- calc$pcc_variance(
    pcc = df$effect,
    sample_size = df$sample_size,
    dof = df$df,
    offset = 2
  )
  return(df)
}



# a. RE1 & RE2: Calculate random-effects twice (report its both the estimate and t-value for each) using the SEs for equation (1) and (2). I know that R has standard routines for this.  You should probably use the REML (restricted max likelihood) flavor of RE.

box::export(
  get_pcc
)
