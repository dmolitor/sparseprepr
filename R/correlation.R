#' Correlation (Sparse and Dense Matrices)
#'
#' `cor` computes the sample correlation between each column pair in sparse or
#' dense matrices.
#'
#' `cor()` is an S3 generic with methods for:
#' \itemize{
#'   \item{
#'     \code{dgCMatrix}
#'   }
#'   \item{
#'    Any object supported by \code{stats::cor}
#'   }
#' }
#'
#' @param x A `matrix` or `dgCMatrix`.
#' @param ... Additional arguments to pass to methods.
#'
#' @return A `p`x`p` matrix where `p` is the number of matrix columns, and the
#'   (`i`, `j`) th element corresponds to the sample correlation between `p_i`
#'   and `p_j`.
#'
#' @examples
#' x <- Matrix::rsparsematrix(10, 3, .5)
#' xdense <- as.matrix(x)
#'
#' cor(x)
#' cor(xdense)
#'
#' @export
cor <- function(x, ...) {
  UseMethod("cor")
}

#' @method cor default
#' @rdname cor
#' @export
cor.default <- function(x, ...) {
  stats::cor(x = x, ...)
}

#' @method cor dgCMatrix
#' @rdname cor
#' @export
cor.dgCMatrix <- function(x, ...) {
  n <- nrow(x)
  cMeans <- Matrix::colMeans(x)
  cSums <- Matrix::colSums(x)
  covmat <- Matrix::tcrossprod(
    cMeans,
    ((-2 * cSums) + (n * cMeans))
  )
  crossp <- Matrix::crossprod(x)
  covmat <- covmat + crossp
  sdvec <- sqrt(Matrix::diag(covmat)) # standard deviations of columns
  if (any(sdvec == 0)) {
    zerovar <- which(sdvec == 0)
    warning(
      paste("Column(s)",
            paste(zerovar, collapse = ", "),
            "have a standard deviation of 0"),
      call. = FALSE
    )
    cprod <- Matrix::crossprod(Matrix::t(sdvec))
    cprod[cprod == 0] <- NA
    cor_mat <- as.matrix(covmat/cprod) # correlation matrix
    diag(cor_mat) <- 1
  } else {
    cprod <- Matrix::crossprod(Matrix::t(sdvec))
    cor_mat <- as.matrix(covmat/cprod) # correlation matrix
  }
  cor_mat
}

