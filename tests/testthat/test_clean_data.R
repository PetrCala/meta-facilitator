library("testthat")
source("R/libs/clean_data/index.R")


test_that("checkForMissingCols handles missing columns correctly", {
    # Create a test data frame
    df <- data.frame(Effect = 1:3, `Standard Error` = rnorm(3))

    # Test for missing columns error
    expect_error(
        checkForMissingCols(df, c("Effect", "Standard Error", "Lower CI", "Upper CI")),
        "The data frame is missing the following columns: Lower CI, Upper CI"
    )

    # Test with all columns present
    df$`Lower CI` <- rnorm(3)
    df$`Upper CI` <- rnorm(3)
    expect_silent(checkForMissingCols(df, c("Effect", "Standard Error", "Lower CI", "Upper CI")))
})
