#' Calculate the PCC variance.
#'
#' @param pcc [vector] A vector of PCC values.
#' @param sample_size [vector] A vector of sample sizes.
#' @param dof [vector] A vector of degrees of freedom.
#' @param offset [int] An offset value to subtract from the degrees of freedom
#'  in case they are missing.
#' @return [vector] A vector of PCC variances.
#' @export
pcc_variance <- function(pcc, sample_size, dof, offset) {
  numerator <- (1 - pcc^2)^2

  # When DoF available, use DoF - offset vs. when missing, use n - 7
  denominator <- rep(NA, length(numerator))
  denominator[!is.na(dof)] <- denominator[!is.na(dof)] - offset
  denominator[is.na(dof)] <- sample_size - 7

  variance <- numerator / denominator
  return(variance)
}

#' Calculate random errors
#'
#' @param x [vector] A vector of regressand values
#' @param y [vector] A vector of regressor values
#' @return [vector] A vector of results.
#' @export
re <- function(x, y) {
  return(plm::plm(x ~ y, model = "random"))
}

#' Extract the DoF vector from a data frame. Where the DoF's are missing, use sample size minus 7.
#'
#' @param df [data.frame] The data frame to extract the information from
#' @return [vector] A vector of either DoF's, or adjusted sample sizes.
df_or_sample_size <- function(df) {
  expected_cols <- c("df", "sample_size")
  if (!all(expected_cols %in% colnames(df))) {
    rlang::abort(paste("Invalid column names:", paste(colnames(df), collapse = ", ")), "Expected to contain:", paste(expected_cols, collapse = ", "))
  }
  df_ <- df$df
  # Replace DF with 'sample size - 7' when missing
  df_[is.na(df_)] <- df$sample_size[is.na(df_)] - 7
  return(df_)
}

#' Calculate UWLS
#'
#' @note Here, the statistics upon which the UWLS is calculated are more variable, thus flexibility is provided when defining the input through the 'effect' and 'se' arguments. To see how this can be leveraged, refer, for example, to the 'uwls3' function, or the 'get_chris_meta_flavours' function.
#'
#' @param df [data.frame] The data frame on which to run the calculation
#' @param effect [vector] The vector of effects. If not provided, defaults to df$effect.
#' @param se [vector] The vector of SEs. If not provided, defaults to df$se.
#' @return [list] A list with properties "est", "t_value".
#' @export
uwls <- function(df, effect = NULL, se = NULL) {
  if (is.null(effect)) {
    effect <- df$effect
  }
  if (is.null(se)) {
    se <- df$se
  }
  df$t <- effect / se
  df$precision <- 1 / se
  uwls <- stats::lm(t ~ precision - 1, data = df)
  summary_uwls <- summary(uwls)
  est <- summary_uwls$coefficients[1, "Estimate"]
  t_value <- summary_uwls$coefficients[1, "t value"]
  return(list(est = est, t_value = t_value))
}


#' Calculate UWLS+3
#'
#' @param df [data.frame] The data frame to calculate the UWLS+3 with
#' @return [list] A list with properties "est", "t_value".
#' @export
uwls3 <- function(df) {
  t_ <- df$effect / df$se # Q: Here, the effect is PCC - ok?
  df_ <- df_or_sample_size(df)

  pcc_ <- t_ / sqrt(t_^2 + df_ + 1) # r_3 Q: +1?
  pcc_var_ <- (1 - pcc_^2) / (df_ - 4) # S_3^2 Q: -4?
  se_ <- sqrt(pcc_var_) # SEr_3

  uwls <- uwls(df, effect = pcc_var_, se = se_)

  return(uwls)
}

#' Calculate the Hunter-Schmidt estimate
#'
#' @param df [data.frame] The data frame to calculate the UWLS+3 with
#' @return [list] A list with properties "est", "t_value".
#' @export
hsma <- function(df) {
  df_ <- df_or_sample_size(df)
  r_avg <- sum(df_ * df$effect) / sum(df_)
  sd_sq <- sum(df_ * ((df$effect - r_avg)^2)) / sum(df_) # SD_r^2
  se_r = sqrt(sd_sq) / sqrt(nrow(df)) # SE_r
  t_value <- r_avg / se_r
  return(list(est = se_r, t_value = t_value))
}

#' Calculate Fisher's z
fishers_z <- function(df) {

  return(list(est = NA, t_value = NA))

}
