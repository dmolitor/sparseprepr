
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sparseprepr

<!-- badges: start -->

[![R-CMD-check](https://github.com/dmolitor/sparseprepr/workflows/R-CMD-check/badge.svg)](https://github.com/dmolitor/sparseprepr/actions)
[![Codecov test
coverage](https://codecov.io/gh/dmolitor/sparseprepr/branch/main/graph/badge.svg?token=PCAC1RA7GE)](https://codecov.io/gh/dmolitor/sparseprepr?branch=main)
[![pkgdown](https://github.com/dmolitor/sparseprepr/workflows/pkgdown/badge.svg)](https://github.com/dmolitor/sparseprepr/actions)
<!-- badges: end -->

The goal of sparseprepr is to enable common pre-processing actions for
sparse matrices and provide a more memory-efficient workflow for
modeling at scale.

## Installation

Install from [Github](https://github.com) with:

    # install.packages(devtools)
    devtools::install_github("dmolitor/sparseprepr")

## Scope

sparseprepr functionality only supports sparse matrices coded in sorted
compressed column-oriented form, formally of class `CsparseMatrix`.
Although the `Matrix` package also defines sorted compressed
row-oriented form (`RsparseMatrix`) and triplet form (`TsparseMatrix`)
sparse matrices, it makes clear that “most operations with sparse
matrices are performed using the compressed, column-oriented or
CsparseMatrix representation,” and that even when matrices are created
in the `TsparseMatrix` or `RsparseMatrix` forms for convenience, “once
it is created, however, the matrix is generally coerced to a
CsparseMatrix for further operations.”

## Core Functionality

The following toy example shows a number of the pre-processing features
that sparseprepr provides.

``` r
library(sparseprepr)
#> 
#> Attaching package: 'sparseprepr'
#> The following object is masked from 'package:stats':
#> 
#>     cor

x
#> 10 x 8 sparse Matrix of class "dgCMatrix"
#>           x1    x2     x3 cor_with_x3 const_col const_col2 dup_x2 sparse_col
#>  [1,] -0.075  0.23  0.170        0.17         1          .   0.23          .
#>  [2,]  0.700  0.41 -0.840       -0.84         1          .   0.41          .
#>  [3,] -1.400 -1.50 -0.540       -0.54         1          .  -1.50          .
#>  [4,] -0.370  .     0.500        0.50         1          .   .             .
#>  [5,] -0.260  1.30  .            .            1          .   1.30          .
#>  [6,] -0.840 -2.70  0.840        0.84         1          .  -2.70          .
#>  [7,]  1.600  .    -0.170       -0.17         1          .   .             .
#>  [8,]  1.000  0.77 -2.200       -2.20         1          .   0.77          .
#>  [9,]  2.200 -0.35  0.060        0.06         1          .  -0.35          .
#> [10,] -1.300 -0.90 -0.849       -0.85         1          .  -0.90          1
```

The matrix shown above has a number of contrived features; column
`cor_with_x3` is highly correlated with column `x3`, `const_col` and
`const_col2` are zero-variance columns, `dup_x2` is identical to `x2`,
and `sparse_col` is a highly sparse column. Common pre-processing steps
provided by sparseprepr include:

-   Dropping highly correlated columns

    ``` r
    remove_correlated(x, threshold = 0.99)
    #> Warning: Column(s) 5, 6 have a standard deviation of 0
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 const_col const_col2 sparse_col
    #>  [1,] -0.075  0.23  0.170         1          .          .
    #>  [2,]  0.700  0.41 -0.840         1          .          .
    #>  [3,] -1.400 -1.50 -0.540         1          .          .
    #>  [4,] -0.370  .     0.500         1          .          .
    #>  [5,] -0.260  1.30  .             1          .          .
    #>  [6,] -0.840 -2.70  0.840         1          .          .
    #>  [7,]  1.600  .    -0.170         1          .          .
    #>  [8,]  1.000  0.77 -2.200         1          .          .
    #>  [9,]  2.200 -0.35  0.060         1          .          .
    #> [10,] -1.300 -0.90 -0.849         1          .          1
    ```

-   Dropping empty columns

    ``` r
    remove_empty(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col dup_x2 sparse_col
    #>  [1,] -0.075  0.23  0.170        0.17         1   0.23          .
    #>  [2,]  0.700  0.41 -0.840       -0.84         1   0.41          .
    #>  [3,] -1.400 -1.50 -0.540       -0.54         1  -1.50          .
    #>  [4,] -0.370  .     0.500        0.50         1   .             .
    #>  [5,] -0.260  1.30  .            .            1   1.30          .
    #>  [6,] -0.840 -2.70  0.840        0.84         1  -2.70          .
    #>  [7,]  1.600  .    -0.170       -0.17         1   .             .
    #>  [8,]  1.000  0.77 -2.200       -2.20         1   0.77          .
    #>  [9,]  2.200 -0.35  0.060        0.06         1  -0.35          .
    #> [10,] -1.300 -0.90 -0.849       -0.85         1  -0.90          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,] -0.075  0.23  0.170        0.17   0.23          .
    #>  [2,]  0.700  0.41 -0.840       -0.84   0.41          .
    #>  [3,] -1.400 -1.50 -0.540       -0.54  -1.50          .
    #>  [4,] -0.370  .     0.500        0.50   .             .
    #>  [5,] -0.260  1.30  .            .      1.30          .
    #>  [6,] -0.840 -2.70  0.840        0.84  -2.70          .
    #>  [7,]  1.600  .    -0.170       -0.17   .             .
    #>  [8,]  1.000  0.77 -2.200       -2.20   0.77          .
    #>  [9,]  2.200 -0.35  0.060        0.06  -0.35          .
    #> [10,] -1.300 -0.90 -0.849       -0.85  -0.90          1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,] -0.075  0.23  0.170        0.17         1          .          .
    #>  [2,]  0.700  0.41 -0.840       -0.84         1          .          .
    #>  [3,] -1.400 -1.50 -0.540       -0.54         1          .          .
    #>  [4,] -0.370  .     0.500        0.50         1          .          .
    #>  [5,] -0.260  1.30  .            .            1          .          .
    #>  [6,] -0.840 -2.70  0.840        0.84         1          .          .
    #>  [7,]  1.600  .    -0.170       -0.17         1          .          .
    #>  [8,]  1.000  0.77 -2.200       -2.20         1          .          .
    #>  [9,]  2.200 -0.35  0.060        0.06         1          .          .
    #> [10,] -1.300 -0.90 -0.849       -0.85         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,] -0.075  0.23  0.170        0.17         1   0.23
    #>  [2,]  0.700  0.41 -0.840       -0.84         1   0.41
    #>  [3,] -1.400 -1.50 -0.540       -0.54         1  -1.50
    #>  [4,] -0.370  .     0.500        0.50         1   .   
    #>  [5,] -0.260  1.30  .            .            1   1.30
    #>  [6,] -0.840 -2.70  0.840        0.84         1  -2.70
    #>  [7,]  1.600  .    -0.170       -0.17         1   .   
    #>  [8,]  1.000  0.77 -2.200       -2.20         1   0.77
    #>  [9,]  2.200 -0.35  0.060        0.06         1  -0.35
    #> [10,] -1.300 -0.90 -0.849       -0.85         1  -0.90
    ```

-   Transforming matrix columns:

    ``` r
    # Append squared terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^2, 
      which.cols = paste0("x", 2:3), 
      name.sep = "squared"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 x2_squared x3_squared
    #>  [1,] -0.075  0.23  0.170     0.0529   0.028900
    #>  [2,]  0.700  0.41 -0.840     0.1681   0.705600
    #>  [3,] -1.400 -1.50 -0.540     2.2500   0.291600
    #>  [4,] -0.370  .     0.500     .        0.250000
    #>  [5,] -0.260  1.30  .         1.6900   .       
    #>  [6,] -0.840 -2.70  0.840     7.2900   0.705600
    #>  [7,]  1.600  .    -0.170     .        0.028900
    #>  [8,]  1.000  0.77 -2.200     0.5929   4.840000
    #>  [9,]  2.200 -0.35  0.060     0.1225   0.003600
    #> [10,] -1.300 -0.90 -0.849     0.8100   0.720801

    # Append cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which.cols = paste0("x", 2:3), 
      name.sep = "cubed"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3   x2_cubed   x3_cubed
    #>  [1,] -0.075  0.23  0.170   0.012167   0.004913
    #>  [2,]  0.700  0.41 -0.840   0.068921  -0.592704
    #>  [3,] -1.400 -1.50 -0.540  -3.375000  -0.157464
    #>  [4,] -0.370  .     0.500   .          0.125000
    #>  [5,] -0.260  1.30  .       2.197000   .       
    #>  [6,] -0.840 -2.70  0.840 -19.683000   0.592704
    #>  [7,]  1.600  .    -0.170   .         -0.004913
    #>  [8,]  1.000  0.77 -2.200   0.456533 -10.648000
    #>  [9,]  2.200 -0.35  0.060  -0.042875   0.000216
    #> [10,] -1.300 -0.90 -0.849  -0.729000  -0.611960
    ```

## Pipe Workflow

These same pre-processing steps can be utilized in a more user-friendly
manner via the magrittr pipe (`%>%`) or the base pipe (`|>` - R 4.1 or
greater).

``` r
x |>
  remove_constant() |>
  remove_correlated(threshold = 0.99) |>
  remove_duplicate() |>
  remove_sparse(threshold = 0.9) |>
  transform_cols(
    fun = function(i) i ^ 2,
    which.cols = paste0("x", 2:3),
    name.sep = "squared"
  ) |>
  transform_cols(
    fun = function(i) i ^ 3,
    which.cols = paste0("x", 2:3),
    name.sep = "cubed"
  )
#> 10 x 7 sparse Matrix of class "dgCMatrix"
#>           x1    x2     x3 x2_squared x3_squared   x2_cubed   x3_cubed
#>  [1,] -0.075  0.23  0.170     0.0529   0.028900   0.012167   0.004913
#>  [2,]  0.700  0.41 -0.840     0.1681   0.705600   0.068921  -0.592704
#>  [3,] -1.400 -1.50 -0.540     2.2500   0.291600  -3.375000  -0.157464
#>  [4,] -0.370  .     0.500     .        0.250000   .          0.125000
#>  [5,] -0.260  1.30  .         1.6900   .          2.197000   .       
#>  [6,] -0.840 -2.70  0.840     7.2900   0.705600 -19.683000   0.592704
#>  [7,]  1.600  .    -0.170     .        0.028900   .         -0.004913
#>  [8,]  1.000  0.77 -2.200     0.5929   4.840000   0.456533 -10.648000
#>  [9,]  2.200 -0.35  0.060     0.1225   0.003600  -0.042875   0.000216
#> [10,] -1.300 -0.90 -0.849     0.8100   0.720801  -0.729000  -0.611960
```
