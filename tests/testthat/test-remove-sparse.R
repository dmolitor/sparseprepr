test_that("remove_sparse drops the correct columns", {
  # Create matrices
  set.seed(123)
  # Create a sparse matrix with constant columns
  xsparse <- Matrix::rsparsematrix(100, 5, 0.1)
  colnames(xsparse) <- paste0("x", 1:5)
  # Create dense matrix
  xdense <- as.matrix(xsparse)

  expect_equal(as.matrix(remove_sparse(xsparse, 0.9)), remove_sparse(xdense, 0.9))
})

test_that("remove_constant handles edge cases correctly", {
  # Create matrices
  set.seed(123)
  # Create a sparse matrix with constant columns
  xsparse <- Matrix::rsparsematrix(100, 3, 0)
  colnames(xsparse) <- paste0("x", 1:3)
  # Create dense matrix
  xdense <- as.matrix(xsparse)

  expect_equal(dim(remove_sparse(xsparse, 1)), c(100, 0))
  expect_s4_class(remove_sparse(xsparse, 1), "dgCMatrix")
  expect_equal(
    remove_sparse(xdense, 1),
    matrix(double(0), nrow = 100, ncol = 0, dimnames = list(NULL, NULL))
  )
  expect_equal(remove_sparse(remove_sparse(xdense, 1), 1), remove_sparse(xdense, 1))
  expect_equal(remove_sparse(remove_sparse(xsparse, 1), 1), remove_sparse(xsparse, 1))
})
