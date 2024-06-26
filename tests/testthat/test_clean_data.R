box::use(
  testthat[expect_error, expect_silent, test_that],
  # libs / clean_data / index[check_for_missing_cols]
)

test_that("some_test", {
  expect_silent({
    print("hello, world!")
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
#     expect_silent(check_for_missing_cols()(df, c("Effect", "Standard Error", "Lower CI", "Upper CI")))
# })
