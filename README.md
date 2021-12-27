
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
#>  [1,]  2.100 -0.79 -0.810       -0.81         1          .  -0.79          .
#>  [2,]  0.051  1.50  1.400        1.40         1          .   1.50          .
#>  [3,]  .     -0.51 -0.970       -0.97         1          .  -0.51          .
#>  [4,]  .      1.70  0.220        0.22         1          .   1.70          .
#>  [5,]  0.740  1.60 -0.470       -0.47         1          .   1.60          .
#>  [6,] -0.065  0.24 -1.500       -1.50         1          .   0.24          .
#>  [7,]  0.110 -0.11 -0.340       -0.34         1          .  -0.11          .
#>  [8,]  0.640  0.92 -1.400       -1.40         1          .   0.92          .
#>  [9,] -1.600 -1.10  1.200        1.20         1          .  -1.10          .
#> [10,]  0.240  .     1.101        1.10         1          .   .             1
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
    #>  [1,]  2.100 -0.79 -0.810         1          .          .
    #>  [2,]  0.051  1.50  1.400         1          .          .
    #>  [3,]  .     -0.51 -0.970         1          .          .
    #>  [4,]  .      1.70  0.220         1          .          .
    #>  [5,]  0.740  1.60 -0.470         1          .          .
    #>  [6,] -0.065  0.24 -1.500         1          .          .
    #>  [7,]  0.110 -0.11 -0.340         1          .          .
    #>  [8,]  0.640  0.92 -1.400         1          .          .
    #>  [9,] -1.600 -1.10  1.200         1          .          .
    #> [10,]  0.240  .     1.101         1          .          1
    ```

-   Dropping empty columns

    ``` r
    remove_empty(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col dup_x2 sparse_col
    #>  [1,]  2.100 -0.79 -0.810       -0.81         1  -0.79          .
    #>  [2,]  0.051  1.50  1.400        1.40         1   1.50          .
    #>  [3,]  .     -0.51 -0.970       -0.97         1  -0.51          .
    #>  [4,]  .      1.70  0.220        0.22         1   1.70          .
    #>  [5,]  0.740  1.60 -0.470       -0.47         1   1.60          .
    #>  [6,] -0.065  0.24 -1.500       -1.50         1   0.24          .
    #>  [7,]  0.110 -0.11 -0.340       -0.34         1  -0.11          .
    #>  [8,]  0.640  0.92 -1.400       -1.40         1   0.92          .
    #>  [9,] -1.600 -1.10  1.200        1.20         1  -1.10          .
    #> [10,]  0.240  .     1.101        1.10         1   .             1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,]  2.100 -0.79 -0.810       -0.81  -0.79          .
    #>  [2,]  0.051  1.50  1.400        1.40   1.50          .
    #>  [3,]  .     -0.51 -0.970       -0.97  -0.51          .
    #>  [4,]  .      1.70  0.220        0.22   1.70          .
    #>  [5,]  0.740  1.60 -0.470       -0.47   1.60          .
    #>  [6,] -0.065  0.24 -1.500       -1.50   0.24          .
    #>  [7,]  0.110 -0.11 -0.340       -0.34  -0.11          .
    #>  [8,]  0.640  0.92 -1.400       -1.40   0.92          .
    #>  [9,] -1.600 -1.10  1.200        1.20  -1.10          .
    #> [10,]  0.240  .     1.101        1.10   .             1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  2.100 -0.79 -0.810       -0.81         1          .          .
    #>  [2,]  0.051  1.50  1.400        1.40         1          .          .
    #>  [3,]  .     -0.51 -0.970       -0.97         1          .          .
    #>  [4,]  .      1.70  0.220        0.22         1          .          .
    #>  [5,]  0.740  1.60 -0.470       -0.47         1          .          .
    #>  [6,] -0.065  0.24 -1.500       -1.50         1          .          .
    #>  [7,]  0.110 -0.11 -0.340       -0.34         1          .          .
    #>  [8,]  0.640  0.92 -1.400       -1.40         1          .          .
    #>  [9,] -1.600 -1.10  1.200        1.20         1          .          .
    #> [10,]  0.240  .     1.101        1.10         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,]  2.100 -0.79 -0.810       -0.81         1  -0.79
    #>  [2,]  0.051  1.50  1.400        1.40         1   1.50
    #>  [3,]  .     -0.51 -0.970       -0.97         1  -0.51
    #>  [4,]  .      1.70  0.220        0.22         1   1.70
    #>  [5,]  0.740  1.60 -0.470       -0.47         1   1.60
    #>  [6,] -0.065  0.24 -1.500       -1.50         1   0.24
    #>  [7,]  0.110 -0.11 -0.340       -0.34         1  -0.11
    #>  [8,]  0.640  0.92 -1.400       -1.40         1   0.92
    #>  [9,] -1.600 -1.10  1.200        1.20         1  -1.10
    #> [10,]  0.240  .     1.101        1.10         1   .
    ```

-   Transforming matrix columns:

    ``` r
    # Append squared terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^2, 
      which = paste0("x", 2:3), 
      name.sep = "squared"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 x2_squared x3_squared
    #>  [1,]  2.100 -0.79 -0.810     0.6241   0.656100
    #>  [2,]  0.051  1.50  1.400     2.2500   1.960000
    #>  [3,]  .     -0.51 -0.970     0.2601   0.940900
    #>  [4,]  .      1.70  0.220     2.8900   0.048400
    #>  [5,]  0.740  1.60 -0.470     2.5600   0.220900
    #>  [6,] -0.065  0.24 -1.500     0.0576   2.250000
    #>  [7,]  0.110 -0.11 -0.340     0.0121   0.115600
    #>  [8,]  0.640  0.92 -1.400     0.8464   1.960000
    #>  [9,] -1.600 -1.10  1.200     1.2100   1.440000
    #> [10,]  0.240  .     1.101     .        1.212201

    # Append cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 2:3), 
      name.sep = "cubed"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3  x2_cubed  x3_cubed
    #>  [1,]  2.100 -0.79 -0.810 -0.493039 -0.531441
    #>  [2,]  0.051  1.50  1.400  3.375000  2.744000
    #>  [3,]  .     -0.51 -0.970 -0.132651 -0.912673
    #>  [4,]  .      1.70  0.220  4.913000  0.010648
    #>  [5,]  0.740  1.60 -0.470  4.096000 -0.103823
    #>  [6,] -0.065  0.24 -1.500  0.013824 -3.375000
    #>  [7,]  0.110 -0.11 -0.340 -0.001331 -0.039304
    #>  [8,]  0.640  0.92 -1.400  0.778688 -2.744000
    #>  [9,] -1.600 -1.10  1.200 -1.331000  1.728000
    #> [10,]  0.240  .     1.101  .         1.334633
    ```

## Piping Workflow

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
    which = paste0("x", 2:3),
    name.sep = "squared"
  ) |>
  transform_cols(
    fun = function(i) i ^ 3,
    which = paste0("x", 2:3),
    name.sep = "cubed"
  )
#> 10 x 7 sparse Matrix of class "dgCMatrix"
#>           x1    x2     x3 x2_squared x3_squared  x2_cubed  x3_cubed
#>  [1,]  2.100 -0.79 -0.810     0.6241   0.656100 -0.493039 -0.531441
#>  [2,]  0.051  1.50  1.400     2.2500   1.960000  3.375000  2.744000
#>  [3,]  .     -0.51 -0.970     0.2601   0.940900 -0.132651 -0.912673
#>  [4,]  .      1.70  0.220     2.8900   0.048400  4.913000  0.010648
#>  [5,]  0.740  1.60 -0.470     2.5600   0.220900  4.096000 -0.103823
#>  [6,] -0.065  0.24 -1.500     0.0576   2.250000  0.013824 -3.375000
#>  [7,]  0.110 -0.11 -0.340     0.0121   0.115600 -0.001331 -0.039304
#>  [8,]  0.640  0.92 -1.400     0.8464   1.960000  0.778688 -2.744000
#>  [9,] -1.600 -1.10  1.200     1.2100   1.440000 -1.331000  1.728000
#> [10,]  0.240  .     1.101     .        1.212201  .         1.334633
```
