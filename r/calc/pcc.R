box::use(
  stats[model.frame],
  libs / utils[validate_columns, validate],
  base / metadata[METADATA],
)

#' Extract the DoF vector from a data frame. Where the DoF's are missing, use sample size minus 7.
#'
#' @param df [data.frame] The data frame to extract the information from
#' @param offset [numeric] The number to offset the sample size by
#' @return [vector] A vector of either DoF's, or adjusted sample sizes.
dof_or_sample_size <- function(df, offset = NULL) {
  validate_columns(df, c("dof", "sample_size"))

  dof_ <- data.table::copy(df$dof) # Get DoF
  missing_dof <- is.na(dof_) # boolean vector

  # Replace DF with 'sample size - 7' when missing
  dof_[missing_dof] <- df$sample_size[missing_dof] - 7

  # Modify by the offset
  if (!is.null(offset)) {
    validate(is.numeric(offset))
    dof_ <- dof_ - offset
  }

  # TEMP
  dof_below_0 <- dof_ <= 0
  dof_[dof_below_0] <- 1 # Q:

  return(dof_)
}


#' Calculate the PCC variance.
#'
#' @param df [data.frame] The data frame upon which to calculate the PCC vairance. Should include the columns 'effect', 'sample_size', 'dof'
#' @param offset [int] An offset value to subtract from the degrees of freedom
#'  in case they are missing.
#' @return [vector] A vector of PCC variances.
#' @export
pcc_variance <- function(df, offset) {
  validate_columns(df, c("dof", "sample_size", "effect"))
  pcc_ <- df$effect
  numerator <- (1 - pcc_^2)^2

  denominator <- dof_or_sample_size(df, offset = offset)
  variance <- numerator / denominator
  return(variance)
}

#' Calculate random effects
#'
#' @param df [data.frame] The data frame to calculate the RE with
#' @param effect [vector] The vector of effects. If not provided, defaults to df$effect.
#' @param se [vector] The vector of SEs. If not provided, defaults to df$se.
#' @export
re <- function(df, effect = NULL, se = NULL) {
  if (is.null(effect)) {
    effect <- df$effect
  }
  if (is.null(se)) {
    se <- df$se
  }
  # Compute RE - for some cases, the model can't be fitted
  # See: https://stackoverflow.com/questions/45121817/plm-package-in-r-empty-model-when-including-only-variables-without-variation-o
  result <- tryCatch({
    meta <- unique(df$meta)
    if (length(meta) != 1) {
      logger::log_warn("Could not calculate RE for multiple meta-analyses")
      return(list(est = NA, t_value = NA))
    }

    re_data_ <- data.frame(yi = effect, sei = se, study = df$study)

    use_fast <- METADATA$methods$use_fast_re

    if (use_fast) {
      suppressWarnings(
        re_ <- plm::plm(yi ~ sei, data = re_data_, index = "study", model = "random")
      )
      re_summary <- summary(re_)
      re_est <- re_summary$coefficients[1, "Estimate"]
      re_se <- re_summary$coefficients[1, "Std. Error"]
    } else {
      suppressWarnings(
        re_ <- metafor::rma(yi = yi, sei = sei, data = re_data_, method = "REML") # Use "DL" for DerSimonian-Laird estimator
      )
      re_est <- re_$beta[1]
      re_se <- re_$se[1]
    }

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
  meta <- unique(df$meta)
  validate(length(meta) == 1)

  if (is.null(effect)) {
    effect <- df$effect
  }
  if (is.null(se)) {
    se <- df$se
  }
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
  t_ <- df$effect / df$se # Q: Here, the effect is PCC - ok?
  dof_ <- dof_or_sample_size(df)

  pcc_ <- t_ / sqrt(t_^2 + dof_ + 1) # r_3 Q: +1?
  pcc_var_ <- (1 - pcc_^2) / (dof_ + 3) # S_3^2 Q: +3?
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
  dof_ <- dof_or_sample_size(df)
  r_avg <- sum(dof_ * df$effect) / sum(dof_)
  sd_sq <- sum(dof_ * ((df$effect - r_avg)^2)) / sum(dof_) # SD_r^2
  se_r = sqrt(sd_sq) / sqrt(nrow(df)) # SE_r
  t_value <- r_avg / se_r
  return(list(est = se_r, t_value = t_value))
}

#' Calculate Fisher's z
#'
#' @note For the calculation, all studies should be present in the dataset.
#' @export
fishers_z <- function(df) {
  meta <- unique(df$meta)
  dof_ <- dof_or_sample_size(df)

  # Sometimes the DoF - x yields NA -> remove these rows
  suppressWarnings(
    na_rows <- is.na(sqrt(dof_ - 1))
  )
  if (sum(na_rows) > 0) {
    logger::log_debug(paste("Identified", sum(na_rows), "missing DoF values when calculating Fisher's z for meta-analysis", meta))
    df <- df[!na_rows, ]
    dof_ <- dof_or_sample_size(df)
  }

  suppressWarnings(
    fishers_z_ <- 0.5 * log((1 + df$effect) / (1 - df$effect))
  )
  se_ <- sqrt(dof_ - 1)

  re_data <- data.frame(effect = fishers_z_, se = se_, meta = df$meta, study = df$study)
  re_data <- re_data[!is.na(fishers_z_), ] # Drop NA rows from log transformation

  if (nrow(re_data) == 0) {
    logger::log_debug(paste("No data to calculate Fisher's z for meta-analysis", meta))
    return(list(est = NA, t_value = NA))
  }

  re_list <- re(df = re_data)

  re_est <- re_list$est
  re_t_value <- re_list$t_value

  # RE_z estimate
  re_z <- exp(
    (2 * re_est - 1) / (2 * re_est + 1)
  )

  # Q: Alternative?
  # 1. Weights of each SE
  # w_ <- 1 / se_^2
  # 2. Weighted mean of z-scores
  # z_re_ <- sum(w_ * fishers_z_, na.rm = TRUE) / sum(w_, na.rm = TRUE)
  # re_z <- exp(2 * z_re_ - 1) / exp(2 * z_re_ + 1)

  return(list(est = re_z, t_value = re_t_value))
}

#' Calculate various summary statistics associated with the PCC data frame
#' @export
pcc_sum_stats <- function(df, log_results = TRUE) {
  k_ <- nrow(df)
  quantiles = stats::quantile(df$sample_size, probs = c(0.25, 0.75), na.rm = TRUE)

  # ss_lt ~ sample sizes less than
  get_ss_lt <- function(lt) {
    return(
      sum(df$sample_size < lt) / k_
    )
  }

  res <- list(
    k_ = k_,
    avg_n = mean(df$sample_size),
    median_n = mean(df$sample_size),
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
