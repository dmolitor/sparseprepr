sparse_compatible <- function(sparse.mat, fun, ...) {
  stopifnot(ncol(sparse.mat) == 1, inherits(sparse.mat, "CsparseMatrix"))
  name <- colnames(sparse.mat)
  triplet_form <- Matrix::mat2triplet(sparse.mat)
  out <- Matrix::sparseMatrix(
    i = triplet_form$i, 
    j = triplet_form$j, 
    x = triplet_form$x
  )
  colnames(out) <- name
  out
}

# above_threshold <- function(x, threshold = 0.5) {
#   ifelse(x >= threshold, 1, -1)
# }
# 
# sparse_compatible(tst, above_threshold, 1)