box::use(
  testthat[expect_error, expect_silent, test_that]
)

test_that("tests run correctly", {

  expect_silent({
    x <- 1
    y <- 2
    sum <- x + y
    expect_equal(sum, 3)
  })

  expect_error({
    stop("This is an error")
  }, "This is an error")
})

# test_that("checkForMissingCols handles missing columns correctly", {
#     # Create a test data frame
#     df <- data.frame(Effect = 1:3, `Standard Error` = rnorm(3))

#     # Test for missing columns error
#     expect_error(
#         check_for_missing_cols()(df, c("Effect", "Standard Error", "Lower CI", "Upper CI")),
#         "The data frame is missing the following columns: Lower CI, Upper CI"
#     )

#     # Test with all columns present
#     df$`Lower CI` <- rnorm(3)
#     df$`Upper CI` <- rnorm(3)
#   expect_silent(check_for_missing_cols()(df, c("Effect", "Standard Error", "Lower CI", "Upper CI")))
# })
