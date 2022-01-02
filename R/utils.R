# Apply a function to sparse matrix columns in an lapply-esque manner
apply_sparse_mat <- function(x, .f, ..., drop = FALSE, append.names = NULL, simplify = TRUE) {
  stopifnot(inherits(x, "CsparseMatrix") || inherits(x, "matrix"))
  if (ncol(x) < 1 || nrow(x) < 1) return(x)
  col.names <- colnames(x)
  colnames(x) <- NULL
  num_cols <- ncol(x)
  out <- lapply(
    1:num_cols,
    function(i) {
      .f(x[, i, drop = drop], ...)
    }
  )
  if (!is.null(append.names) && !is.null(col.names)) {
    if (length(append.names) == 1 || length(append.names) == num_cols) {
      col.names <- paste0(col.names, "_", append.names)
    } else {
      warn(
        paste0(
          "`name.sep` must be length 1 or ",
          num_cols,
          " - Continuing without changing column names"
        )
      )
    }
  }
  if (simplify) {
    out <- do.call(cbind, out)
    colnames(out) <- col.names
  } else {
    names(out) <- col.names
  }
  if (drop) {
    Matrix::Matrix(out, sparse = TRUE)
  } else {
    out
  }
}
