test_that("remove_constant drops the correct columns", {
  # Create matrices
  set.seed(123)
  # Create a sparse matrix with constant columns
  xsparse <- Matrix::rsparsematrix(100, 3, 0.1)
  colnames(xsparse) <- paste0("x", 1:3)
  xsparse <- cbind(xsparse, "x4" = 1, "x5" = 54)
  # Create dense matrix
  xdense <- as.matrix(xsparse)

  expect_equal(remove_constant(xsparse), xsparse[, 1:3])
  expect_equal(remove_constant(xdense), xdense[, 1:3])
  expect_equal(as.matrix(remove_constant(xsparse)), remove_constant(xdense))
})

test_that("remove_constant handles edge cases correctly", {
  # Create matrices
  set.seed(123)
  # Create a sparse matrix with constant columns
  xsparse <- Matrix::rsparsematrix(100, 3, 0.1)
  colnames(xsparse) <- paste0("x", 1:3)
  xsparse <- cbind(xsparse, "x4" = 1, "x5" = 54)[, 4:5]
  # Create dense matrix
  xdense <- as.matrix(xsparse)

  expect_equal(dim(remove_constant(xsparse)), c(100, 0))
  expect_s4_class(remove_constant(xsparse), "dgCMatrix")
  expect_equal(
    remove_constant(xdense),
    matrix(double(0), nrow = 100, ncol = 0, dimnames = list(NULL, NULL))
  )
  expect_equal(remove_constant(remove_constant(xdense)), remove_constant(xdense))
  expect_equal(remove_constant(remove_constant(xsparse)), remove_constant(xsparse))
})
