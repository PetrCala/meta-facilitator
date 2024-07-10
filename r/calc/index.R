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
  return(numerator / denominator)
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
