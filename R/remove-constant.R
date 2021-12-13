#' Remove constant columns
#'
#' `remove_constant()` removes zero-variance columns from sparse and dense
#' matrices.
#'
#' `remove_constant()` is an S3 generic with methods for:
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
#' @return `x` with zero-variance columns removed.
#'
#' @examples
#' # Create a sparse matrix with constant columns
#' x <- Matrix::rsparsematrix(10, 3, 0.1)
#' colnames(x) <- paste0("x", 1:3)
#' x <- cbind(x, "x4" = 1, "x5" = 54)
#' # Print x
#' x
#'
#' # Same matrix in dense format
#' xdense <- as.matrix(x)
#'
#' # Drop constant columns
#' remove_constant(x)
#' remove_constant(xdense)
#'
#' @export
remove_constant <- function(x) {
  UseMethod("remove_constant")
}

#' @method remove_constant dgCMatrix
#' @rdname remove_constant
#' @export
remove_constant.dgCMatrix <- function(x) {
  empty_cols <- diff(x@p) == 0
  full_cols <- diff(x@p) == x@Dim[[1]]
  if (any(full_cols)) {
    full_cols[full_cols] <- apply(x[, full_cols, drop = FALSE],
                                  MARGIN = 2,
                                  FUN = function(i) abs(max(i) - min(i)) == 0)
  }
  drop_idx <- empty_cols | full_cols
  if (!any(drop_idx)) {
    return(x)
  }
  x[, !drop_idx, drop = FALSE]
}

#' @method remove_constant matrix
#' @rdname remove_constant
#' @export
remove_constant.matrix <- function(x) {
  drop_idx <- apply(x, MARGIN = 2, FUN = function(i) abs(max(i) - min(i)) == 0)
  x[, !drop_idx, drop = FALSE]
}
