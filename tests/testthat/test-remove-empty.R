test_that("remove_empty correctly removes columns", {
  x <- Matrix::rsparsematrix(10, 3, .7)
  x <- cbind(0, x, 0)
  colnames(x) <- paste0("x", 1:5)
  xdense <- as.matrix(x)

  expect_equal(as.matrix(remove_empty(x)), remove_empty(xdense))
  expect_equal(colnames(remove_empty(x)), paste0("x", 2:4))
  expect_equal(remove_empty(remove_empty(x)), remove_empty(x))
})
