box::use(
  testthat[test_that],
  libs / logs / index[setup_logging]
)

test_that("logs are set up correctly", {
  expect_silent({
    setup_logging()
  })

  # expect_true(logger::is_appender_registered("file"))
})
