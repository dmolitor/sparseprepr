# Apply a function to sparse matrix columns in an lapply-esque manner
apply_sparse_mat <- function(x, .f, ..., drop = TRUE) {
  stopifnot(inherits(x, "dgCMatrix"))
  adtl_args <- list(...)
  if (ncol(x) < 1) return(x)
  out <- vector(mode = "list", length = ncol(x))
  for (i in 1:ncol(x)) {
    out[[i]] <- do.call(.f, args = append(list(x[, i, drop = drop]), adtl_args))
  }
  out
}

# # Test the memory usage
# m <- lapply(1:10, function(i) {
#   r <- Matrix::rsparsematrix(100000 * i, 20, 0.1)
#   bench::mark(
#     unlist(apply_sparse_mat(r, mean, drop = TRUE)),
#     unlist(apply_sparse_mat(r, Matrix::mean, drop = FALSE)),
#     Matrix::colMeans(r),
#     iterations = 10
#   )
# })
#
# m %>%
#   lapply(function(i) i %>% mutate(expression = as.character(expression))) %>%
#   bind_rows() %>%
#   group_by(expression) %>%
#   mutate("num_row" = seq(100000, 1000000, by = 100000)) %>%
#   tidyr::pivot_longer(cols = c(min, median),
#                       names_to = "name",
#                       values_to = "val") %>%
#   mutate("val" = as.numeric(val)) %>%
#   select(expression, mem_alloc, num_row, name, val) %>%
#   ungroup() %>%
#   ggplot(aes(x = num_row, y = val, linetype = name, color = expression)) +
#   geom_line() +
#   theme_minimal() +
#   labs(x = "Number of Rows",
#        y = "Time (Seconds)",
#        title = "Benchmark apply vs. apply_sparse_mat") +
#   theme(plot.title = element_text(face = "bold", hjust = 0.5),
#         legend.title = element_blank(),
#         axis.title = element_text(face = "bold"))
#
# m %>%
#   lapply(function(i) i %>% mutate(expression = as.character(expression))) %>%
#   bind_rows() %>%
#   group_by(expression) %>%
#   mutate("num_row" = seq(100000, 1000000, by = 100000)) %>%
#   mutate("mem_alloc" = as.numeric(mem_alloc)/1000000) %>%
#   select(expression, mem_alloc, num_row) %>%
#   ungroup() %>%
#   ggplot(aes(x = num_row, y = mem_alloc, color = expression)) +
#   geom_line() +
#   theme_minimal() +
#   labs(x = "Number of Rows",
#        y = "Memory (MB)",
#        title = "Benchmark apply vs. apply_sparse_mat") +
#   theme(plot.title = element_text(face = "bold", hjust = 0.5),
#         legend.title = element_blank(),
#         axis.title = element_text(face = "bold"))
