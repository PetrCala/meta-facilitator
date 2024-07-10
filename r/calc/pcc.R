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


#' Calculate UWLS+3
#' @export
uwls3 <- function(df) {
  t_ <- df$effect / df$se
  n_ <- df$df
  if (sum(is.na(n_)) > 0) { # Extra safety check
    rlang::abort("Missing degrees of freedom when calculating UWLS+3. Make sure to convert all missing DoF's to 0 first.")
  }
  pcc <- t_ / sqrt(t_^2 + n_ + 1) # Also marked as r_3
  # r <-
  return(1)
}
