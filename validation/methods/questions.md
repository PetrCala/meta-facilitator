### Imputing degrees of freedom

- **Question**: When imputing degrees of freedom from sample size - how do I handle small/zero/negative resulting degrees of freedom?
- **Details**: In the degrees of freedom calculation, I use `sample_size - 7` when DoFs are missing. This, however, sometimes leads to negative imputed degrees of freedom. How should I handle these values? If left unchanged, they will cause issues down the line by having a negative sign, leading to problems such as taking a square root of a negative, resulting in errors.

### Calculating the UWLS+3

- **Question**: When calculating UWLS+3, what are the correct offsets?
- **Details**:

  ```R
  uwls3 <- function(df) {
    t_ <- df$effect / df$se
    dof_ <- dof_or_sample_size(df)

    pcc_ <- t_ / sqrt(t_^2 + dof_ + 1) # r_3 Q: +1?
    pcc_var_ <- (1 - pcc_^2) / (dof_ + 3) # S_3^2 Q: +3?
    ...
  }
  ```

  In the snippet above, are the offsets (+1, +3) used in the denominators correct?

### REML fails to converge

- **Question**: The rma method when calculating Random-Effects with `method = "ML"` sometimes fails to converge for seemingly valid data with the following errors message:

  ```R
  Fisher scoring algorithm did not converge. See 'help(rma)' for possible remedies.
  ```

  What could be the cause? Reading through the help manual, I failed to identify the potential problem.
