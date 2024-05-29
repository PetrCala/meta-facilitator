library("data.table")
library("rlang")
source("libs/utils.R")
source("libs/df_utils.R")
source("analyses/utils.R")

#' Calculate the PCC variance.
#'
#' @param pcc [vector] A vector of PCC values.
#' @param sample_size [vector] A vector of sample sizes.
#' @param dof [vector] A vector of degrees of freedom.
#' @param offset [int] An offset value to subtract from the degrees of freedom
#'  in case they are missing.
#' @return [vector] A vector of PCC variances.
getPCCVariance <- function(pcc, sample_size, dof, offset) {
    # Calculate the PCC variance.
    non_null_df <- !is.na(dof)

    numerator <- (1 - pcc^2)^2
    denominator <- sample_size - 7
    denominator[non_null_df] <- dof[non_null_df] - offset
    return(numerator / denominator)
}

#' Run the PCC analysis step. Used in the Chris analysis.
getPCC <- function(df, analysis_name = "", messages = c()) {
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
    messages <- c(messages, "Subsetting to PCC studies only")
    df <- copy(df[df$effect_type == pcc_identifier, ])
    n_of_studies_pcc <- getNumberOfStudies(df = df)
    messages <- c(messages, "Subsetting to PCC studies only.")
    # TODO log this

    # Calculate the PCC variance
    df$pcc_var_1 <- getPCCVariance(
        pcc = df$effect,
        sample_size = df$sample_size,
        dof = df$df,
        offset = 1
    )
    df$pcc_var_2 <- getPCCVariance(
        pcc = df$effect,
        sample_size = df$sample_size,
        dof = df$df,
        offset = 2
    )
    return(df)
}



# a. RE1 & RE2: Calculate random-effects twice (report its both the estimate and t-value for each) using the SEs for equation (1) and (2). I know that R has standard routines for this.  You should probably use the REML (restricted max likelihood) flavor of RE.
