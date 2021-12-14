#' Remove empty (all-zero) columns
#'
#' `remove_empty()` removes all-zero columns from sparse and dense matrices.
#'
#' `remove_empty()` is an S3 generic with methods for:
#' \itemize{
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
#' @return `x` with all-zero columns removed.
#'
#' @examples
#' # Create a sparse matrix with constant columns
#' x <- Matrix::rsparsematrix(10, 3, 0.1)
#' x <- cbind(x, 0)
#' colnames(x) <- paste0("x", 1:4)
#' # Print x
#' x
#'
#' # Same matrix in dense format
#' xdense <- as.matrix(x)
#'
#' # Drop empty columns
#' remove_empty(x)
#' remove_empty(xdense)
#'
#' @export
remove_empty <- function(x) {
  UseMethod("remove_empty")
}

#' @method remove_empty dgCMatrix
#' @rdname remove_empty
#' @export
remove_empty.dgCMatrix <- function(x) {
  empty_cols <- diff(x@p) == 0
  if (!any(empty_cols)) {
    return(x)
  }
  x[, !empty_cols, drop = FALSE]
}

#' @method remove_empty matrix
#' @rdname remove_empty
#' @export
remove_empty.matrix <- function(x) {
  empty_cols <- apply(x, MARGIN = 2, FUN = function(i) max(i) == 0 & min(i) == 0)
  if (!any(empty_cols)) {
    return(x)
  }
  x[, -which(empty_cols), drop = FALSE]
}
