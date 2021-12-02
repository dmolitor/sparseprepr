test_that("correlation works as expected on varying data types", {
  x <- Matrix::rsparsematrix(100, 5, .5)
  x_dense <- as.matrix(x)
  x_vec <- x[, 1]
  y_vec <- x[, 2]

  expect_equal(`dimnames<-`(cor(x), NULL), cor(x_dense))
  expect_equal(cor(x)[1, 2], cor(x_vec, y_vec))
  expect_error(cor(c(1, 2, 3, 4, 5)))
})
