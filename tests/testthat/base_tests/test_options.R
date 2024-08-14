box::use(
  testthat[expect_error, expect_no_error, expect_silent, test_that],
  base / options[count_unique_names]
)


test_that("count_unique_names returns the expected output", {
  expect_equal(count_unique_names(list(a = 1, b = list(c = 2, d = 3))), 3)
  expect_equal(count_unique_names(list(a = 1, b = list(c = 2, d = 3), e = list(f = 4, g = 5))), 5)
  expect_equal(count_unique_names(list(a = list(x = 1, y = 2), b = list(c = 3, d = 4))), 4)
})
