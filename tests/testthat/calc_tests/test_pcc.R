box::use(
  testthat[expect_error, expect_no_error, expect_silent, test_that],
  testing / mocks / mock_df[create_mock_df],
  pcc_calc = calc / pcc,
)

test_that("random-effects function works", {
  data_frame <- create_mock_df(nrow=1000)

  expect_no_error({
    pcc_calc$re(df=data_frame)
  })

})
