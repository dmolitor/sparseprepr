test_that("remove_correlated drops the correct columns", {
  x <- Matrix::rsparsematrix(100, 5, 0.5)
  x <- cbind(x, x[, 4:5], x[, 4:5])
  colnames(x) <- paste0("x", 1:9)
  xdense <- as.matrix(x)

  expect_equal(as.matrix(remove_correlated(x)), remove_correlated(xdense))
  expect_s4_class(remove_correlated(x), "dgCMatrix")
  expect_equal(colnames(remove_correlated(x)), paste0("x", 1:5))
})

test_that("remove_correlated handles edge cases", {
  x <- Matrix::rsparsematrix(100, 5, 0.5)
  x <- cbind(x, x[, 4:5], 0, 0)
  colnames(x) <- paste0("x", 1:9)
  xdense <- as.matrix(x)

  expect_warning(remove_correlated(x))
  expect_warning(remove_correlated(xdense))
  expect_equal(
    suppressWarnings(colnames(remove_correlated(x))), paste0("x", c(1:5, 8, 9))
  )
})
