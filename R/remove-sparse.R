#' Remove extremely sparse columns
#'
#' `remove_sparse()` removes columns from sparse and dense matrices that have a
#' sparsity value greater than a user-defined threshold.
#'
#' `remove_sparse()` is an S3 generic with methods for:
#' \itemize{
#'   \item{
#'     \code{CsparseMatrix}
#'   }
#'   \item{
#'    \code{matrix}
#'   }
#' }
#'
#' @param x A `matrix` or `CsparseMatrix`.
#' @param threshold A double between 0 and 1 specifying the sparsity threshold
#'   at which to remove columns.
#'
#' @return `x` with sparse columns removed.
#'
#' @examples
#' # Create a sparse matrix with very sparse columns
#' x <- Matrix::rsparsematrix(10, 5, 0.1)
#' colnames(x) <- paste0("x", 1:5)
#' # Print x
#' x
#'
#' # Same matrix in dense format
#' xdense <- as.matrix(x)
#'
#' # Drop duplicate columns
#' remove_sparse(x, threshold = 0.9)
#' remove_sparse(xdense, threshold = 0.9)
#'
#' @export
remove_sparse <- function(x, threshold) {
  UseMethod("remove_sparse")
}

#' @method remove_sparse CsparseMatrix
#' @rdname remove_sparse
#' @export
remove_sparse.CsparseMatrix <- function(x, threshold) {
  if (!(as.numeric(threshold) >= 0 && as.numeric(threshold) <= 1)) {
    abort("`threshold` must be in [0, 1]")
  }
  x[, (1 - diff(x@p) / x@Dim[[1]] < threshold), drop = FALSE]
}

#' @method remove_sparse matrix
#' @rdname remove_sparse
#' @export
remove_sparse.matrix <- function(x, threshold) {
  if (!(as.numeric(threshold) >= 0 && as.numeric(threshold) <= 1)) {
    abort("`threshold` must be in [0, 1]")
  }
  x[
    ,
    which(1 - apply(x, 2L, Matrix::nnzero) / nrow(x) < threshold),
    drop = FALSE
  ]
}
