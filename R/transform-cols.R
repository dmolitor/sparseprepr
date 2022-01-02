# Checks list of input functions and names and validates
check_functions_and_names <- function(.fns, .nms) {
  if (is.null(.fns)) abort("`funs` must be non-null")
  are_functions <- vapply(c(.fns), is.function, NA)
  if (!all(are_functions)) {
    abort(
      c("All elements of `funs` must be valid functions",
        "x" = if (sum(!are_functions) > 5) {
          paste0(
            "The following inputs were not functions: `",
            paste0(.fns[!are_functions][1:5], collapse = "`, `"),
            "`, ..."
          )
        } else {
          paste0(
            "The following inputs were not functions: `",
            paste0(.fns[!are_functions], collapse = "`, `"),
            "`"
          )
        })
    )
  }
  if (length(.fns) > 1) {
    if (is.null(.nms)) {
      .nms <- as.character(1:length(are_functions))
    } else if (length(.nms) != length(are_functions)) {
      abort(
        c("`name.sep` must be the same length as `funs`:",
          "x" = paste0("`name.sep` has ", length(.nms), " elements"),
          "x" = paste0("`funs` has ", length(are_functions), " elements"))
      )
    }
  } else {
    if (!is.null(.nms)) {
      if (length(.nms) != length(are_functions)) {
        abort(
          c("`name.sep` must be the same length as `funs`:",
            "x" = paste0("`name.sep` has ", length(.nms), " elements"),
            "x" = paste0("`funs` has ", length(are_functions), " elements"))
        )
      }
    }
  }
  list(c(.fns), c(.nms))
}

# Standardize indexes or column names into column indexes
convert_cols_to_index <- function(which.cols, dat) {
  vals <- colnames(dat)
  col_range <- 1:ncol(dat)
  if (!(is.numeric(which.cols) || is.character(which.cols))) {
    abort(
      c(
        "`which` must specify columns by numeric indeces or column names:",
        "x" = paste("You've supplied an object of class", class(which.cols))
      )
    )
  }
  if (is.numeric(which.cols)) {
    if (any(!which.cols %in% col_range)) {
      problem_idx <- !which.cols %in% col_range
      if (sum(problem_idx) > 5) {
        abort(
          c(
            paste0(
              "Column indices are invalid: ",
              paste0(
                which.cols[!which.cols %in% col_range][1:5],
                collapse = ", "
              ),
              ", ..."
            )
          )
        )
      } else {
        abort(
          c(
            paste0(
              "Column indices are invalid: ",
              paste0(
                which.cols[!which.cols %in% col_range],
                collapse = ", "
              )
            )
          )
        )
      }
    }
    return(which.cols)
  }
  if (any(!which.cols %in% vals)) {
    problem_idx <- !which.cols %in% vals
    abort(
      if (sum(problem_idx) > 5) {
        c(
          paste0(
            "Can't find specified column names in the matrix: `",
            paste0(
              which.cols[!which.cols %in% vals][1:5],
              collapse = "`, `"
            ),
            "`, ..."
          )
        )
      } else {
        c(
          paste0(
            "Can't find specified column names in the matrix: `",
            paste0(
              which.cols[!which.cols %in% vals],
              collapse = "`, `"
            ),
            "`"
          )
        )
      }
    )
  }
  which(vals %in% which.cols)
}

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
#' @param fns A user-supplied function, or list of functions, to apply to the
#'   specified columns.
#' @param ... Additional arguments to pass to `fns`. It is important to note
#'   that these arguments will be passed to every function in `fns`, and so
#'   should only include arguments that are relevant to each function.
#' @param which.cols A numeric vector indicating column indices or a character
#'   vector indicating column names.
#' @param drop A logical value. If the functions in `fns` work with columnar
#'   matrices, then set `drop = FALSE`, otherwise if the functions in `fns`
#'   require a numeric vector, set `drop = TRUE`. When working with large sparse
#'   matrices, it is essential to set `drop = FALSE`, as the alternative will
#'   be much more memory intensive.
#' @param name.sep A `NULL` value or a list corresponding to each element of
#'   `fns`. If `name.sep` is `NULL` the specified columns will be transformed
#'   in-place, provided `length(fns) == 1`. If `fns` has more than one element,
#'   and `name.sep` is `NULL`, it will default to a numeric vector that is equal
#'   to `length(fns)`. If `name.sep` is provided as a list, each element of this
#'   list must contain a character vector of length 1 or `nrow(x)` that will
#'   be appended to existing column names to create new column names. Providing
#'   this argument ensures that the transformed columns will be appended as new
#'   matrix columns.
#'
#' @examples
#' x <- Matrix::rsparsematrix(10, 4, .9)
#' colnames(x) <- paste0("x", 1:4)
#' x
#'
#' # Convert columns in-place with a single function
#' transform_cols(x, fns = function(i) i^2, which.cols = 3:4)
#' transform_cols(x, fns = function(i) i^2, which.cols = c("x3", "x4"))
#'
#' # Mutate new columns with a single function
#' transform_cols(x, fns = scale, which.cols = 3:4, name.sep = "scaled")
#'
#' # Mutate new columns with a list of functions and names
#' transform_cols(
#'   x,
#'   fns = c(function(i) i^2, function(i) i^3),
#'   which.cols = 3:4,
#'   name.sep = c("squared", "cubed")
#' )
#'
#' # Mutate new columns with a list of functions and names for each new column
#' transform_cols(
#'   x,
#'   fns = c(function(i) i^2, function(i) i^3),
#'   which.cols = 3:4,
#'   name.sep = list(paste0("squared", 1:2), paste0("cubed", 1:2))
#' )
#'
#' @export
transform_cols <- function(x, fns, ..., which.cols, drop, name.sep) {
  UseMethod("transform_cols")
}

#' @method transform_cols CsparseMatrix
#' @rdname transform_cols
#' @export
transform_cols.CsparseMatrix <- function(x, fns, ..., which.cols, drop = FALSE, name.sep = NULL) {
  funs_and_names <- check_functions_and_names(fns, name.sep)
  which.cols <- convert_cols_to_index(which.cols, x)
  col_order <- c(setdiff(1:ncol(x), which.cols), which.cols)
  fns <- funs_and_names[[1]]
  name.sep <- funs_and_names[[2]]
  if (is.null(name.sep)) {
    x <- do.call(
      cbind,
      append(
        list(x[, -which.cols, drop = FALSE]),
        lapply(
          seq_along(fns),
          function(i) {
            apply_sparse_mat(
              x = x[, which.cols, drop = FALSE],
              .f = fns[[i]],
              ... = ...,
              drop = drop,
              append.names = name.sep[[i]]
            )
          }
        )
      )
    )[
      ,
      col_order
    ]
  } else {
    x <- do.call(
      cbind,
      append(
        list(x),
        lapply(
          seq_along(fns),
          function(i) {
            apply_sparse_mat(
              x = x[, which.cols, drop = FALSE],
              .f = fns[[i]],
              ... = ...,
              drop = drop,
              append.names = name.sep[[i]]
            )
          }
        )
      )
    )
  }
  x
}

#' @method transform_cols matrix
#' @rdname transform_cols
#' @export
transform_cols.matrix <- function(x, fns, ..., which.cols, drop = FALSE, name.sep = NULL) {
  funs_and_names <- check_functions_and_names(fns, name.sep)
  which.cols <- convert_cols_to_index(which.cols, x)
  col_order <- c(setdiff(1:ncol(x), which.cols), which.cols)
  fns <- funs_and_names[[1]]
  name.sep <- funs_and_names[[2]]
  if (is.null(name.sep)) {
    x <- do.call(
      cbind,
      append(
        list(x[, -which.cols, drop = FALSE]),
        lapply(
          seq_along(fns),
          function(i) {
            apply_sparse_mat(
              x = x[, which.cols, drop = FALSE],
              .f = fns[[i]],
              ... = ...,
              drop = drop,
              append.names = name.sep[[i]]
            )
          }
        )
      )
    )[
      ,
      col_order
    ]
  } else {
    x <- do.call(
      cbind,
      append(
        list(x),
        lapply(
          seq_along(fns),
          function(i) {
            apply_sparse_mat(
              x = x[, which.cols, drop = FALSE],
              .f = fns[[i]],
              ... = ...,
              drop = drop,
              append.names = name.sep[[i]]
            )
          }
        )
      )
    )
  }
  x
}
