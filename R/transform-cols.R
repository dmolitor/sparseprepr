#' Transform Sparse Matrix columns
#'
#' `transform_cols()` transforms specified matrix columns with a user-supplied
#' function.
#'
#' `transform_cols()` is an S3 generic with methods for:
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
#' @param fun A user-supplied function to apply to the specified columns.
#' @param ... Additional arguments to pass to `fun`.
#' @param which A numeric vector indicating column indices or a character vector
#'   indicating column names.
#' @param drop A logical value. If `fun` works with columnar matrices, then set
#'   `drop = FALSE`, otherwise if `fun` requires a numeric vector set
#'   `drop = TRUE`.
#' @param name.sep A character vector of length 1 or `nrow(x)` that will be
#'   appended to existing column names to create new columns. Providing this
#'   argument ensures that the transformed columns will be appended as new
#'   matrix columns. If `name.sep` is `NULL` the specified columns will be
#'   transformed in-place. If `name.sep` is provided, but is faulty, the
#'   specified columns will be appended as new columns but will have un-changed
#'   column names.
#'
#' @examples
#' x <- Matrix::rsparsematrix(10, 4, .9)
#' colnames(x) <- paste0("x", 1:4)
#' x
#'
#' transform_cols(x, fun = function(i) i^2, which = paste0("x", 3:4))
#' transform_cols(x, fun = scale, which = 3:4, drop = TRUE)
#' transform_cols(x, fun = scale, which = 3:4, name.sep = "normalized")
#'
#' @export
transform_cols <- function(x, fun, ..., which, drop, name.sep) {
  UseMethod("transform_cols")
}

#' @method transform_cols CsparseMatrix
#' @rdname transform_cols
#' @export
transform_cols.CsparseMatrix <- function(x, fun, ..., which, drop = FALSE, name.sep = NULL) {
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
