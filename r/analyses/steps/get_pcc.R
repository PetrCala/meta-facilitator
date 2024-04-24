library("rlang")
source("libs/utils.R")
source("libs/df_utils.R")
source("analyses/utils.R")

#' Run the PCC analysis step. Used in the Chris analysis.
getPCC <- function(df, analysis_name) {
    analysis_metadata <- getAnalysisMetadata(analysis_name = analysis_name)

    n_studies_full <- getNumberOfStudies(df = df)

    # Subset to PCC studies only
    pcc_identifier <- analysis_metadata$unique$pcc_identifier
    if (isEmpty(pcc_identifier)) {
        abort(
            paste0(
                "Unknown PCC identified for analysis ",
                analysis_name,
                ". Make sure to specify 'analyses$<name>$unique$pcc_identifier' in the metadata."
            ),
            class = "unknown_pcc_identifier"
        )
    }
    df <- df[df$effect_type == pcc_identifier, ]
    n_of_studies_pcc <- getNumberOfStudies(df = df)
    return(NA)
}


# df_out["pcc_var_1"] = get_pcc_var(df_calc, offset=1)
# df_out["pcc_var_2"] = get_pcc_var(df_calc, offset=2)

# a. RE1 & RE2: Calculate random-effects twice (report its both the estimate and t-value for each) using the SEs for equation (1) and (2). I know that R has standard routines for this.  You should probably use the REML (restricted max likelihood) flavor of RE.
