#' Transform Sparse Matrix columns
#'
#' `transform_cols()` transforms specified matrix columns with a user-supplied
#' function.
#'
#' `transform_cols()` is an S3 generic with methods for:
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
#' @param fun A user-supplied function to apply to the specified columns.
#' @param ... Additional arguments to pass to `fun`.
#' @param which A numeric vector indicating column indices or a character vector
#'   indicating column names.
#' @param drop A logical value. If `fun` works with columnar matrices, then set
#'   `drop = FALSE`, otherwise if `fun` requires a numeric vector set
#'   `drop = TRUE`.
#'
#' @examples
#' x <- Matrix::rsparsematrix(10, 4, .9)
#' colnames(x) <- paste0("x", 1:10)
#'
#' transform_cols(x, fun = function(i) i^2, which = paste0("x", 6:10))
#' transform_cols(x, fun = scale, which = 6:10, drop = TRUE)
#'
#' @export
transform_cols <- function(x, fun, ..., which, drop, name.sep) {
  UseMethod("transform_cols")
}

#' @method transform_cols dgCMatrix
#' @rdname transform_cols
#' @export
transform_cols.dgCMatrix <- function(x, fun, ..., which, drop = FALSE, name.sep = NULL) {
  if (is.null(name.sep)) {
    x[, which] <- apply_sparse_mat(
      x = x[, which],
      .f = fun,
      ... = ...,
      drop = drop,
      append.names = name.sep
    )
  } else {
    x <- cbind(
      x,
      apply_sparse_mat(
        x = x[, which],
        .f = fun,
        ... = ...,
        drop = drop,
        append.names = name.sep
      )
    )
  }
  x
}

#' @method transform_cols matrix
#' @rdname transform_cols
#' @export
transform_cols.matrix <- function(x, fun, ..., which, drop = FALSE, name.sep = NULL) {
  if (is.null(name.sep)) {
    x[, which] <- apply_sparse_mat(
      x = x[, which],
      .f = fun,
      ... = ...,
      drop = drop,
      append.names = name.sep
    )
  } else {
    x <- cbind(
      x,
      apply_sparse_mat(
        x = x[, which],
        .f = fun,
        ... = ...,
        drop = drop,
        append.names = name.sep
      )
    )
  }
  x
}
