% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transform-cols.R
\name{transform_cols}
\alias{transform_cols}
\alias{transform_cols.CsparseMatrix}
\alias{transform_cols.matrix}
\title{Transform matrix columns}
\usage{
transform_cols(x, fns, ..., which.cols, drop, name.sep)

\method{transform_cols}{CsparseMatrix}(x, fns, ..., which.cols, drop = FALSE, name.sep = NULL)

\method{transform_cols}{matrix}(x, fns, ..., which.cols, drop = FALSE, name.sep = NULL)
}
\arguments{
\item{x}{A \code{matrix} or \code{CsparseMatrix}.}

\item{fns}{A user-supplied function, or list of functions, to apply to the
specified columns.}

\item{...}{Additional arguments to pass to \code{fns}. It is important to note
that these arguments will be passed to every function in \code{fns}, and so
should only include arguments that are relevant to each function.}

\item{which.cols}{A numeric vector indicating column indices or a character
vector indicating column names.}

\item{drop}{A logical value. If the functions in \code{fns} work with columnar
matrices, then set \code{drop = FALSE}, otherwise if the functions in \code{fns}
require a numeric vector, set \code{drop = TRUE}. When working with large sparse
matrices, it is essential to set \code{drop = FALSE}, as the alternative will
be much more memory intensive.}

\item{name.sep}{A \code{NULL} value or a list corresponding to each element of
\code{fns}. If \code{name.sep} is \code{NULL} the specified columns will be transformed
in-place, provided \code{length(fns) == 1}. If \code{fns} has more than one element,
and \code{name.sep} is \code{NULL}, it will default to a numeric vector that is equal
to \code{length(fns)}. If \code{name.sep} is provided as a list, each element of this
list must contain a character vector of length 1 or \code{ncol(x)} that will
be appended to existing column names to create new column names. Providing
this argument ensures that the transformed columns will be appended as new
matrix columns.}
}
\description{
\code{transform_cols()} transforms specified matrix columns with a user-supplied
function.
}
\details{
\code{transform_cols()} is an S3 generic with methods for:
\itemize{
\item{
\code{CsparseMatrix}
}
\item{
\code{matrix}
}
}
}
\examples{
x <- Matrix::rsparsematrix(10, 4, .9)
colnames(x) <- paste0("x", 1:4)
x

# Convert columns in-place with a single function
transform_cols(x, fns = function(i) i^2, which.cols = 3:4)
transform_cols(x, fns = function(i) i^2, which.cols = c("x3", "x4"))

# Mutate new columns with a single function
transform_cols(x, fns = scale, which.cols = 3:4, name.sep = "scaled")

# Mutate new columns with a list of functions and names
transform_cols(
  x,
  fns = c(function(i) i^2, function(i) i^3),
  which.cols = 3:4,
  name.sep = c("squared", "cubed")
)

# Mutate new columns with a list of functions and names for each new column
transform_cols(
  x,
  fns = c(function(i) i^2, function(i) i^3),
  which.cols = 3:4,
  name.sep = list(paste0("squared", 1:2), paste0("cubed", 1:2))
)

}
