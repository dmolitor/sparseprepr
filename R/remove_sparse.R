#' Remove extremely sparse columns
#'
#' `remove_sparse()` removes columns from sparse and dense matrices that have a
#' sparsity value greater than a user-defined threshold.
#'
#' `remove_sparse()` is an S3 generic with methods for:
#' \enumerate{
#'   \item{
#'     \code{dgCMatrix}
#'   }
#'   \item{
#'    \code{matrix}
#'   }
#' }
#'
#' @param x A `matrix` or `dgCMatrix`.
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

#' @method remove_sparse dgCMatrix
#' @rdname remove_sparse
#' @export
remove_sparse.dgCMatrix <- function(x, threshold) {
  stopifnot(as.numeric(threshold) >= 0 && as.numeric(threshold) <= 1)
  x[, (1 - diff(x@p) / x@Dim[[1]] < threshold), drop = FALSE]
}

#' @method remove_sparse matrix
#' @rdname remove_sparse
#' @export
remove_sparse.matrix <- function(x, threshold) {
  stopifnot(as.numeric(threshold) >= 0 && as.numeric(threshold) <= 1)
  x[
    ,
    (1 - apply(x, 2L, Matrix::nnzero) / nrow(x) < threshold),
    drop = FALSE
  ]
}
