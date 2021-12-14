test_that("remove_empty correctly removes columns", {
  x <- Matrix::rsparsematrix(10, 3, .7)
  x <- cbind(0, x, 0)
  colnames(x) <- paste0("x", 1:5)
  xdense <- as.matrix(x)

  expect_equal(as.matrix(remove_constant(x)), remove_constant(xdense))
  expect_equal(colnames(remove_constant(x)), paste0("x", 2:4))
  expect_equal(remove_constant(remove_constant(x)), remove_constant(x))
})
