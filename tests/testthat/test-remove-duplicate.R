test_that("remove_duplicate drops the correct columns", {
  # Create matrices
  set.seed(123)
  # Create a sparse matrix with constant columns
  xsparse <- Matrix::rsparsematrix(100, 3, 0.1)
  colnames(xsparse) <- paste0("x", 1:3)
  xsparse <- cbind(xsparse, xsparse[, 2])
  # Create dense matrix
  xdense <- as.matrix(xsparse)

  expect_equal(remove_duplicate(xsparse), xsparse[, 1:3])
  expect_equal(remove_duplicate(xdense), xdense[, 1:3])
  expect_equal(as.matrix(remove_duplicate(xsparse)), remove_duplicate(xdense))
})

test_that("remove_constant handles edge cases correctly", {
  # Create matrices
  set.seed(123)
  # Create a sparse matrix with constant columns
  xsparse <- Matrix::rsparsematrix(100, 3, 0.1)
  colnames(xsparse) <- paste0("x", 1:3)
  xsparse <- cbind(xsparse, "x4" = 1, "x5" = 2)[, 4:5]
  # Create dense matrix
  xdense <- as.matrix(xsparse)

  expect_equal(remove_duplicate(remove_constant(xsparse)), remove_constant(xsparse))
  expect_equal(remove_duplicate(remove_constant(xdense)), remove_constant(xdense))
})
