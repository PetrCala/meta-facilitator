box::use(
  testthat[expect_error, expect_no_error, expect_silent, test_that],
)

test_that("logs an info log", {
  logger::log_info("This is an info log")
})