#' Calculate degrees of freedom using a t-value and a PCC
#'
#' @note The t_value and PCC can be provided either as a single numeric value, or as vectors of the same length.
#'
#' @param t_value [numeric] The t-value(s) to use for the calculation.
#' @param pcc [numeric] The partial correlation coefficient(s) to use for the calculation.
#' @return [numeric] The calculated degrees of freedom.
calculate_dof <- function(t_value, pcc) {
  if (length(t_value) != length(pcc)) {
    stop("The length of 't_value' and 'pcc' must be the same.")
  }
  # Q: Is it okay to drop all PCCs outside of the range (-1, 1)?
  lhs <- t_value ^ 2
  rhs <- (1 / (pcc ^ 2)) - 1
  return(lhs * rhs)
}
