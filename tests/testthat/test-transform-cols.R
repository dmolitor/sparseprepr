test_that("transform_cols edits columns in place correctly", {
  x <- Matrix::rsparsematrix(10, 4, .9)
  colnames(x) <- paste0("x", 1:4)
  x_dense <- as.matrix(x)
  x_confirm <- cbind(x[, 1:2], scale(x[, 3:4]))
  x_confirm_dense <- as.matrix(x_confirm)

  expect_equal(transform_cols(x, scale, which.cols = 3:4), x_confirm)
  expect_equal(
    transform_cols(x_dense, scale, which.cols = c("x3", "x4")),
    x_confirm_dense
  )
  expect_equal(
    as.matrix(transform_cols(x, scale, which.cols = 1:4)),
    transform_cols(x_dense, scale, which.cols = 1:4)
  )
})

test_that("transform_cols mutates new columns correctly", {
  x <- Matrix::rsparsematrix(10, 4, .5)
  x_confirm <- cbind(x, scale(x[, 3:4]))
  colnames(x) <- paste0("x", 1:4)
  colnames(x_confirm) <- c(paste0("x", 1:4), "x3_norm", "x4_norm")
  x_dense <- as.matrix(x)
  x_confirm_dense <- as.matrix(x_confirm)

  expect_equal(transform_cols(x, scale, which.cols = 3:4, name.sep = "norm"), x_confirm)
  expect_equal(transform_cols(x_dense, scale, which.cols = c("x3", "x4"), name.sep = "norm"), x_confirm_dense)
  expect_equal(as.matrix(transform_cols(x, scale, which.cols = 1:4, name.sep = "norm")),
               transform_cols(x_dense, scale, which.cols = 1:4, name.sep = "norm"))
})

test_that("transform_cols handles lists of functions and names correctly", {
  x <- Matrix::rsparsematrix(10, 4, .5)
  x_confirm <- cbind(x, scale(x[, 3:4]), x[, 3:4]^2, x[, 3:4]^3)
  colnames(x) <- paste0("x", 1:4)
  colnames(x_confirm) <- c(paste0("x", 1:4), unlist(lapply(c("norm", "sq", "cb"), function(i) paste0("x", 3:4, "_", i))))
  x_dense <- as.matrix(x)
  x_confirm_dense <- as.matrix(x_confirm)

  expect_equal(
    transform_cols(
      x,
      c(scale, function(i) i^2, function(i) i^3),
      which.cols = 3:4,
      name.sep = c("norm", "sq", "cb")
    ),
    x_confirm
  )
  expect_equal(
    transform_cols(
      x_dense,
      c(scale, function(i) i^2, function(i) i^3),
      which.cols = 3:4,
      name.sep = c("norm", "sq", "cb")
    ),
    x_confirm_dense
  )
  expect_equal(
    as.matrix(
      transform_cols(
        x,
        c(scale, function(i) i^2, function(i) i^3),
        which.cols = 3:4,
        name.sep = c("norm", "sq", "cb")
      )
    ),
    transform_cols(
      x_dense,
      c(scale, function(i) i^2, function(i) i^3),
      which.cols = 3:4,
      name.sep = c("norm", "sq", "cb")
    )
  )
})

test_that("transform_cols handles naming correctly", {
  x <- Matrix::rsparsematrix(10, 4, .5)
  colnames(x) <- paste0("x", 1:4)
  x_unnamed <- x
  colnames(x_unnamed) <- NULL

  expect_equal(cbind(x_unnamed, x_unnamed),
               transform_cols(x_unnamed, function(i) i, which.cols = 1:4, name.sep = list(paste0("x", 1:4))))
  expect_equal(colnames(transform_cols(x, scale, which.cols = 1:4, name.sep = "norm")),
               c(paste0("x", 1:4), paste0("x", 1:4, "_norm")))
  expect_warning(transform_cols(x, scale, which.cols = 1:4, name.sep = list(c("norm1", "norm2"))))
  expect_equal(cbind(x, x),
               suppressWarnings(transform_cols(x, function(i) i, which.cols = 1:4, name.sep = list(c("same1", "same2")))))
})

test_that("transform_cols errors correctly", {
  x <- Matrix::rsparsematrix(10, 4, .5)
  colnames(x) <- paste0("x", 1:4)

  expect_error(transform_cols(x, function(i) i, which.cols = -1:4),
               regexp = "Column indices are invalid: -1, 0")
  expect_error(transform_cols(x, function(i) i, which.cols = paste0("x", 1:10)),
               regexp = "Can't find specified column names in the matrix: `x5`, `x6`, `x7`, `x8`, `x9`, ...")
  expect_error(transform_cols(x, function(i) i, which.cols = NULL),
               regexp = "You've supplied an object of class NULL")
  expect_error(
    transform_cols(x, c(scale, mean), which.cols = 3:4, name.sep = "hello"),
    regexp = "`name.sep` must be the same length as `funs`:"
  )
  expect_error(
    transform_cols(x, c(scale, "mean"), which.cols = 3:4),
    regexp = "All elements of `funs` must be valid functions"
  )
  expect_error(
    transform_cols(x, fns = NULL, which.cols = 3:4),
    regexp = "`funs` must be non-null"
  )
})
