#' Remove duplicate columns
#'
#' `remove_duplicate()` removes duplicate columns from sparse and dense
#' matrices.
#'
#' `remove_duplicate()` is an S3 generic with methods for:
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
#' @return `x` with duplicate columns removed.
#'
#' @examples
#' # Create a sparse matrix with duplicated columns
#' x <- Matrix::rsparsematrix(10, 4, 0.1)
#' colnames(x) <- paste0("x", 1:4)
#' x <- cbind(x, x[, c(1, 4)])
#' # Print x
#' x
#'
#' # Same matrix in dense format
#' xdense <- as.matrix(x)
#'
#' # Drop duplicate columns
#' remove_duplicate(x)
#' remove_duplicate(xdense)
#'
#' @export
remove_duplicate <- function(x) {
  UseMethod("remove_duplicate")
}

#' @method remove_duplicate dgCMatrix
#' @rdname remove_duplicate
#' @export
remove_duplicate.dgCMatrix <- function(x) {
  if (ncol(x) == 0) return(x)
  J <- rep(1:ncol(x), diff(x@p))
  I <- x@i + 1
  H <- x@x
  names(H) <- I
  dupes <- split(H, factor(J, levels = 1:ncol(x)))
  idx <- duplicated(dupes)
  x[, !idx]
}

#' @method remove_duplicate matrix
#' @rdname remove_duplicate
#' @export
remove_duplicate.matrix <- function(x) {
  idx <- duplicated(x, MARGIN = 2L)
  x[, !idx]
}
