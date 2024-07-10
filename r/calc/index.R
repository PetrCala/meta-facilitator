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
  # Calculate the PCC variance.
  non_null_df <- !is.na(dof)

  numerator <- (1 - pcc^2)^2
  denominator <- sample_size - 7
  denominator[non_null_df] <- dof[non_null_df] - offset
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

#' Calculate UWLS
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
