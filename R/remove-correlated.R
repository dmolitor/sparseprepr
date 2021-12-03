#' Remove highly correlated columns
#'
#' `remove_correlated` removes one of column-pairs from sparse and dense
#' matrices that have sample correlation value greater than a user-defined
#' threshold.
#'
#' `remove_correlated()` is an S3 generic with methods for:
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
#' @param threshold A double between 0 and 1 specifying the absolute correlation
#'   threshold value at which to remove columns.
#'
#' @return `x` with one of highly correlated column-pairs removed.
#'
#' @examples
#' # Create a sparse matrix with very sparse columns
#' x <- Matrix::rsparsematrix(10, 5, 0.5)
#' x <- cbind(x, x[, 4:5], x[, 4:5])
#' # Create two perfectly correlated columns
#' colnames(x) <- paste0("x", 1:9)
#' # Print x
#' x
#'
#' # Same matrix in dense format
#' xdense <- as.matrix(x)
#'
#' # Drop highly correlated columns
#' remove_correlated(x, threshold = 0.99)
#' remove_correlated(xdense, threshold = 0.99)
#'
#' @export
remove_correlated <- function(x, threshold) {
  UseMethod("remove_correlated")
}

#' @method remove_correlated dgCMatrix
#' @rdname remove_correlated
#' @export
remove_correlated.dgCMatrix <- function(x, threshold = 0.99) {
  stopifnot(is.numeric(threshold), threshold >= 0, threshold <= 1)
  cor_mat <- cor(x)
  cor_mat[upper.tri(cor_mat, TRUE)] <- NA
  drop_cols <- which(abs(cor_mat) >= threshold, arr.ind = TRUE)[, 1]
  if (identical(drop_cols, integer(0))) return(x)
  x[, -drop_cols, drop = FALSE]
}

#' @method remove_correlated matrix
#' @rdname remove_correlated
#' @export
remove_correlated.matrix <- function(x, threshold = 0.99) {
  stopifnot(is.numeric(threshold), threshold >= 0, threshold <= 1)
  cor_mat <- cor(x)
  cor_mat[upper.tri(cor_mat, TRUE)] <- NA
  drop_cols <- which(abs(cor_mat) >= threshold, arr.ind = TRUE)[, 1]
  if (identical(drop_cols, integer(0))) return(x)
  x[, -drop_cols, drop = FALSE]
}
