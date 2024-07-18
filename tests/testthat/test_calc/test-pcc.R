box::use(
  testthat[expect_error, expect_no_error, expect_silent, test_that],
  pcc_calc = calc / pcc,
  # .. / .. / .. / helpers / mocks / mock_df[create_mock_df]
)

test_that("random-effects function works", {
  data_frame <- data.frame(
    effect = c(1, 2, 3),
    se = c(0.1, 0.2, 0.3)
  )

  expect_no_error({
    pcc_calc$re(data_frame)
  })
  

})
