test_that("transform_cols edits columns in place correctly", {
  x <- Matrix::rsparsematrix(10, 4, .5)
  colnames(x) <- paste0("x", 1:4)
  x_dense <- as.matrix(x)
  x_confirm <- cbind(x[, 1:2], scale(x[, 3:4]))
  x_confirm_dense <- as.matrix(x_confirm)

  expect_equal(transform_cols(x, scale, which = 3:4), x_confirm)
  expect_equal(transform_cols(x_dense, scale, which = c("x3", "x4")), x_confirm_dense)
  expect_warning(transform_cols(x, scale, which = 3:4, name.sep = paste0("norm", 1:2)))
})
