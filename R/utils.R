# Apply a function to sparse matrix columns in an lapply-esque manner
apply_sparse_mat <- function(x, .f, ..., drop = TRUE, append.names = NULL, simplify = TRUE) {
  stopifnot(inherits(x, "dgCMatrix") || inherits(x, "matrix"))
  if (ncol(x) < 1) return(x)
  col.names <- colnames(x)
  colnames(x) <- NULL
  adtl_args <- list(...)
  out <- vector(mode = "list", length = ncol(x))
  for (i in 1:ncol(x)) {
    out[[i]] <- do.call(.f, args = append(list(x[, i, drop = drop]), adtl_args))
  }
  if (!is.null(append.names) && !is.null(col.names)) {
    if (length(append.names) == 1 || length(append.names) == ncol(x)) {
      col.names <- paste0(col.names, "_", append.names)
    } else {
      warning("`append.names` must be length 1 or ", ncol(x), " - Continuing without changing column names", call. = FALSE)
    }
  }
  if (simplify) {
    out <- do.call(cbind, out)
    colnames(out) <- col.names
  } else {
    names(out) <- col.names
  }
  out
}
