box::use(
  testthat[test_that],
  libs / logs / index[setup_logging, teardown_logger_file]
)

test_that("logs are set up correctly", {
  logger_name <- "test.log"
  expect_silent({
    setup_logging(logger_name=logger_name)
    teardown_logger_file(logger_name=logger_name)
  })

  # expect_true(logger::is_appender_registered("file"))
})
