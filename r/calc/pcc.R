box::use(
  stats[model.frame],
  libs / validation[validate_columns, validate, assert],
  base / metadata[METADATA],
)


#' Calculate the PCC variance.
#'
#' @param df [data.frame] The data frame upon which to calculate the PCC vairance. Should include the columns 'effect', 'sample_size', 'dof'
#' @param offset [int] An offset value to subtract from the degrees of freedom
#'  in case they are missing.
#' @return [vector] A vector of PCC variances.
#' @export
pcc_variance <- function(df, offset) {
  validate_columns(df, c("dof", "sample_size", "effect"))
  validate(sum(is.na(df$dof)) == 0)
  # validate(sum(is.na(df$dof)) == 0, "Missing DoF values in the PCC data frame")
  pcc_ <- df$effect

  numerator <- (1 - pcc_^2)^2
  denominator <- df$dof - offset

  variance <- numerator / denominator
  return(variance)
}

#' Calculate random effects
#'
#' @param df [data.frame] The data frame to calculate the RE with
#' @param effect [vector] The vector of effects. If not provided, defaults to df$effect.
#' @param se [vector] The vector of SEs. If not provided, defaults to df$se.
#' @param method [character] The method to use for the RE calculation. Defaults to "DL". Other common options include "ML" and "REML".
#' @export
re <- function(df, effect = NULL, se = NULL, method = "DL") {
  if (is.null(effect)) effect <- df$effect
  if (is.null(se)) se <- df$se
  validate(length(effect) == nrow(df), length(se) == nrow(df))

  result <- tryCatch({
    meta <- unique(df$meta)
    if (length(meta) != 1) {
      message("Could not calculate RE for multiple meta-analyses")
      return(list(est = NA, t_value = NA))
    }

    re_data_ <- data.frame(yi = effect, sei = se, study = df$study)

    suppressWarnings( # Sometimes the variances are large
      re_ <- metafor::rma(yi = yi, sei = sei, data = re_data_, method = method)
    )
    re_est <- re_$beta[1]
    re_se <- re_$se[1]

    re_t_value <- re_est / re_se
    return(list(est = re_est, t_value = re_t_value))
  },
  error = function(e) {
    logger::log_debug(paste("Could not fit the RE model for meta-analysis", meta, ": ", e))
    return(list(est = NA, t_value = NA))
  })

  return(result)
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
  if (is.null(effect))  effect <- df$effect
  if (is.null(se)) se <- df$se
  validate(length(effect) == nrow(df), length(se) == nrow(df))

  meta <- unique(df$meta)
  validate(length(meta) == 1)

  df$t <- effect / se
  df$precision <- 1 / se

  result <- tryCatch({
    uwls <- stats::lm(t ~ precision - 1, data = df)
    summary_uwls <- summary(uwls)
    est <- summary_uwls$coefficients[1, "Estimate"]
    t_value <- summary_uwls$coefficients[1, "t value"]
    return(list(est = est, t_value = t_value))
  },
  error = function(e) {
    logger::log_debug(paste("Could not fit the UWLS model for meta-analysis", meta, ": ", e))
    return(list(est = NA, t_value = NA))
  })

  return(result)
}


#' Calculate UWLS+3
#'
#' @param df [data.frame] The data frame to calculate the UWLS+3 with
#' @return [list] A list with properties "est", "t_value".
#' @export
uwls3 <- function(df) {
  t_ <- df$effect / df$se
  dof_ <- df$dof # Q: here, use sample size or DoF?

  pcc3 <- t_ / sqrt(t_^2 + dof_ + 3) # dof_ + 3 ~~ sample_size - 7 + 3

  # Method 1 - Q: Use this method, or the Stata approach?
  pcc_var3 <- (1 - pcc3^2) / (dof_ + 3) # dof_ + 3 ~~ sample_size - 7 + 3
  se3 <- sqrt(pcc_var3)

  # Method 2 - in line with Stata
  # se3 <- df$se

  # Drop observations where either the PCC3 or SE3 are missing
  uwls3_data <- data.frame(effect = pcc3, se = se3, meta = df$meta, study = df$study)
  uwls3_data <- uwls3_data[!is.na(pcc3) & !is.na(se3), ] # Drop NA rows

  if (nrow(uwls3_data) == 0) {
    logger::log_debug(paste("No data to calculate UWLS+3 z for meta-analysis", meta))
    return(list(est = NA, t_value = NA))
  }

  uwls_ <- uwls(df)
  return(uwls_)
}

#' Calculate the Hunter-Schmidt estimate
#'
#' @param df [data.frame] The data frame to calculate the UWLS+3 with
#' @return [list] A list with properties "est", "t_value".
#' @export
hsma <- function(df) {
  meta <- unique(df$meta)
  assert(sum(is.na(df$effect)) == 0, paste("Missing effect values in the PCC data frame for meta-analysis", meta))

  missing_sample_sizes <- sum(is.na(df$sample_size))
  if (missing_sample_sizes > 0) {
    logger::log_debug(paste("Dropping", missing_sample_sizes, "missing sample sizes for meta-analysis", meta))
    df <- df[!is.na(df$sample_size), ]
  }

  if (nrow(df) == 0) {
    logger::log_debug(paste("No data to calculate HSMA for meta-analysis", meta))
    return(list(est = NA, t_value = NA))
  }

  n_ <- df$sample_size
  effect <- df$effect
  r_avg <- sum(n_ * effect) / sum(n_)
  sd_sq <- sum(n_ * ((effect - r_avg)^2)) / sum(n_) # SD_r^2
  assert(sd_sq >= 0, "Negative SD_r^2")
  se_r = sqrt(sd_sq) / sqrt(nrow(df)) # SE_r
  t_value <- r_avg / se_r
  return(list(est = r_avg, t_value = t_value))
}

#' Calculate Fisher's z
#'
#' @note For the calculation, all studies should be present in the dataset.
#' @export
fishers_z <- function(df, method = "ML") {
  meta <- unique(df$meta)
  n_ <- df$sample_size # Q: sample size here, not df?

  suppressWarnings( # Sometimes the log produces NaNs - handled below
    fishers_z_ <- 0.5 * log((1 + df$effect) / (1 - df$effect))
  )
  suppressWarnings( # Sometimes the negative sqrt produces NaNs - handled below
    se_ <- 1 / sqrt(n_ - 3)
  )

  re_data <- data.frame(effect = fishers_z_, se = se_, meta = df$meta, study = df$study)
  re_data <- re_data[!is.na(fishers_z_) & !is.na(se_), ] # Drop NA rows

  if (nrow(re_data) == 0) {
    logger::log_debug(paste("No data to calculate Fisher's z for meta-analysis", meta))
    return(list(est = NA, t_value = NA))
  }

  re_list <- re(df = re_data, method = method)
  re_est <- re_list$est
  re_t_value <- re_list$t_value

  re_z <- (exp(2 * re_est) - 1) / (exp(2 * re_est) + 1)

  return(list(est = re_z, t_value = re_t_value))
}

#' Calculate various summary statistics associated with the PCC data frame
#' @export
pcc_sum_stats <- function(df, log_results = TRUE) {
  k_ <- nrow(df)
  quantiles = stats::quantile(df$sample_size, probs = c(0.25, 0.75), na.rm = TRUE)

  # ss_lt ~ sample sizes less than
  get_ss_lt <- function(lt) {
    # Q: Should the sample sizes be dropped if they are missing?
    if (sum(is.na(df$sample_size)) == nrow(df)) return(NA) # No sample sizes
    return(
      sum(df$sample_size < lt, na.rm = TRUE) / k_
    )
  }

  res <- list(
    k_ = k_,
    avg_n = mean(df$sample_size, na.rm = TRUE),
    median_n = mean(df$sample_size, na.rm = TRUE),
    quantile_1_n = as.numeric(quantiles[1]),
    quantile_3_n = as.numeric(quantiles[2]),
    ss_lt_50 = get_ss_lt(50),
    ss_lt_100 = get_ss_lt(100),
    ss_lt_200 = get_ss_lt(200),
    ss_lt_400 = get_ss_lt(400),
    ss_lt_1600 = get_ss_lt(1600),
    ss_lt_3200 = get_ss_lt(3200)
  )

  if (log_results) {
    logger::log_info("PCC analysis summary statistics:")
    logger::log_info(paste("Number of PCC "))
  }
  return(res)
}
