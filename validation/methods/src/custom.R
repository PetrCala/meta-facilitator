#' Using the base data frame, and a given offset, calculate the variance of the PCC
#'
#' @note During the validation, an offset of 1 and and offset of 2 will be automatically applied to this function
custom_pcc_variance <- function(df, offset) {
  stopifnot(is.numeric(offset)) # A safety check

  # START OF MODIFIABLE SECTION
  pcc_ <- df$effect
  numerator <- (1 - pcc_^2)^2

  denominator <- dof_or_sample_size(df, offset = offset) # From pcc.R
  variance <- numerator / denominator
  # END OF MODIFIABLE SECTION

  return(variance) # This must return a vector
}

custom_re <- function(df) {
  # START OF MODIFIABLE SECTION
  # effect <- df$effect
  # se <- df$effect
  # ...
  re_est <- 0
  re_se <- 1
  re_t_value <- re_est / re_se

  # END OF MODIFIABLE SECTION
  return(list(est = re_est, t_value = re_t_value))
}

custom_uwls <- function(df) {
  uwls_est <- 0
  uwls_se <- 1
  uwls_t_value <- uwls_est / uwls_se

  return(list(est = uwls_est, t_value = uwls_t_value))
}

custom_uwls3 <- function(df) {
  uwls3_est <- 0
  uwls3_se <- 1
  uwls3_t_value <- uwls3_est / uwls3_se

  return(list(est = uwls3_est, t_value = uwls3_t_value))
}

custom_hsma <- function(df) {
  hsma_est <- 0
  hsma_se <- 1
  hsma_t_value <- hsma_est / hsma_se

  return(list(est = hsma_est, t_value = hsma_t_value))
}

custom_fishers_z <- function(df) {
  fishers_z_est <- 0
  fishers_z_se <- 1
  fishers_z_t_value <- fishers_z_est / fishers_z_se

  return(list(est = fishers_z_est, t_value = fishers_z_t_value))
}